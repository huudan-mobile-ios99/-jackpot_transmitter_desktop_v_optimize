import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_hive_service.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_state_state.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:web_socket_channel/io.dart';
import 'jackpot_price_event.dart';

class JackpotPriceBloc extends Bloc<JackpotPriceEvent, JackpotPriceState> {
  late IOWebSocketChannel channel;
  final int secondToReconnect = ConfigCustom.secondToReConnect;
  final List<String> _unknownLevels = [];
  final Map<String, bool> _isFirstUpdate = {
    for (var name in ConfigCustom.validJackpotNames) name: true,
  };
  Map<String, double> _currentBatchValues = {};
  final Map<String, DateTime> _lastUpdateTime = {};
  static final Duration _debounceDuration = Duration(seconds: ConfigCustom.durationGetDataToBloc);
  static final Duration _firstUpdateDelay = Duration(milliseconds: ConfigCustom.durationGetDataToBlocFirstMS);
  final hiveService = JackpotHiveService();

  JackpotPriceBloc() : super(JackpotPriceState.initial()) {
    on<JackpotPriceUpdateEvent>(_onUpdate);
    on<JackpotPriceResetEvent>(_onReset);
    on<JackpotPriceConnectionEvent>(_onConnection);
    debugPrint('JackpotPriceBloc: Initializing WebSocket connection to ${ConfigCustom.endpointWebSocket}');
    _connectToWebSocket();
  }

  void _connectToWebSocket() {
    try {
      debugPrint('JackpotPriceBloc: Connecting to WebSocket');
      channel = IOWebSocketChannel.connect(ConfigCustom.endpointWebSocket);
      add(JackpotPriceConnectionEvent(true));
      channel.stream.listen(
        (message) async {
          try {
            final data = jsonDecode(message);
            final level = data['Id'].toString();
            final value = double.tryParse(data['Value'].toString()) ?? 0.0;
            final key = ConfigCustom.getJackpotNameByLevel(level);
            if (key == null) {
              if (!_unknownLevels.contains(level)) {
                _unknownLevels.add(level);
                debugPrint('JackpotPriceBloc: Unknown level: $level, tracked: $_unknownLevels');
                if (_unknownLevels.length > 5) {
                  debugPrint('JackpotPriceBloc: Excessive unknown levels: $_unknownLevels');
                }
              }
              return;
            }

            _currentBatchValues[key] = value;
            add(JackpotPriceUpdateEvent(level, value));

            if (_currentBatchValues.length == ConfigCustom.validJackpotNames.length &&
                _currentBatchValues.values.every((v) => v != 0.0)) {
              try {
                await hiveService.initHive();
                await hiveService.appendJackpotHistory(Map.from(_currentBatchValues));
                debugPrint('JackpotPriceBloc: Saved to Hive: $_currentBatchValues');
                _currentBatchValues = {};
              } catch (e) {
                debugPrint('JackpotPriceBloc: Failed to save to Hive: $e');
              }
            }
          } catch (e) {
            debugPrint('JackpotPriceBloc: Error parsing message: $e');
          }
        },
        onError: (error) {
          debugPrint('JackpotPriceBloc: WebSocket error: $error');
          add(JackpotPriceConnectionEvent(false, error: error.toString()));
          Future.delayed(Duration(seconds: secondToReconnect), _connectToWebSocket);
        },
        onDone: () {
          debugPrint('JackpotPriceBloc: WebSocket closed');
          add(JackpotPriceConnectionEvent(false));
          Future.delayed(Duration(seconds: secondToReconnect), _connectToWebSocket);
        },
      );
    } catch (e) {
      debugPrint('JackpotPriceBloc: Failed to connect to WebSocket: $e');
      add(JackpotPriceConnectionEvent(false, error: e.toString()));
      Future.delayed(Duration(seconds: secondToReconnect), _connectToWebSocket);
    }
  }

  Future<void> _onUpdate(JackpotPriceUpdateEvent event, Emitter<JackpotPriceState> emit) async {
    final level = event.level;
    final newValue = event.value;
    final key = ConfigCustom.getJackpotNameByLevel(level);
    if (key == null) {
      if (!_unknownLevels.contains(level)) {
        _unknownLevels.add(level);
        debugPrint('JackpotPriceBloc: Unknown level: $level, tracked: $_unknownLevels');
        if (_unknownLevels.length > 5) {
          debugPrint('JackpotPriceBloc: Excessive unknown levels: $_unknownLevels');
        }
      }
      return;
    }

    final isFirst = _isFirstUpdate[key] ?? false;
    final now = DateTime.now();
    final lastUpdate = _lastUpdateTime[key];

    if (!isFirst && lastUpdate != null && now.difference(lastUpdate) < _debounceDuration) {
      debugPrint('JackpotPriceBloc: Skipping update for $key due to debounce');
      return;
    }
    await Future.delayed(isFirst ? _firstUpdateDelay : _debounceDuration);

    final jackpotValues = Map<String, double>.from(state.jackpotValues);
    final previousJackpotValues = Map<String, double>.from(state.previousJackpotValues);

    if (jackpotValues[key] != newValue) {
      previousJackpotValues[key] = jackpotValues[key] ?? 0.0;
      jackpotValues[key] = newValue;
      _lastUpdateTime[key] = now;
      if (isFirst) {
        _isFirstUpdate[key] = false;
      }
      final validKeys = ConfigCustom.validJackpotNames.toSet();
      jackpotValues.removeWhere((k, v) => !validKeys.contains(k));
      previousJackpotValues.removeWhere((k, v) => !validKeys.contains(k));
      // debugPrint('JackpotPriceBloc onUpdate: $key updated to $newValue, jackpotValues: $jackpotValues');
      emit(state.copyWith(
        jackpotValues: jackpotValues,
        previousJackpotValues: previousJackpotValues,
        isConnected: true,
        error: null,
      ));
    } else {
      // debugPrint('JackpotPriceBloc: Skipped update for $key: value unchanged ($newValue)');
    }
  }

  Future<void> _onReset(JackpotPriceResetEvent event, Emitter<JackpotPriceState> emit) async {
    final key = ConfigCustom.getJackpotNameByLevel(event.level);
    if (key == null) {
      debugPrint('JackpotPriceBloc: Unknown level for reset: ${event.level}');
      return;
    }

    final resetValue = ConfigCustom.getResetValueByLevel(event.level);
    if (resetValue == null) {
      debugPrint('JackpotPriceBloc: No reset value found for $key');
      return;
    }

    final jackpotValues = Map<String, double>.from(state.jackpotValues);
    final previousJackpotValues = Map<String, double>.from(state.previousJackpotValues);

    previousJackpotValues[key] = jackpotValues[key] ?? 0.0;
    jackpotValues[key] = resetValue;
    _lastUpdateTime[key] = DateTime.now();
    _isFirstUpdate[key] = false;
    debugPrint('JackpotPriceBloc: Reset $key to $resetValue');
    emit(state.copyWith(
      jackpotValues: jackpotValues,
      previousJackpotValues: previousJackpotValues,
      isConnected: true,
      error: null,
    ));

    _currentBatchValues[key] = resetValue;
    try {
      await hiveService.initHive();
      await hiveService.appendJackpotHistory(Map.from(_currentBatchValues));
      debugPrint('JackpotPriceBloc: Saved reset to Hive: $_currentBatchValues');
      _currentBatchValues = {};
    } catch (e) {
      debugPrint('JackpotPriceBloc: Failed to save reset to Hive: $e');
    }
  }

  Future<void> _onConnection(JackpotPriceConnectionEvent event, Emitter<JackpotPriceState> emit) async {
    debugPrint('JackpotPriceBloc: Connection status changed: isConnected=${event.isConnected}, error=${event.error}');
    emit(state.copyWith(
      isConnected: event.isConnected,
      error: event.error,
    ));
  }

  @override
  Future<void> close() {
    debugPrint('JackpotPriceBloc: Closing WebSocket');
    channel.sink.close(1000, 'Bloc closed');
    return super.close();
  }
}

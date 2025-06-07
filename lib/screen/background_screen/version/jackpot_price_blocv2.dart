import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_hive_service.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_state_state.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:web_socket_channel/io.dart';
import '../bloc_jp_price/jackpot_price_event.dart';

class JackpotPriceBlocV2 extends Bloc<JackpotPriceEvent, JackpotPriceState> {
  late IOWebSocketChannel channel;
  final int secondToReconnect = ConfigCustom.secondToReConnect;
  final List<String> _unknownLevels = [];
  // Track first update for each jackpot type
  final Map<String, bool> _isFirstUpdate = {
    'Frequent': true,
    'Daily': true,
    'Dozen': true,
    'Weekly': true,
    'HighLimit': true,
    'DailyGolden': true,
    'Triple': true,
    'Monthly': true,
    'Vegas': true,
  };
  Map<String, double> _currentBatchValues = {};

  // Track last processed timestamp for debouncing
  final Map<String, DateTime> _lastUpdateTime = {};
  static final Duration _debounceDuration =  Duration(seconds: ConfigCustom.durationGetDataToBloc);
  static final Duration _firstUpdateDelay = Duration(milliseconds:ConfigCustom.durationGetDataToBlocFirstMS);
  final hiveService = JackpotHiveService();

  JackpotPriceBlocV2() : super(JackpotPriceState.initial()) {
    on<JackpotPriceUpdateEvent>(_onUpdate);
    on<JackpotPriceConnectionEvent>(_onConnection);
    debugPrint('JackpotPriceBlocV2: Initializing WebSocket connection to ${ConfigCustom.endpoint_web_socket}');
    _connectToWebSocket();
  }

  void _connectToWebSocket() {
    try {
      debugPrint('JackpotPriceBlocV2: Connecting to WebSocket');
      channel = IOWebSocketChannel.connect(ConfigCustom.endpoint_web_socket);
      add(JackpotPriceConnectionEvent(true));
      channel.stream.listen(
        (message) async {
          try {
            final data = jsonDecode(message);
            final level = data['Id'].toString();
            final value = double.tryParse(data['Value'].toString()) ?? 0.0;
            // debugPrint('JackpotPriceBlocV2: $level $value');
            // Map level to key
            String? key;
            switch (level) {
              case "0":
                key = 'Frequent';
                break;
              case "1":
                key = 'Daily';
                break;
              case "2":
                key = 'Dozen';
                break;
              case "3":
                key = 'Weekly';
                break;
              // case "18":
              //   key = 'HighLimit';
              //   break;
              case "45":
                key = 'HighLimit';
                break;
              case "34":
                key = 'DailyGolden';
                break;
              case "35":
                key = 'Triple';
                break;
              case "46":
                key = 'Monthly';
                break;
              case "4":
                key = 'Vegas';
                break;
              default:
                if (!_unknownLevels.contains(level)) {
                  _unknownLevels.add(level);
                  // debugPrint('JackpotPriceBlocV2: Unknown level: $level, tracked: $_unknownLevels');
                  if (_unknownLevels.length > 5) {
                    // debugPrint('JackpotPriceBlocV2: Excessive unknown levels: $_unknownLevels');
                  }
                }
                return;
            }

            // Update current batch
            _currentBatchValues[key] = value;
            add(JackpotPriceUpdateEvent(level, value)); // Trigger _onUpdate for state

            // Save to Hive if all 9 values are present and non-zero
            if (_currentBatchValues.length == 9 && _currentBatchValues.values.every((v) => v != 0.0)) {
              try {
                await hiveService.initHive();
                await hiveService.appendJackpotHistory(Map.from(_currentBatchValues));
                // debugPrint('JackpotPriceBlocV2: Saved to Hive: $_currentBatchValues');
                _currentBatchValues = {}; // Reset for next batch
              } catch (e) {
                debugPrint('JackpotPriceBlocV2: Failed to save to Hive: $e');
              }
            }
          } catch (e) {
            debugPrint('JackpotPriceBlocV2: Error parsing message: $e');
          }
        },
        onError: (error) {
          debugPrint('JackpotPriceBlocV2: WebSocket error: $error');
          add(JackpotPriceConnectionEvent(false, error: error.toString()));
          Future.delayed(Duration(seconds: secondToReconnect), _connectToWebSocket);
        },
        onDone: () {
          debugPrint('JackpotPriceBlocV2: WebSocket closed');
          add(JackpotPriceConnectionEvent(false));
          Future.delayed(Duration(seconds: secondToReconnect), _connectToWebSocket);
        },
      );
    } catch (e) {
      debugPrint('JackpotPriceBlocV2: Failed to connect to WebSocket: $e');
      add(JackpotPriceConnectionEvent(false, error: e.toString()));
      Future.delayed(Duration(seconds: secondToReconnect), _connectToWebSocket);
    }
  }


  Future<void> _onUpdate(JackpotPriceUpdateEvent event, Emitter<JackpotPriceState> emit) async {
    final level = event.level;
    final newValue = event.value;
    String? key;
    switch (level) {
      case "0":
        key = 'Frequent';
        break;
      case "1":
        key = 'Daily';
        break;
      case "2":
        key = 'Dozen';
        break;
      case "3":
        key = 'Weekly';
        break;
      // case "18":
      //   key = 'HighLimit';
      //   break;
      case "45":
        key = 'HighLimit';
        break;
      case "34":
        key = 'DailyGolden';
        break;
      case "35":
        key = 'Triple';
        break;
      case "46":
        key = 'Monthly';
        break;
      case "4":
        key = 'Vegas';
        break;
      case "40":
        key = 'Grand Spin JP';
        break;
      case "41":
        key = 'Major Spin JP';
        break;
      case "43":
        key = 'Vegas Spin JP';
      break;
      default:
        if (!_unknownLevels.contains(level)) {
        _unknownLevels.add(level);
        debugPrint('JackpotPriceBlocV2: Unknown level: $level, tracked: $_unknownLevels');
        if (_unknownLevels.length > 5) {
          debugPrint('JackpotPriceBlocV2: Excessive unknown levels: $_unknownLevels');
        }
      } return;
    }

    // Check if it's the first update for this jackpot type
    final isFirst = _isFirstUpdate[key] ?? false;
    final now = DateTime.now();
    final lastUpdate = _lastUpdateTime[key];

    // Skip if within debounce period (unless it's the first update)
    if (!isFirst && lastUpdate != null && now.difference(lastUpdate) < _debounceDuration) {
      debugPrint('JackpotPriceBlocV2: Skipping update for $key due to debounce');
      return;
    }
    await Future.delayed(isFirst ? _firstUpdateDelay : _debounceDuration);

  final jackpotValues = Map<String, double>.from(state.jackpotValues);
  final previousJackpotValues = Map<String, double>.from(state.previousJackpotValues);

  // Update only if value changed
  if (jackpotValues[key] != newValue) {
    previousJackpotValues[key] = jackpotValues[key] ?? 0.0;
    jackpotValues[key] = newValue;
    _lastUpdateTime[key] = now;
    if (isFirst) {
      _isFirstUpdate[key] = false;
    }
    // Clean unhandled jackpot types
    final validKeys = _isFirstUpdate.keys.toSet();
    jackpotValues.removeWhere((k, v) => !validKeys.contains(k));
    previousJackpotValues.removeWhere((k, v) => !validKeys.contains(k));
    // debugPrint('JackpotPriceBlocV2 onUpdate: $key updated to $newValue, jackpotValues: $jackpotValues');
    emit(state.copyWith(
      jackpotValues: jackpotValues,
      previousJackpotValues: previousJackpotValues,
      isConnected: true,
      error: null,
    ));

  } else {
    debugPrint('JackpotPriceBlocV2: Skipped update for $key: value unchanged ($newValue)');
  }
  }

  Future<void> _onConnection(JackpotPriceConnectionEvent event, Emitter<JackpotPriceState> emit) async {
    debugPrint('JackpotPriceBlocV2: Connection status changed: isConnected=${event.isConnected}, error=${event.error}');
    emit(state.copyWith(
      isConnected: event.isConnected,
      error: event.error,
    ));
  }

  @override
  Future<void> close() {
    debugPrint('JackpotPriceBlocV2: Closing WebSocket');
    channel.sink.close(1000, 'Bloc closed');
    return super.close();
  }
}

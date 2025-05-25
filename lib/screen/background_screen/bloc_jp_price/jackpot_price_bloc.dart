import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_state_state.dart';
import 'package:web_socket_channel/io.dart';
import 'jackpot_price_event.dart';

class JackpotPriceBloc extends Bloc<JackpotPriceEvent, JackpotPriceState> {
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
  // Track last processed timestamp for debouncing
  final Map<String, DateTime> _lastUpdateTime = {};
  static  final Duration _debounceDuration =  Duration(seconds: ConfigCustom.durationGetDataToBloc);
  static  final Duration _firstUpdateDelay = Duration(milliseconds:ConfigCustom.durationGetDataToBlocFirstMS);

  JackpotPriceBloc() : super(JackpotPriceState.initial()) {
    on<JackpotPriceUpdateEvent>(_onUpdate);
    on<JackpotPriceConnectionEvent>(_onConnection);
    // debugPrint('JackpotPriceBloc: Initializing WebSocket connection to ${ConfigCustom.endpointWebSocket}');
    _connectToWebSocket();
  }

  void _connectToWebSocket() {
    try {
      debugPrint('JackpotPriceBloc: Connecting to WebSocket');
      channel = IOWebSocketChannel.connect(ConfigCustom.endpointWebSocket);
      add(JackpotPriceConnectionEvent(true));
      channel.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);
            final level = data['Id'].toString();
            final value = double.tryParse(data['Value'].toString()) ?? 0.0;
            add(JackpotPriceUpdateEvent(level, value));
          } catch (e) {
            // debugPrint('JackpotPriceBloc: Error parsing message: $e, Raw message: $message');
          }
        },
        onError: (error) {
          // debugPrint('JackpotPriceBloc: WebSocket error: $error');
          add(JackpotPriceConnectionEvent(false, error: error.toString()));
          Future.delayed(Duration(seconds: secondToReconnect), _connectToWebSocket);
        },
        onDone: () {
          // debugPrint('JackpotPriceBloc: WebSocket closed');
          add(JackpotPriceConnectionEvent(false));
          Future.delayed(Duration(seconds: secondToReconnect), _connectToWebSocket);
        },
      );
    } catch (e) {
      // debugPrint('JackpotPriceBloc: Failed to connect to WebSocket: $e');
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
          // debugPrint('JackpotPriceBloc: Unknown level: $level, tracked unknown levels: $_unknownLevels');
        }
        return;
    }

    // Check if it's the first update for this jackpot type
    final isFirst = _isFirstUpdate[key] ?? false;
    final now = DateTime.now();
    final lastUpdate = _lastUpdateTime[key];

    // Skip if within debounce period (unless it's the first update)
    if (!isFirst && lastUpdate != null && now.difference(lastUpdate) < _debounceDuration) {
      // debugPrint('JackpotPriceBloc: Skipping update for $key due to debounce');
      return;
    }

    // Apply delay: 100ms for first update, 30s for subsequent ones
    await Future.delayed(isFirst ? _firstUpdateDelay : _debounceDuration);

    // Update state
    final jackpotValues = Map<String, double>.from(state.jackpotValues);
    final previousJackpotValues = Map<String, double>.from(state.previousJackpotValues);

    previousJackpotValues[key] = jackpotValues[key] ?? 0.0;
    jackpotValues[key] = newValue;
    _lastUpdateTime[key] = now;
    if (isFirst) {
      _isFirstUpdate[key] = false;
    }

    // debugPrint('JackpotPriceBloc: Updated $key: previous=${previousJackpotValues[key]}, current=$newValue');
    emit(state.copyWith(
      jackpotValues: jackpotValues,
      previousJackpotValues: previousJackpotValues,
      isConnected: true,
      error: null,
    ));
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

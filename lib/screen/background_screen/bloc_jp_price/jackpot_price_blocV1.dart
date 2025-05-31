// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_hive_service.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_state_state.dart';
// import 'package:playtech_transmitter_app/service/config_custom.dart';
// import 'package:web_socket_channel/io.dart';
// import 'jackpot_price_event.dart';
// import 'package:rxdart/rxdart.dart';



// class JackpotPriceBloc extends Bloc<JackpotPriceEvent, JackpotPriceState> {
//   late IOWebSocketChannel channel;
//   final int baseReconnectSeconds = ConfigCustom.secondToReConnect;
//   final List<String> _unknownLevels = [];
//   final Logger _logger = Logger();
//   final Map<String, bool> _isFirstUpdate = {
//     'Frequent': true,
//     'Daily': true,
//     'Dozen': true,
//     'Weekly': true,
//     'HighLimit': true,
//     'DailyGolden': true,
//     'Triple': true,
//     'Monthly': true,
//     'Vegas': true,
//   };
//   final Map<String, DateTime> _lastUpdateTime = {};
//   static const Duration _debounceDuration = Duration(seconds: 2); // Optimized
//   static const Duration _firstUpdateDelay = Duration(milliseconds: 50); // Optimized
//   int _reconnectAttempts = 0;
//   static const int _maxReconnectAttempts = 10;
//   final JackpotHiveService _hiveService = JackpotHiveService();


//   JackpotPriceBloc() : super(JackpotPriceState.initial()) {
//      on<JackpotPriceUpdateEvent>(
//       _onUpdate,
//     );
//     on<JackpotPriceConnectionEvent>(_onConnection);

//     _loadInitialState();
//     _connectToWebSocket();
//   }

//   Future<void> _loadInitialState() async {
//     final savedState = await _hiveService.getJackpotState();
//     _logger.d('load data Hive: $savedState');
//     emit(savedState);
//   }

//   void _connectToWebSocket() {
//     if (_reconnectAttempts >= _maxReconnectAttempts) {
//       add(JackpotPriceConnectionEvent(false, error: 'Max reconnection attempts reached'));
//       return;
//     }

//     try {
//       channel = IOWebSocketChannel.connect(ConfigCustom.endpointWebSocket);
//       add(JackpotPriceConnectionEvent(true));
//       _reconnectAttempts = 0;
//       channel.stream.listen(
//         (message) {
//           try {
//             final data = jsonDecode(message);
//             final level = data['Id'].toString();
//             final value = double.tryParse(data['Value'].toString()) ?? 0.0;
//             add(JackpotPriceUpdateEvent(level, value));
//           } catch (e) {}
//         },
//         onError: (error) {
//           add(JackpotPriceConnectionEvent(false, error: error.toString()));
//           _scheduleReconnect();
//         },
//         onDone: () {
//           add(JackpotPriceConnectionEvent(false));
//           _scheduleReconnect();
//         },
//       );
//     } catch (e) {
//       add(JackpotPriceConnectionEvent(false, error: e.toString()));
//       _scheduleReconnect();
//     }
//   }

//   void _scheduleReconnect() {
//     _reconnectAttempts++;
//     final delay = Duration(seconds: baseReconnectSeconds * (1 << (_reconnectAttempts - 1)).clamp(1, 60));
//     Future.delayed(delay, _connectToWebSocket);
//   }

//   Future<void> _onUpdate(JackpotPriceUpdateEvent event, Emitter<JackpotPriceState> emit) async {
//     final level = event.level;
//     final newValue = event.value;

//     String? key;
//     switch (level) {
//       case "0":
//         key = 'Frequent';
//         break;
//       case "1":
//         key = 'Daily';
//         break;
//       case "2":
//         key = 'Dozen';
//         break;
//       case "3":
//         key = 'Weekly';
//         break;
//       case "45":
//         key = 'HighLimit';
//         break;
//       case "34":
//         key = 'DailyGolden';
//         break;
//       case "35":
//         key = 'Triple';
//         break;
//       case "46":
//         key = 'Monthly';
//         break;
//       case "4":
//         key = 'Vegas';
//         break;
//       default:
//         if (!_unknownLevels.contains(level)) {
//           _unknownLevels.add(level);
//           if (_unknownLevels.length > 100) {
//             _unknownLevels.removeAt(0); // Cap at 100 entries
//           }
//         }
//         return;
//     }

//     final isFirst = _isFirstUpdate[key] ?? false;
//     final now = DateTime.now();
//     final lastUpdate = _lastUpdateTime[key];

//     if (!isFirst && lastUpdate != null && now.difference(lastUpdate) < _debounceDuration) {
//       return;
//     }

//     await Future.delayed(isFirst ? _firstUpdateDelay : _debounceDuration);

//     final jackpotValues = state.jackpotValues;
//     final previousJackpotValues = state.previousJackpotValues;
//     previousJackpotValues[key] = jackpotValues[key] ?? 0.0;
//     jackpotValues[key] = newValue;
//     _lastUpdateTime[key] = now;
//     if (isFirst) {
//       _isFirstUpdate[key] = false;
//     }

//     emit(state.copyWith(
//       jackpotValues: Map<String, double>.from(jackpotValues),
//       previousJackpotValues: Map<String, double>.from(previousJackpotValues),
//       isConnected: true,
//       error: null,
//     ));
//   }

//   Future<void> _onConnection(JackpotPriceConnectionEvent event, Emitter<JackpotPriceState> emit) async {
//     emit(state.copyWith(
//       isConnected: event.isConnected,
//       error: event.error,
//     ));
//     // Save connection state to Hive
//     await _hiveService.saveJackpotState(newState);
//   }

//   @override
//   Future<void> close() {
//     channel.sink.close(1000, 'Bloc closed');
//     return super.close();
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'jackpot_event2.dart';
import 'jackpot_state2.dart';


class JackpotBloc2 extends Bloc<JackpotEvent2, JackpotState2> {
  late IO.Socket socket;
  Timer? _imagePageTimer;
  final int durationTimer = ConfigCustom.durationTimerVideoHitShow_Jackpot; // 30s to show then dismiss

  JackpotBloc2() : super(const JackpotState2()) {
    socket = IO.io(ConfigCustom.endpoint_jp_hit, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionAttempts': 100, // Retry 100 times
      'reconnectionDelay': 600000, //10 minutes
      'reconnectionDelayMax': 600000, //10 minutes
      'forceNew': true, // For Socket.IO v2 compatibility
    });

    socket.onConnect((_) {
      debugPrint('Connected to Socket.IO server:');
      add(JackpotConnect());
    });

    socket.onDisconnect((_) {
      debugPrint('Disconnected from Socket.IO server');
      add(JackpotDisconnect());
    });

    socket.onReconnect((_) {
      debugPrint('Reconnected to Socket.IO server');
      add(JackpotReconnect());
      socket.emit('fetch_latest');
    });

    socket.onReconnectAttempt((attempt) {
      debugPrint('Reconnection attempt #$attempt');
      // add(JackpotReconnectAttempt(attempt));
    });

    socket.onReconnectError((error) {
      debugPrint('Reconnection error: $error');
      // add(JackpotReconnectError(error.toString()));
    });

    socket.onError((error) {
      debugPrint('Socket.IO error: $error');
      add(JackpotError(error.toString()));
    });

    socket.on('jackpotHit', (data) {
       try {
        Map<String, dynamic> hit;
        if (data is String) {
          hit = jsonDecode(data) as Map<String, dynamic>;
        } else if (data is Map) {
          hit = Map<String, dynamic>.from(data);
        } else {
          debugPrint('Invalid jackpotHit data format: $data');
          return;
        }
        // Normalize amount to String
        if (hit['amount'] is List) {
          hit['amount'] = hit['amount'].isEmpty ? '0' : hit['amount'][0].toString();
        } else {
          hit['amount'] = hit['amount']?.toString() ?? '0';
        }
        debugPrint('Normalized jackpot hit: $hit');
        add(JackpotHitReceived(hit));
        } catch (e) {
          debugPrint('Error parsing jackpotHit data: $e, Raw data: $data');
        }
    });

    socket.on('initialConfig', (data) {
      try {
        final config = data is String ? jsonDecode(data) as Map<String, dynamic> : data as Map<String, dynamic>;
        // debugPrint('initialConfig: $config');
        add(JackpotInitialConfigReceived(config));
      } catch (e) {
        debugPrint('Error parsing initialConfig data: $e, Raw data: $data');
      }
    });

    socket.on('updatedConfig', (data) {
      try {
        final config = data is String ? jsonDecode(data) as Map<String, dynamic> : data as Map<String, dynamic>;
        debugPrint('updatedConfig: $config');
        add(JackpotUpdatedConfigReceived(config));
      } catch (e) {
        debugPrint('Error parsing updatedConfig data: $e, Raw data: $data');
      }
    });

    on<JackpotConnect>((event, emit) {
      emit(state.copyWith(
        isConnected: true,
        error: null,
      ));
    });

    on<JackpotDisconnect>((event, emit) {
      emit(state.copyWith(isConnected: false));
    });

    on<JackpotReconnect>((event, emit) {
      emit(state.copyWith(
        isConnected: true,
        error: null,
      ));
    });

    on<JackpotError>((event, emit) {
      emit(state.copyWith(
        error: event.error,
        isConnected: false,
      ));
    });

    on<JackpotReconnectAttempt>((event, emit) {
      // No state change, just logging
    });

    on<JackpotReconnectError>((event, emit) {
      emit(state.copyWith(error: event.error));
    });

    on<JackpotHitReceived>((event, emit) {
      final updatedHits = List<Map<String, dynamic>>.from(state.hits)..add(event.hit);
      if (state.showImagePage) {
        final updatedQueue = List<Map<String, dynamic>>.from(state.hitQueue ?? [])..add(event.hit);
        emit(state.copyWith(
          hits: updatedHits,
          hitQueue: updatedQueue,
          error: null,
        ));
      } else {
        _startDisplayTimer();
        emit(state.copyWith(
          hits: updatedHits,
          latestHit: event.hit,
          showImagePage: true,
          error: null,
        ));
      }
    });

    on<JackpotInitialConfigReceived>((event, emit) {
      emit(state.copyWith(config: event.config));
    });

    on<JackpotUpdatedConfigReceived>((event, emit) {
      if (event.config.containsKey('status')) {
        final isConnected = event.config['status'] == 'connected';
        emit(state.copyWith(
          isConnected: isConnected,
          error: null,
        ));
      } else if (event.config.containsKey('error')) {
        emit(state.copyWith(error: event.config['error']));
      } else {
        emit(state.copyWith(config: event.config));
      }
    });

    on<JackpotHideImagePage>((event, emit) {
      if (state.hitQueue?.isNotEmpty ?? false) {
        final nextHit = state.hitQueue!.first;
        final updatedQueue = List<Map<String, dynamic>>.from(state.hitQueue!)..removeAt(0);
        emit(state.copyWith(
          latestHit: nextHit,
          showImagePage: true,
          hitQueue: updatedQueue,
        ));
        _startDisplayTimer();
      } else {
        emit(state.copyWith(
          showImagePage: false,
          latestHit: null,
        ));
      }
    });

    socket.connect();
  }

  void _startDisplayTimer() {
    _imagePageTimer?.cancel();
    _imagePageTimer = Timer(Duration(seconds: durationTimer), () {
      add( JackpotHideImagePage());
    });
  }

  @override
  Future<void> close() {
    _imagePageTimer?.cancel();
    socket.disconnect();
    socket.dispose();
    return super.close();
  }
}

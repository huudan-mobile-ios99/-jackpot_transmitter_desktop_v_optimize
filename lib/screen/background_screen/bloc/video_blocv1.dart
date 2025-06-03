import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, ViddeoState> {
  final String videoBg1;
  final String videoBg2;
  Timer? _timer;

  int totalCountToRestart = 3;

  VideoBloc({required this.videoBg1, required this.videoBg2})
      : super(ViddeoState(
          currentVideo: videoBg1,
          id: 1,
          lastSwitchTime: DateTime.now(),
          count: 0,
          isRestart: false,
        )) {
    on<SwitchVideo>(_onSwitchVideo);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: ConfigCustom.durationSwitchVideoSecond), (_) {
      add(SwitchVideo());
    });
  }

  Future<void> _onSwitchVideo(SwitchVideo event, Emitter<ViddeoState> emit) async {
    final now = DateTime.now();
    if (state.currentVideo == videoBg1) {
      // Switching from videoBg1 to videoBg2
      emit(ViddeoState(
        currentVideo: videoBg2,
        id: 2,
        lastSwitchTime: now,
        count: state.count,
        isRestart: state.isRestart,
      ));
    } else {
      // Switching from videoBg2 to videoBg1, increment count
      int newCount = state.count + 1;
      bool newIsRestart = false;
      if (newCount >= totalCountToRestart) {
        newCount = 0;
        newIsRestart = true;
      }
      emit(ViddeoState(
        currentVideo: videoBg1,
        id: 1,
        lastSwitchTime: now,
        count: newCount,
        isRestart: newIsRestart,
      ));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

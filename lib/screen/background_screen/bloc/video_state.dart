part of 'video_bloc.dart';

class ViddeoState extends Equatable {
  final String currentVideo;
  final int id;
  final DateTime lastSwitchTime;
  final int count;
  final bool isRestart;

  const ViddeoState({
    required this.currentVideo,
    required this.id,
    required this.lastSwitchTime,
    this.count = 0,
    this.isRestart = false,
  });

  @override
  List<Object> get props => [currentVideo, id, lastSwitchTime, count, isRestart];
}

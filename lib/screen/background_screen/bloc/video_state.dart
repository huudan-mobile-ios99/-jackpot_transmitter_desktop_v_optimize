  part of 'video_bloc.dart';

  class ViddeoState extends Equatable {
    final String currentVideo;
    final int id;
    final DateTime lastSwitchTime;

    const ViddeoState({
      required this.currentVideo,
      required this.id,
      required this.lastSwitchTime,
    });

    @override
    List<Object> get props => [currentVideo, id, lastSwitchTime];
  }

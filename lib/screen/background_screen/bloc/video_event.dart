part of 'video_blocv1.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

class SwitchVideo extends VideoEvent {}

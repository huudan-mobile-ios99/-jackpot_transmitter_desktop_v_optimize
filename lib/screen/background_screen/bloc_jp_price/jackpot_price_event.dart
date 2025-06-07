import 'package:equatable/equatable.dart';

abstract class JackpotPriceEvent extends Equatable {
  const JackpotPriceEvent();

  @override
  List<Object?> get props => [];
}

class JackpotPriceUpdateEvent extends JackpotPriceEvent {
  final String level;
  final double value;

  const JackpotPriceUpdateEvent(this.level, this.value);

  @override
  List<Object?> get props => [level, value];
}

class JackpotPriceResetEvent extends JackpotPriceEvent {
  final String level;

  const JackpotPriceResetEvent(this.level);

  @override
  List<Object?> get props => [level];
}

class JackpotPriceConnectionEvent extends JackpotPriceEvent {
  final bool isConnected;
  final String? error;

  const JackpotPriceConnectionEvent(this.isConnected, {this.error});

  @override
  List<Object?> get props => [isConnected, error];
}

class JackpotPriceTimerTickEvent extends JackpotPriceEvent {}

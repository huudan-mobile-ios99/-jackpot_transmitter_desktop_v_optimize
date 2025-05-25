import 'package:flutter/widgets.dart';
import 'package:playtech_transmitter_app/odometer/odometer.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number.dart';

typedef OdometerAnimationTransitionBuilder = Widget Function(
  int value,
  int place,
  double animation,
);
class AnimatedOdometer extends ImplicitlyAnimatedWidget {
  const AnimatedOdometer({
  super.key,
  required this.odometerNumber,
  required this.transitionIn,
  required this.transitionOut,
  super.curve,
  required super.duration,
  super.onEnd,
});

  final OdometerNumber odometerNumber;
  final OdometerAnimationTransitionBuilder transitionOut;
  final OdometerAnimationTransitionBuilder transitionIn;

  @override
  _AnimatedOdometer3State createState() => _AnimatedOdometer3State();
}

class _AnimatedOdometer3State extends AnimatedWidgetBaseState<AnimatedOdometer> {
  OdometerTween? _odometerTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _odometerTween = visitor(
      _odometerTween,
      widget.odometerNumber,
      (dynamic value) => OdometerTween(begin: value as OdometerNumber),
    ) as OdometerTween?;
  }

  @override
  Widget build(BuildContext context) {
    return Odometer3(
      transitionOut: widget.transitionOut,
      transitionIn: widget.transitionIn,
      odometerNumber: _odometerTween!.evaluate(animation),
    );
  }
}

class OdometerTransition extends AnimatedWidget {
  const OdometerTransition({
    super.key,
    required this.transitionIn,
    required this.transitionOut,
    required Animation<OdometerNumber> odometerAnimation,
  }) : super(listenable: odometerAnimation);

  final OdometerAnimationTransitionBuilder transitionOut;
  final OdometerAnimationTransitionBuilder transitionIn;
  Animation<OdometerNumber> get odometerAnimation => listenable as Animation<OdometerNumber>;

  @override
  Widget build(BuildContext context) {
    return Odometer3(
      transitionOut: transitionOut,
      transitionIn: transitionIn,
      odometerNumber: odometerAnimation.value,
    );
  }
}

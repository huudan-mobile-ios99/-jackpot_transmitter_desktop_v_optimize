import 'package:flutter/widgets.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number.dart';
import 'package:playtech_transmitter_app/odometer/odometer_transition.dart';

class Odometer3 extends StatelessWidget {
  final OdometerAnimationTransitionBuilder transitionOut;
  final OdometerAnimationTransitionBuilder transitionIn;
  final OdometerNumber odometerNumber;

  const Odometer3({
    super.key,
    required this.transitionIn,
    required this.transitionOut,
    required this.odometerNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = odometerNumber.digits.keys.length; i > 0; i--)
          Stack(
            children: [
              transitionOut(
                OdometerNumber.digit(odometerNumber.digits[i]!),
                i,
                OdometerNumber.progress(odometerNumber.digits[i]!),
              ),
              transitionIn(
                OdometerNumber.digit(odometerNumber.digits[i]! + 1),
                i,
                OdometerNumber.progress(odometerNumber.digits[i]!),
              ),
            ],
          ),
      ],
    );
  }
}

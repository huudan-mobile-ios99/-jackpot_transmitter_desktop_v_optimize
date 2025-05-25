
// import 'package:flutter/widgets.dart';
// import 'package:playtech_transmitter_app/odometer/odometer_number.dart';
// import 'package:playtech_transmitter_app/odometer/odometer_transition.dart';

// class AnimatedSlideOdometerNumber extends StatelessWidget {
//   final OdometerNumber odometerNumber;
//   final Duration duration;
//   final double letterWidth;
//   final Widget? groupSeparator;
//   final Widget? decimalSeparator;
//   final TextStyle? numberTextStyle;
//   final double verticalOffset;
//   final Curve curve;
//   final int decimalPlaces;
//   final int integerDigits; // New parameter for cached integer digits

//   const AnimatedSlideOdometerNumber({
//     super.key,
//     required this.odometerNumber,
//     required this.duration,
//     this.numberTextStyle,
//     this.curve = Curves.linear,
//     required this.letterWidth,
//     this.verticalOffset = 20,
//     this.groupSeparator,
//     this.decimalSeparator,
//     this.decimalPlaces = 2, // Default to 2 decimal places
//     required this.integerDigits, // Required cached integer digits
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOdometer(
//       curve: curve,
//       odometerNumber: odometerNumber,
//       transitionIn: (value, place, animation) => _buildSlideOdometerDigit(
//         value,
//         place,
//         animation,
//         verticalOffset * animation - verticalOffset,
//         groupSeparator,
//         decimalSeparator,
//         numberTextStyle,
//         letterWidth,
//         decimalPlaces,
//         integerDigits, // Pass cached integer digits
//       ),
//       transitionOut: (value, place, animation) => _buildSlideOdometerDigit(
//         value,
//         place,
//         1 - animation,
//         verticalOffset * animation,
//         groupSeparator,
//         decimalSeparator,
//         numberTextStyle,
//         letterWidth,
//         decimalPlaces,
//         integerDigits, // Pass cached integer digits
//       ),
//       duration: duration,
//     );
//   }
// }

// class SlideOdometerTransition extends StatelessWidget {
//   final Animation<OdometerNumber> odometerAnimation;
//   final double letterWidth;
//   final Widget? groupSeparator;
//   final Widget? decimalSeparator;
//   final TextStyle? numberTextStyle;
//   final double verticalOffset;
//   final int decimalPlaces;
//   final int integerDigits; // New parameter for cached integer digits

//   const SlideOdometerTransition({
//     super.key,
//     required this.odometerAnimation,
//     this.numberTextStyle,
//     required this.letterWidth,
//     this.verticalOffset = 20,
//     this.groupSeparator,
//     this.decimalSeparator,
//     this.decimalPlaces = 2, // Default to 2 decimal places
//     required this.integerDigits, // Required cached integer digits
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: Center(
//         child: OdometerTransition(
//           odometerAnimation: odometerAnimation,
//           transitionIn: (value, place, animation) => _buildSlideOdometerDigit(
//             value,
//             place,
//             animation < 0.02 ? 0.85 + (animation / 0.02) * (1.0 - 0.85) : 1.0,
//             verticalOffset * (1.0 - animation),
//             groupSeparator,
//             decimalSeparator,
//             numberTextStyle,
//             letterWidth,
//             decimalPlaces,
//             integerDigits, // Pass cached integer digits
//           ),
//           transitionOut: (value, place, animation) => _buildSlideOdometerDigit(
//             value,
//             place,
//             animation <= 0.99 ? 1.0 : 1 - ((animation - 0.99) / 0.1).clamp(0.0, 1.0),
//             verticalOffset * (animation * -1),
//             groupSeparator,
//             decimalSeparator,
//             numberTextStyle,
//             letterWidth,
//             decimalPlaces,
//             integerDigits, // Pass cached integer digits
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _buildSlideOdometerDigit(
//   int value,
//   int place,
//   double opacity,
//   double offsetY,
//   Widget? groupSeparator,
//   Widget? decimalSeparator,
//   TextStyle? numberTextStyle,
//   double letterWidth,
//   int decimalPlaces,
//   int integerDigits, // Use cached integer digits
// ) {
//   Widget digitWidget = _valueText(value, opacity, offsetY, numberTextStyle, letterWidth);

//   // Place decimal separator after integer digits
//   if (decimalSeparator != null && place == integerDigits + decimalPlaces) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         decimalSeparator,
//         digitWidget,
//       ],
//     );
//   }

//   // Place group separator for integer part
//   final d = place - decimalPlaces - integerDigits;
//   if (groupSeparator != null && place > decimalPlaces + integerDigits && d > 0 && d % 4 == 0) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         digitWidget,
//         groupSeparator,
//       ],
//     );
//   }

//   return digitWidget;
// }

// Widget _valueText(
//   int value,
//   double opacity,
//   double offsetY,
//   TextStyle? numberTextStyle,
//   double letterWidth,
// ) =>
//     Transform.translate(
//       offset: Offset(0, offsetY),
//       child: Opacity(
//         opacity: opacity.clamp(0.5, 1.0),
//         child: SizedBox(
//           width: letterWidth,
//           child: Text(
//             value.toString(),
//             textAlign: TextAlign.center,
//             style: numberTextStyle,
//           ),
//         ),
//       ),
// );

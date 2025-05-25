// import 'package:flutter/material.dart';
// import 'package:playtech_transmitter_app/odometer/odometer_number.dart';
// import 'package:playtech_transmitter_app/odometer/slide_odometer.dart';
// import 'package:playtech_transmitter_app/service/config_custom.dart';
// import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
// import 'dart:async';

// import 'package:playtech_transmitter_app/service/widget/text_style.dart';



// class GameOdometerChildStyleOptimized extends StatefulWidget {
//   final double startValue;
//   final double endValue;
//   final int totalDuration; // Total duration in seconds (default: 30)
//   final String nameJP;

//   const GameOdometerChildStyleOptimized({
//     super.key,
//     required this.startValue,
//     required this.endValue,
//     this.totalDuration = 30,
//     required this.nameJP,
//   });

//   @override
//   _GameOdometerChildStyleOptimizedState createState() => _GameOdometerChildStyleOptimizedState();
// }

// class _GameOdometerChildStyleOptimizedState extends State<GameOdometerChildStyleOptimized> with TickerProviderStateMixin {
//   late AnimationController animationController;
//   late Animation<OdometerNumber> odometerAnimation;
//   late ValueNotifier<double> currentValueNotifier;
//   final settingsService = SettingsService();
//   late double currentValue;

//   final String fontFamily = 'sf-pro-display';
//   late int durationPerStep; // Calculated dynamically



//   Timer? _animationTimer;


//   @override
//   void initState() {
//     super.initState();
//     // debugPrint('GameOdometerChildStyleOptimized: ${widget.startValue}->${widget.endValue}');
//     currentValueNotifier = ValueNotifier(widget.startValue == 0.0 && widget.endValue != 0.0 ? widget.endValue : widget.startValue);
//     durationPerStep = calculationDurationPerStep(
//       totalDuration: widget.totalDuration,
//       startValue: widget.startValue,
//       endValue: widget.endValue,
//     );
//     _initializeAnimationController();
//     _updateAnimation(currentValueNotifier.value, currentValueNotifier.value);
//     if (widget.startValue != 0.0 || widget.startValue != 0) {
//       _startAutoAnimation();
//     }
//     else {
//       // debugPrint('GameOdometerChildStyleOptimized: Skipping animation for ${widget.nameJP}, displaying endValue=${widget.endValue}');
//     }
//   }



//   void _initializeAnimationController() {
//     animationController = AnimationController(
//       duration: Duration(milliseconds: durationPerStep),
//       vsync: this,
//     );
//   }

//   void _updateAnimation(double start, double end) {
//     odometerAnimation = OdometerTween(
//       begin: OdometerNumber((start * 100).round()),
//       end: OdometerNumber((end * 100).round()),
//     ).animate(
//       CurvedAnimation(
//         parent: animationController,
//         curve: Curves.linear,
//       ),
//     );
//   }

//   void _startAutoAnimation() {
//     const increment = 0.01;
//     final interval = Duration(milliseconds: durationPerStep);
//     _animationTimer?.cancel();
//     _animationTimer = Timer.periodic(interval, (timer) {
//       if (currentValueNotifier.value >= widget.endValue || !mounted) {
//         // debugPrint('GameOdometerChildStyleOptimized: Animation stopped for ${widget.nameJP}, currentValue=${currentValueNotifier.value}');
//         timer.cancel();
//         return;
//       }
//       final nextValue = (currentValueNotifier.value + increment).clamp(currentValueNotifier.value, widget.endValue);
//       // debugPrint('GameOdometerChildStyleOptimized: Animating ${widget.nameJP} from ${currentValueNotifier.value} to $nextValue');
//       _updateAnimation(currentValueNotifier.value, nextValue);
//       currentValueNotifier.value = nextValue;
//       animationController.forward(from: 0.0);
//     });
//   }

//   @override
//   void didUpdateWidget(covariant GameOdometerChildStyleOptimized oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.startValue != oldWidget.startValue ||
//         widget.endValue != oldWidget.endValue ||
//         widget.totalDuration != oldWidget.totalDuration) {
//       // debugPrint('GameOdometerChildStyleOptimized: Widget updated for ${widget.nameJP}, new startValue=${widget.startValue}, endValue=${widget.endValue}');
//       _animationTimer?.cancel();
//       // If startValue is 0.0, set to endValue without animation
//       currentValueNotifier.value = widget.startValue == 0.0 ? widget.endValue : widget.startValue;
//       durationPerStep = calculationDurationPerStep(
//         totalDuration: widget.totalDuration,
//         startValue: widget.startValue,
//         endValue: widget.endValue,
//       );
//       animationController
//         ..stop()
//         ..duration = Duration(milliseconds: durationPerStep);
//       _updateAnimation(currentValueNotifier.value, currentValueNotifier.value);
//       // Only start animation if startValue is not 0.0
//       if (widget.startValue != 0.0) {
//         // debugPrint('GameOdometerChildStyleOptimized: Restarting animation for ${widget.nameJP}');
//         _startAutoAnimation();
//       } else {
//         // debugPrint('GameOdometerChildStyleOptimized: Skipping animation for ${widget.nameJP}, displaying endValue=${widget.endValue}');
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _animationTimer?.cancel();
//     animationController.dispose();
//     currentValueNotifier.dispose();
//     super.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
//     final double letterWidth = settingsService.settings!.textOdoLetterWidth;
//     final double verticalOffset = settingsService.settings!.textOdoLetterVerticalOffset;

//     return ClipRect(
//       child: RepaintBoundary(
//         child: Container(
//           // color:Colors.white24,
//           alignment: Alignment.center,
//           width: ConfigCustom.fixWidth/2,
//           height: settingsService.settings!.odoHeight,
//           child: Stack(
//             children: [
//               Positioned(
//                 top:-settingsService.settings!.odoPositionTop,
//                 left:0,right:0,
//                 child: ValueListenableBuilder<double>(
//                   valueListenable: currentValueNotifier,
//                   builder: (context, value, child) {
//                     return SlideOdometerTransition(
//                       verticalOffset: verticalOffset,
//                       groupSeparator: Text(',', style: textStyleOdo),
//                       decimalSeparator: Text('.', style: textStyleOdo),
//                       letterWidth: letterWidth,
//                       odometerAnimation: odometerAnimation,
//                       numberTextStyle: textStyleOdo,
//                       decimalPlaces: 2,
//                       integerDigits: 0,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// int calculationDurationPerStep({
//     required int totalDuration,
//     required double startValue,
//     required double endValue,
//   }) {
//     if (endValue <= startValue) {
//       return 1000; // Default duration if no animation is needed
//     }
//     final totalSteps = ((endValue - startValue) / 0.01).ceil();
//     final durationMs = (totalDuration * 1000) / totalSteps;
//     // debugPrint('calculationDurationPerStep: $durationMs Ms');
//     return durationMs.round().clamp(1, 1000);
//   }


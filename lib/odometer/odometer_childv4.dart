import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number.dart';
import 'package:playtech_transmitter_app/odometer/slide_odometer.dart';
import 'dart:async';
import 'package:playtech_transmitter_app/service/widget/text_style.dart';



class GameOdometerChildStyleOptimizedV4 extends StatefulWidget {
  final double startValue;
  final double endValue;
  final int totalDuration; // Total duration in seconds (default: 30)
  final String nameJP;
  final double hiveValue;

  const GameOdometerChildStyleOptimizedV4({
    Key? key,
    required this.startValue,
    required this.hiveValue,
    required this.endValue,
    this.totalDuration = 30,
    required this.nameJP,
  }) : super(key: key);

  @override
  _GameOdometerChildStyleOptimizedV4State createState() => _GameOdometerChildStyleOptimizedV4State();
}

class _GameOdometerChildStyleOptimizedV4State extends State<GameOdometerChildStyleOptimizedV4>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<OdometerNumber> odometerAnimation;
  late double currentValue;
  final double fontSize = 82.5;
  final String fontFamily = 'sf-pro-display';
  late int durationPerStep; // Calculated dynamically
  late int integerDigits=0; // Cache integer digits



  Timer? _animationTimer;


  @override
  void initState() {
    print('INISTATE: hive ${widget.hiveValue}: startValue: ${widget.startValue}');
    super.initState();
    currentValue = widget.startValue;
    durationPerStep = calculationDurationPerStep(
      totalDuration: widget.totalDuration,
      startValue: widget.startValue,
      endValue: widget.endValue,
    );

    _initializeAnimationController();
    _updateAnimation(widget.startValue, widget.endValue);
  }



  void _initializeAnimationController() {
    animationController = AnimationController(
      duration: Duration(milliseconds: durationPerStep),
      vsync: this,
    );
  }

  void _updateAnimation(double start, double end) {
    odometerAnimation = OdometerTween(
      begin: OdometerNumber((start * 100).round()),
      end: OdometerNumber((end * 100).round()),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );
  }

  void _startAutoAnimation() {
    const increment = 0.01;
    final interval = Duration(milliseconds: durationPerStep);
    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(interval, (timer) {
      if (currentValue >= widget.endValue || !mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        final nextValue = (currentValue + increment).clamp(currentValue, widget.endValue);
        _updateAnimation(currentValue, nextValue);
        currentValue = nextValue;
        animationController.forward(from: 0.0);
      });
    });
  }

  @override
  void didUpdateWidget(covariant GameOdometerChildStyleOptimizedV4 oldWidget) {
    print('didUpdateWidget starValue: ${widget.startValue}-> endValue:${widget.endValue} || hiveValue: ${widget.hiveValue}');
    super.didUpdateWidget(oldWidget);
    if (widget.startValue != oldWidget.startValue ||
        widget.endValue != oldWidget.endValue ||
        widget.totalDuration != oldWidget.totalDuration) {
      setState(() {
        _animationTimer?.cancel();
        currentValue = widget.startValue;
        durationPerStep = calculationDurationPerStep(
          totalDuration: widget.totalDuration,
          startValue: widget.startValue,
          endValue: widget.endValue,
        );
        animationController
          ..stop()
          ..duration = Duration(milliseconds: durationPerStep);
        _updateAnimation(currentValue, currentValue);
        animationController.forward(from: 0.0);
        if (widget.startValue != 0.0  || widget.startValue!=0) {
          _startAutoAnimation();
        }else{
          print('SKIP THIS RUN');
          // _startAutoAnimation();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final double letterWidth = fontSize * 0.615;
    final double verticalOffset = fontSize * 1.1;
    final double width = MediaQuery.of(context).size.width;

    return ClipRect(
      child: Container(
        alignment: Alignment.center,
        width: width/2,
        height: 107.5,
        // decoration: BoxDecoration(
        //   // color:Colors.white12,
        //   borderRadius: BorderRadius.circular(8.0)
        // ),
        child: Stack(
          children: [
            Positioned(
              top:-10,
              left:0,right:0,
              child: SlideOdometerTransition(
                verticalOffset: verticalOffset,
                groupSeparator:  Text(',',style:textStyleOdo),
                decimalSeparator:  Text('.',style:textStyleOdo),
                letterWidth: letterWidth,
                odometerAnimation: odometerAnimation,
                numberTextStyle: textStyleOdo,
                decimalPlaces: 2,
                integerDigits:integerDigits
              ),
            ),
          ],
        ),
      ),
    );
  }
}




int calculationDurationPerStep({
  required int totalDuration,
  required double startValue,
  required double endValue,
}) {
  if (endValue <= startValue) {
    return 1000; // Default duration if no animation is needed
  }
  final totalSteps = ((endValue - startValue) / 0.01).ceil();
  final durationMs = (totalDuration * 1000) / totalSteps;
  return durationMs.round().clamp(15, 15000);
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/odometer/odometer_child.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number.dart';
import 'package:playtech_transmitter_app/odometer/slide_odometer.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/widget/text_style.dart';




class GameOdometerChildStyleOnlyForHighLimit extends StatefulWidget {
  final double startValue;
  final double endValue;
  final int totalDuration; // Total duration in seconds (default: 30)
  final String nameJP;
  final double hiveValue;

  const GameOdometerChildStyleOnlyForHighLimit({
    Key? key,
    required this.startValue,
    required this.endValue,
    required this.hiveValue,
    this.totalDuration = 30,
    required this.nameJP,
  }) : super(key: key);

  @override
  _GameOdometerChildStyleOnlyForHighLimitState createState() => _GameOdometerChildStyleOnlyForHighLimitState();
}

class _GameOdometerChildStyleOnlyForHighLimitState extends State<GameOdometerChildStyleOnlyForHighLimit>
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
    super.initState();
    currentValue = widget.startValue;
    durationPerStep = calculationDurationPerStep(
      totalDuration: widget.totalDuration,
      startValue: widget.startValue,
      endValue: widget.endValue,
    );
    if (widget.startValue == 0.0) {
      currentValue = widget.endValue;
    } else {
      currentValue = widget.startValue;
    }
    _initializeAnimationController();
    _updateAnimation(currentValue, currentValue);
    if (widget.startValue != 0.0) {
      _startAutoAnimation();
    }
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
  void didUpdateWidget(covariant GameOdometerChildStyleOnlyForHighLimit oldWidget) {
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
        _startAutoAnimation();
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

    const double letterWidth = ConfigCustom.text_odo_letter_width;
    const double verticalOffset = ConfigCustom.text_odo_letter_vertical_offset;

    return ClipRect(
      child: RepaintBoundary(
        child: Container(
         alignment: Alignment.center,
            width: ConfigCustom.fixWidth / 2,
            height: ConfigCustom.odo_height,
          child: Stack(
            children: [
              Positioned(
                top: -ConfigCustom.odo_position_top,
                left: 0,
                right: 0,
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
      ),
    );
  }
}

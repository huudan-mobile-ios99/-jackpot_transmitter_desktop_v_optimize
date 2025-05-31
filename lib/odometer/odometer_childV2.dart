import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number.dart';
import 'package:playtech_transmitter_app/odometer/slide_odometer.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
import 'dart:async';
import 'package:playtech_transmitter_app/service/widget/text_style.dart';



class GameOdometerChildStyleOptimizedV2 extends StatefulWidget {
  final double startValue;
  final double endValue;
  final double hiveValue; // New field for Hive initial value
  final int? totalDuration; // Total duration in seconds (default: 30)
  final String nameJP;

  const GameOdometerChildStyleOptimizedV2({
    super.key,
    required this.startValue,
    required this.endValue,
    required this.hiveValue,
    this.totalDuration = 30,
    required this.nameJP,
  });

  @override
  _GameOdometerChildStyleOptimizedV2State createState() => _GameOdometerChildStyleOptimizedV2State();
}

class _GameOdometerChildStyleOptimizedV2State extends State<GameOdometerChildStyleOptimizedV2> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<OdometerNumber> odometerAnimation;
  late ValueNotifier<double> currentValueNotifier;
  final SettingsService settingsService = SettingsService();
  late int durationPerStep;
  Timer? _animationTimer;
  final String fontFamily = 'sf-pro-display';
  bool _isFirstRun = true; // Flag to use hiveValue on first run

  @override
  void initState() {
    super.initState();
    print('INIT GameOdometerChildStyleOptimizedV2');
    // Use hiveValue for initial startValue if non-zero, else fall back to startValue
    final initialValue = widget.hiveValue != 0.0 ? widget.hiveValue : widget.startValue;
    // final initialValue = widget.hiveValue != 0.0 ? widget.hiveValue : widget.startValue;
    // print('initialValue: $initialValue $_isFirstRun');
    // final initialValue = widget.hiveValue != 0.0 ? widget.hiveValue : widget.startValue;
    currentValueNotifier = ValueNotifier<double>(initialValue);
    durationPerStep = calculationDurationPerStep(
      totalDuration: widget.totalDuration!,
      startValue: initialValue,
      endValue: widget.endValue,
    );
    debugPrint( 'ODO hive: ${widget.hiveValue} start: ${widget.startValue} end: ${widget.startValue}');
    _initializeAnimationController();
    _updateAnimation(currentValueNotifier.value, currentValueNotifier.value);
    _startAutoAnimation(initialValue);
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

  void _startAutoAnimation(double startValue) {
    const increment = 0.01;
    final interval = Duration(milliseconds: durationPerStep.clamp(35, 7500));
    _animationTimer?.cancel();
    currentValueNotifier.value = startValue;
    _updateAnimation(startValue, startValue);
    _animationTimer = Timer.periodic(interval, (timer) {
      if (currentValueNotifier.value >= widget.endValue || !mounted) {
        timer.cancel();
        return;
      }
      final nextValue = (currentValueNotifier.value + increment).clamp(currentValueNotifier.value, widget.endValue);
      _updateAnimation(currentValueNotifier.value, nextValue);
      currentValueNotifier.value = nextValue;
      animationController.forward(from: 0.0);
    });
  }

  @override
  void didUpdateWidget(covariant GameOdometerChildStyleOptimizedV2 oldWidget) {
    print('didUpdateWidget GameOdometerChildStyleOptimizedV2');
    super.didUpdateWidget(oldWidget);
    if (widget.startValue != oldWidget.startValue || widget.endValue != oldWidget.endValue || widget.totalDuration != oldWidget.totalDuration) {
      _animationTimer?.cancel();
      // Use startValue from bloc for updates, not hiveValue
      currentValueNotifier.value = widget.startValue == 0.0 ? widget.endValue : widget.startValue;
      durationPerStep = calculationDurationPerStep(
        totalDuration: widget.totalDuration!,
        startValue: widget.startValue,
        endValue: widget.endValue,
      );
      animationController
        ..stop()
        ..duration = Duration(milliseconds: durationPerStep);
      _updateAnimation(currentValueNotifier.value, currentValueNotifier.value);
      // _startAutoAnimation(widget.startValue);
      if (widget.startValue != 0.0) {
        _startAutoAnimation(widget.startValue);
      }

      _isFirstRun = false; // Disable hiveValue after first run
     print('didUpdateWidget: ${widget.hiveValue} start ${widget.startValue} end ${widget.endValue} $_isFirstRun');
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    animationController.dispose();
    currentValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double letterWidth = settingsService.settings!.textOdoLetterWidth;
    final double verticalOffset = settingsService.settings!.textOdoLetterVerticalOffset;

    return ClipRect(
      child: RepaintBoundary(
        child: Container(
          alignment: Alignment.center,
          width: ConfigCustom.fixWidth / 2,
          height: settingsService.settings!.odoHeight,
          child: Stack(
            children: [
              Positioned(
                top: -settingsService.settings!.odoPositionTop,
                left: 0,
                right: 0,
                child: ValueListenableBuilder<double>(
                  valueListenable: currentValueNotifier,
                  builder: (context, value, child) {
                    return RepaintBoundary(
                      child: SlideOdometerTransition(
                        verticalOffset: verticalOffset,
                        groupSeparator: Text(',', style: textStyleOdo),
                        decimalSeparator: Text('.', style: textStyleOdo),
                        letterWidth: letterWidth,
                        odometerAnimation: odometerAnimation,
                        numberTextStyle: textStyleOdo,
                        decimalPlaces: 2,
                        integerDigits: 0,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
  return durationMs.round().clamp(35, 7500);
}

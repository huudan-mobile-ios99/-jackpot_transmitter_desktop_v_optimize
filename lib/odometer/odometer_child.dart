import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number.dart';
import 'package:playtech_transmitter_app/odometer/slide_odometer.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
import 'dart:async';
import 'package:playtech_transmitter_app/service/widget/text_style.dart';



class GameOdometerChildStyleOptimized extends StatefulWidget {
  final double startValue;
  final double endValue;
  final double hiveValue; // New field for Hive initial value
  final int? totalDuration; // Total duration in seconds (default: 30)
  final String nameJP;

  const GameOdometerChildStyleOptimized({
    super.key,
    required this.startValue,
    required this.endValue,
    required this.hiveValue,
    this.totalDuration = 30,
    required this.nameJP,
  });

  @override
  _GameOdometerChildStyleOptimizedState createState() => _GameOdometerChildStyleOptimizedState();
}

class _GameOdometerChildStyleOptimizedState extends State<GameOdometerChildStyleOptimized> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<OdometerNumber> odometerAnimation;
  late ValueNotifier<double> currentValueNotifier;
  final SettingsService settingsService = SettingsService();
  late int durationPerStep;
  late int durationPerStepHive;
  Timer? _animationTimer;
  final String fontFamily = 'sf-pro-display';
  bool _isFirstRun = true; // Flag to use hiveValue on first run
  final Logger _logger = Logger();
  static const Duration _debounceDuration = Duration(seconds: 0);
  DateTime? _lastUpdateTime;
  bool _isDisposing = false;

  @override
  void initState() {
    super.initState();
    final initialValue = widget.startValue == 0.0 ? widget.hiveValue : widget.startValue;
    currentValueNotifier = ValueNotifier<double>(initialValue);
    durationPerStep = calculationDurationPerStep(
      totalDuration: widget.totalDuration!,
      startValue: initialValue,
      endValue: widget.endValue,
    );
    durationPerStepHive = calculationDurationPerStep(
      totalDuration: widget.totalDuration!,
      startValue: widget.hiveValue,
      endValue: widget.endValue,
    );
    _initializeAnimationController();
    _updateAnimation(currentValueNotifier.value, currentValueNotifier.value);
    // _isFirstRun? debugPrint('#FirstRun') : debugPrint('#NextRun');
  }







  @override
  void didUpdateWidget(covariant GameOdometerChildStyleOptimized oldWidget) {
    super.didUpdateWidget(oldWidget);
    final now = DateTime.now();
    if (_lastUpdateTime != null && now.difference(_lastUpdateTime!) < _debounceDuration) {
      // _logger.d('Odometer: ${widget.nameJP}, Skipping update due to debounce, lastUpdate: $_lastUpdateTime');
      return;
    }
    if (widget.startValue != oldWidget.startValue || widget.endValue != oldWidget.endValue || widget.totalDuration != oldWidget.totalDuration) {
      _animationTimer?.cancel();
      currentValueNotifier.value = widget.startValue == 0.0 ? widget.endValue : widget.startValue;
      durationPerStep = calculationDurationPerStep(
        totalDuration: widget.totalDuration!,
        startValue:_isFirstRun==true ? widget.hiveValue :  widget.startValue,
        endValue: widget.endValue,
      );

      animationController
        ..stop()
        ..duration = Duration(milliseconds: durationPerStep);
       _updateAnimation(currentValueNotifier.value, currentValueNotifier.value);

      if (_isFirstRun == true && widget.hiveValue > 0 && widget.hiveValue < widget.endValue) {
        _startAutoAnimation(widget.hiveValue);
      }
      if (widget.startValue != 0.0  || widget.startValue !=0 && !_isDisposing) {
        _startAutoAnimation(widget.startValue);
      }


      _isFirstRun = false; // Disable hiveValue after first run
      _lastUpdateTime = now;
    }
  }




  void _startAutoAnimation(double startValue) {
    const increment = 0.01;
    final interval = Duration(milliseconds:  durationPerStep.clamp(20, 5000));
    _animationTimer?.cancel();
    currentValueNotifier.value = startValue;
    _updateAnimation(startValue, startValue);
    _animationTimer = Timer.periodic(interval, (timer) {
      if (!mounted || _isDisposing || currentValueNotifier.value >= widget.endValue) {
        timer.cancel();
        // _logger.d('Odometer: ${widget.nameJP}, Animation completed or unmounted, currentValue: ${currentValueNotifier.value}');
        return;
      }
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
  void dispose() {
    _animationTimer?.cancel();
    animationController.dispose();
    currentValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double letterWidth = ConfigCustom.text_odo_letter_width;
    final double verticalOffset = ConfigCustom.text_odo_letter_vertical_offset;

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
  return durationMs.round().clamp(20, 5000);
}

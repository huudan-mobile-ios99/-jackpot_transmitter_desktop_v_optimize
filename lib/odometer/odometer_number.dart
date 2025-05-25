
import 'dart:math';
import 'package:flutter/widgets.dart';

class OdometerNumber {
  final int number;
  final Map<int, double> digits;

  OdometerNumber(this.number) : digits = generateDigits(number);

  OdometerNumber.fromDigits(this.digits) : number = digits[1]!.toInt();

  static Map<int, double> generateDigits(int number) {
    final digits = <int, double>{};
    var v = number.abs();
    var place = 1;

    // Ensure 2 decimal places (cents)
    for (int i = 0; i < 2; i++) {
      digits[place] = (v % 10).toDouble();
      v ~/= 10;
      place++;
    }

    // Handle integer part
    if (v == 0) {
      digits[place] = 0.0; // Ensure at least one integer digit
    } else {
      while (v > 0) {
        digits[place] = (v % 10).toDouble();
        v ~/= 10;
        place++;
      }
    }
    return digits;
  }

  static int digit(double value) => (value % 10).truncate();

  static double progress(double value) {
    final progress = value - value.truncate();
    return progress < 0 ? progress + 1 : progress;
  }

  static OdometerNumber lerp(OdometerNumber start, OdometerNumber end, double t) {
    final keyLength = max(start.digits.length, end.digits.length);
    final digits = <int, double>{};

    for (int i = 1; i <= keyLength; i++) {
      final startDigit = start.digits[i] ?? 0.0;
      final endDigit = end.digits[i] ?? 0.0;
      double inc = endDigit - startDigit;
      if (inc < 0) inc += 10;

      final currentDigit = startDigit + inc * t;
      digits[i] = currentDigit >= 10 ? currentDigit - 10 : currentDigit;
    }

    return OdometerNumber.fromDigits(digits);
  }

  @override
  String toString() {
    return 'OdometerNumber $number';
  }
}

class OdometerTween extends Tween<OdometerNumber> {
  OdometerTween({super.begin, super.end});

  @override
  OdometerNumber transform(double t) {
    if (t == 0.0) return begin!;
    if (t == 1.0) {
      if (begin!.digits.keys.length > end!.digits.keys.length) {
        end!.digits.addEntries(
          begin!.digits.keys.toSet().difference(end!.digits.keys.toSet()).map(
                (e) => MapEntry(e, 0),
              ),
        );
      }
      return end!;
    }
    return lerp(t);
  }

  @override
  OdometerNumber lerp(double t) => OdometerNumber.lerp(begin!, end!, t);
}

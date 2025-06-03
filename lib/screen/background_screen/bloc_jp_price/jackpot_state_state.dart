import 'package:playtech_transmitter_app/service/config_custom.dart';

final class JackpotPriceState {
  final bool isConnected;
  final String? error;
  final Map<String, double> jackpotValues;
  final Map<String, double> previousJackpotValues;

  JackpotPriceState({
    required this.isConnected,
    this.error,
    required this.jackpotValues,
    required this.previousJackpotValues,
  });

  factory JackpotPriceState.initial() => JackpotPriceState(
        isConnected: false,
        error: null,
        jackpotValues: {
          for (var name in ConfigCustom.validJackpotNames) name: 0.0,
        },
        previousJackpotValues: {
          for (var name in ConfigCustom.validJackpotNames) name: 0.0,
        },
      );

  JackpotPriceState copyWith({
    bool? isConnected,
    String? error,
    Map<String, double>? jackpotValues,
    Map<String, double>? previousJackpotValues,
  }) {
    return JackpotPriceState(
      isConnected: isConnected ?? this.isConnected,
      error: error ?? this.error,
      jackpotValues: jackpotValues ?? this.jackpotValues,
      previousJackpotValues: previousJackpotValues ?? this.previousJackpotValues,
    );
  }
}

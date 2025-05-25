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
          'Frequent': 0.0,
          'Daily': 0.0,
          'DailyGolden': 0.0,
          'Dozen': 0.0,
          'Weekly': 0.0,
          'HighLimit': 0.0,
          'Triple': 0.0,
          'Monthly': 0.0,
          'Vegas': 0.0,
        },
        previousJackpotValues: {
          'Frequent': 0.0,
          'Daily': 0.0,
          'DailyGolden': 0.0,
          'Dozen': 0.0,
          'Weekly': 0.0,
          'HighLimit': 0.0,
          'Triple': 0.0,
          'Monthly': 0.0,
          'Vegas': 0.0,
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

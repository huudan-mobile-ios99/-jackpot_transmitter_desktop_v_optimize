// Format the number with commas (e.g., 14000.00 -> 14,000.00)
  String formatNumber(double value) {
    String formatted = value.toStringAsFixed(2);
    return formatted.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

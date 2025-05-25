import 'package:intl/intl.dart';

class JackpotHit {
  final String type;
  final String id;
  final String name;
  final String amount;
  final String machineNumber;
  final DateTime timestamp;

  JackpotHit({
    required this.type,
    required this.id,
    required this.name,
    required this.amount,
    required this.machineNumber,
    required this.timestamp,
  });

  factory JackpotHit.fromJson(Map<String, dynamic> json) {
    return JackpotHit(
      type: json['type'] ?? 'Unknown',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      amount: json['amount'] ?? '0',
      machineNumber: json['machineNumber'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get formattedTimestamp => DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);
  String get formattedAmount => '\$${double.tryParse(amount)?.toStringAsFixed(2) ?? '0.00'}';
}

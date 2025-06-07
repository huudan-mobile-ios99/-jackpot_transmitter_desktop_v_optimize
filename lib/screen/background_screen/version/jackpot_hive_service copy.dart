// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:logger/logger.dart';
// import 'package:playtech_transmitter_app/service/config_custom.dart';
// class JackpotHiveService {
//   static const String _jackpotBoxName = 'jackpot_box';
//   static const String _jackpotHistoryKey = 'jackpot_history';
//   // final Logger _logger = Logger();
//   static bool _isHiveInitialized = false;

//   Future<void> initHive() async {
//     if (_isHiveInitialized) {
//       debugPrint('Hive already initialized, skipping.');
//       return;
//     }
//     try {
//       await Hive.initFlutter();
//       if (!Hive.isBoxOpen(_jackpotBoxName)) {
//         await Hive.openBox(_jackpotBoxName);
//       }
//       _isHiveInitialized = true;
//       debugPrint('Hive initialized for $_jackpotBoxName');
//     } catch (e) {
//       debugPrint('Error initializing Hive: $e');
//       rethrow;
//     }
//   }

//   Future<List<Map<String, double>>> getJackpotHistory() async {
//     final start = DateTime.now();
//     try {
//       if (!Hive.isBoxOpen(_jackpotBoxName)) {
//         debugPrint('Jackpot box not open, attempting to open.');
//         await Hive.openBox(_jackpotBoxName);
//       }
//       final box = Hive.box(_jackpotBoxName);
//       final historyRaw = box.get(_jackpotHistoryKey, defaultValue: []) as List;
//       debugPrint('Raw history size: ${historyRaw.length} entries');

//       final List<Map<String, double>> history = [];
//       for (var item in historyRaw) {
//         if (item is Map && item['values'] is Map) {
//           final values = <String, double>{};
//           item['values'].forEach((key, value) {
//             if (key is String && value is num && value != 0.0) {
//               values[key] = value.toDouble();
//             }
//           });
//           if (values.isNotEmpty && !history.contains(values)) {
//             history.add(values);
//           }
//         }
//       }

//       final result = history.length > 3 ? history.sublist(history.length - 3) : history;
//       debugPrint('Retrieved jackpot history: $result');
//       return result;
//     } catch (e) {
//       debugPrint('Error retrieving jackpot history: $e');
//       return [];
//     } finally {
//       final end = DateTime.now();
//       debugPrint('getJackpotHistory took: ${end.difference(start).inMilliseconds}ms');
//     }
//   }

//   Future<void> saveJackpotValues(Map<String, double> values) async {
//     try {
//       final box = Hive.box(_jackpotBoxName);
//       final historyRaw = box.get(_jackpotHistoryKey, defaultValue: []) as List;
//       final filteredValues = <String, double>{};

//       values.forEach((key, value) {
//         if (value != 0.0 && ConfigCustom.validJackpotNames.contains(key)) {
//           filteredValues[key] = value;
//         }
//       });

//       if (filteredValues.isNotEmpty) {
//         Map<String, double> lastValues = {};
//         if (historyRaw.isNotEmpty && historyRaw.last is Map) {
//           final last = historyRaw.last;
//           if (last['values'] is Map) {
//             last['values'].forEach((k, v) {
//               if (k is String && v is num) lastValues[k] = v.toDouble();
//             });
//           } else {
//             last.forEach((k, v) {
//               if (k is String && v is num) lastValues[k] = v.toDouble();
//             });
//           }
//         }
//         filteredValues.addAll(lastValues..removeWhere((k, v) => filteredValues.containsKey(k)));

//         historyRaw.add({
//           'values': filteredValues,
//           'timestamp': DateTime.now().toIso8601String(),
//         });
//         if (historyRaw.length > 100) {
//           historyRaw.removeRange(0, historyRaw.length - 100);
//         }
//         await box.put(_jackpotHistoryKey, historyRaw);
//         debugPrint('Saved to $_jackpotBoxName: $filteredValues at ${DateTime.now()}');
//       } else {
//         debugPrint('Skipped saving to $_jackpotBoxName: no valid data ($filteredValues)');
//       }
//     } catch (e) {
//       debugPrint('Error saving jackpot values: $e');
//       rethrow;
//     }
//   }

//   Future<void> appendJackpotHistory(Map<String, double> values) async {
//     try {
//       final box = Hive.box(_jackpotBoxName);
//       final historyRaw = box.get(_jackpotHistoryKey, defaultValue: []) as List;
//       final filteredValues = <String, double>{};

//       values.forEach((key, value) {
//         if (value != 0.0 && ConfigCustom.validJackpotNames.contains(key)) {
//           filteredValues[key] = value;
//         }
//       });

//       if (filteredValues.isNotEmpty) {
//         Map<String, double> lastValues = {};
//         if (historyRaw.isNotEmpty && historyRaw.last is Map) {
//           final last = historyRaw.last;
//           if (last['values'] is Map) {
//             last['values'].forEach((k, v) {
//               if (k is String && v is num) lastValues[k] = v.toDouble();
//             });
//           } else {
//             last.forEach((k, v) {
//               if (k is String && v is num) lastValues[k] = v.toDouble();
//             });
//           }
//         }
//         filteredValues.addAll(lastValues..removeWhere((k, v) => filteredValues.containsKey(k)));

//         historyRaw.add({
//           'values': filteredValues,
//           'timestamp': DateTime.now().toIso8601String(),
//         });
//         if (historyRaw.length > 100) {
//           historyRaw.removeRange(0, historyRaw.length - 100);
//         }
//         await box.put(_jackpotHistoryKey, historyRaw);
//         debugPrint('Appended to $_jackpotBoxName: $filteredValues at ${DateTime.now()}');
//       } else {
//         debugPrint('Skipped appending to $_jackpotBoxName');
//       }
//     } catch (e) {
//       debugPrint('Error appending jackpot history: $e');
//     }
//   }
// }

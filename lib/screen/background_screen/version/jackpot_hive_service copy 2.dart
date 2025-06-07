// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:logger/logger.dart';
// import 'package:playtech_transmitter_app/service/config_custom.dart';

// class JackpotHiveService {
//   static const String _jackpotBoxName = 'jackpotBox';
//   static const String _jackpotHistoryKey = 'jackpotHistory';
//   final Logger _logger = Logger();

//   Future<void> initHive() async {
//     try {
//       await Hive.initFlutter();
//       if (!Hive.isBoxOpen(_jackpotBoxName)) {
//         await Hive.openBox(_jackpotBoxName);
//       }
//       // _logger.i('Hive initialized for jackpotBox');
//       // debugPrint('JackpotHiveService: Hive initialized');
//     } catch (e) {
//       // _logger.e('Error initializing Hive: $e');
//       // debugPrint('JackpotHiveService: Error initializing Hive: $e');
//       rethrow;
//     }
//   }

//     Future<List<Map<String, double>>> getJackpotHistory() async {
//     final start = DateTime.now();
//     try {
//       if (!Hive.isBoxOpen(_jackpotBoxName)) {
//         // debugPrint('Jackpot box not open, attempting to open.');
//         await Hive.openBox(_jackpotBoxName);
//       }
//       final box = Hive.box(_jackpotBoxName);
//       final historyRaw = box.get(_jackpotHistoryKey, defaultValue: []) as List;
//       // debugPrint('Raw history size: ${historyRaw.length} entries');

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

//       final result = history.length > 10 ? history.sublist(history.length - 10) : history;
//       debugPrint('Retrieved jackpot history: $result');
//       return result;
//     } catch (e) {
//       // debugPrint('Error retrieving jackpot history: $e');
//       return [];
//     } finally {
//       final end = DateTime.now();
//       debugPrint('getJackpotHistory took: ${end.difference(start).inMilliseconds}ms');
//     }
//   }

//   Future<void> saveJackpotValues(Map<String, double> values) async {
//     try {
//       final box = await Hive.openBox(_jackpotBoxName);
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
//         await box.put(_jackpotHistoryKey, historyRaw);
//         // _logger.d('Saved to jackpotBox: $filteredValues at ${DateTime.now()}');
//         // debugPrint('JackpotHiveService: Saved values: $filteredValues at ${DateTime.now()}');
//       } else {
//         // _logger.d('Skipped saving to jackpotBox: no valid data ($filteredValues)');
//         // debugPrint('JackpotHiveService: Skipped save, no valid data: $filteredValues');
//       }
//     } catch (e) {
//       // _logger.e('Error saving jackpot values: $e');
//       // debugPrint('JackpotHiveService: Error saving values: $e');
//       rethrow;
//     }
//   }

//   Future<void> appendJackpotHistory(Map<String, double> values) async {
//     try {
//       final box = await Hive.openBox(_jackpotBoxName);
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
//         await box.put(_jackpotHistoryKey, historyRaw);
//         // _logger.d('Appended to jackpotBox: $filteredValues at ${DateTime.now()}');
//         // debugPrint('JackpotHiveService: Appended values: $filteredValues at ${DateTime.now()}');
//       } else {
//         // _logger.d('Skipped appending to jackpotBox: no valid data ($filteredValues)');
//         // debugPrint('JackpotHiveService: Skipped append, no valid data: $filteredValues');
//       }
//     } catch (e) {
//       // _logger.e('Error appending jackpot history: $e');
//       // debugPrint('JackpotHiveService: Error appending values: $e');
//       rethrow;
//     }
//   }
// }

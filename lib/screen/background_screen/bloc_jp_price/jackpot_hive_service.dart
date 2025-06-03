import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class JackpotHiveService {
  static const String _jackpotBoxName = 'jackpotBox';
  static const String _jackpotHistoryKey = 'jackpotHistory';
  final Logger _logger = Logger();

  Future<void> initHive() async {
    try {
      await Hive.initFlutter();
      if (!Hive.isBoxOpen(_jackpotBoxName)) {
        await Hive.openBox(_jackpotBoxName);
      }
      // _logger.i('Hive initialized for jackpotBox');
    } catch (e) {
      _logger.e('Error initializing Hive: $e');
      rethrow;
    }
  }

  Future<List<Map<String, double>>> getJackpotHistory() async {
  try {
    final box = await Hive.openBox(_jackpotBoxName);
    final historyRaw = box.get(_jackpotHistoryKey, defaultValue: []);

    final List<Map<String, double>> history = [];
    if (historyRaw is List) {
      for (var item in historyRaw) {
        if (item is Map) {
          final jackpotValues = <String, double>{};
          item.forEach((key, value) {
            if (key is String && value is num && value != 0.0) {
              jackpotValues[key] = value.toDouble();
            }
          });
          // Only include maps with all 9 prices
          if (jackpotValues.length == 9) {
            // Check for duplicates before adding
            bool isDuplicate = history.any((existing) =>
                existing.length == jackpotValues.length &&
                existing.entries.every((e) => jackpotValues[e.key] == e.value));
            if (!isDuplicate) {
              history.add(jackpotValues);
            }
          }
        }
      }
    }

    // Return the last 3 unique entries (most recent) or all if fewer than 3
    final result = history.length > 2 ? history.sublist(history.length - 2) : history;

    _logger.i('Retrieved jackpot history (TOP2: deduplicated): $result');
    return result;
  } catch (e) {
    _logger.e('Error retrieving jackpot history: $e');
    return [];
  }
}

  Future<void> saveJackpotValues(Map<String, double> values) async {
    try {
      final box = await Hive.openBox(_jackpotBoxName);
      final historyRaw = box.get(_jackpotHistoryKey, defaultValue: []);
      final List<Map<String, double>> history = [];

      // Convert historyRaw to List<Map<String, double>>
      if (historyRaw is List) {
        for (var item in historyRaw) {
          if (item is Map) {
            final jackpotValues = <String, double>{};
            item.forEach((key, value) {
              if (key is String && value is num) {
                jackpotValues[key] = value.toDouble();
              }
            });
            if (jackpotValues.length == 9) {
              history.add(jackpotValues);
            }
          }
        }
      }

      // Filter out 0.0 values
      final filteredValues = <String, double>{};
      values.forEach((key, value) {
        if (value != null && value != 0.0) {
          filteredValues[key] = value;
        }
      });

      // Only save if all 9 prices are present
      if (filteredValues.length == 9) {
        history.add(filteredValues);
        await box.put(_jackpotHistoryKey, history);
        _logger.d('Appended to jackpotBox: $filteredValues');
      } else {
        _logger.d('Skipped saving to jackpotBox: incomplete data ($filteredValues)');
      }
    } catch (e) {
      _logger.e('Error saving jackpot values: $e');
      rethrow; // Rethrow to allow caller to handle
    }
  }


  Future<void> appendJackpotHistory(Map<String, double> values) async {
    try {
      final box = await Hive.openBox(_jackpotBoxName);
      final historyRaw = box.get(_jackpotHistoryKey, defaultValue: []) as List;
      final filteredValues = <String, double>{};

      values.forEach((key, value) {
        if (value != 0.0) {
          filteredValues[key] = value;
        }
      });

      if (filteredValues.length == 9) {
        historyRaw.add(filteredValues);
        await box.put(_jackpotHistoryKey, historyRaw);
        _logger.d('Appended to jackpotBox: $filteredValues');
      } else {
        _logger.d('Skipped saving to jackpotBox: incomplete data ($filteredValues)');
      }
    } catch (e) {
      _logger.e('Error appending jackpot history: $e');
      rethrow;
    }
  }




}

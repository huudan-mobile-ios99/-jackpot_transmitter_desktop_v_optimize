import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_hive_service.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';

class HiveViewPage extends StatelessWidget {
  const HiveViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,height:500,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: JackpotHiveService().getJackpotHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            );
          }
          final history = snapshot.data ?? [];
          if (history.isEmpty) {
            return const Center(
              child: Text(
                'No jackpot history found',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jackpot History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final entry = history[index];
                    final values = entry['values'] as Map<String, double>;
                    final timestamp = entry['timestamp'] as DateTime;
                    final formattedTime = DateFormat('HH:mm:ss').format(timestamp);

                    return Card(
                      color: Colors.grey[900]?.withOpacity(0.8),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time: $formattedTime',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ...ConfigCustom.validJackpotNames.map((name) {
                              final value = values[name] ?? 0.0;
                              return Text(
                                '$name: ${value.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: value != 0.0 ? Colors.white : Colors.grey,
                                  fontSize: 12,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

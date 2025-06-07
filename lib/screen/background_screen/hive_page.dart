import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_hive_service.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';

class HiveViewPage extends StatelessWidget {
  const HiveViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ConfigCustom.fixHeight * 0.3,
      height: ConfigCustom.fixHeight * 0.3,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: JackpotHiveService().getJackpotHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularProgessCustom();
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading data',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            );
          }
          final history = snapshot.data ?? [];
          if (history.isEmpty) {
            return const Center(
              child: Text(
                'No data found',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          }

          return  Text(
                '${snapshot.data}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              );
        },
      ),
    );
  }
}

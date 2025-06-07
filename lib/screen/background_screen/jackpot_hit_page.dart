import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';
import 'package:playtech_transmitter_app/screen/background_screen/jackpot_video_bghit_page.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_bloc2.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_state2.dart';

import 'bloc_jp_price/jackpot_price_bloc.dart';
import 'bloc_jp_price/jackpot_price_event.dart';

class JackpotHitShowScreen extends StatelessWidget {
  const JackpotHitShowScreen({super.key});


  @override
  Widget build(BuildContext context) {
    Logger logger = Logger(); //loggger for ligh weight log
    return
    // JackpotBackgroundVideoHitWindowFadeAnimation(number: '1111', value: '33333', id: '2');

   BlocListener<JackpotBloc2,JackpotState2>(
    listener: (context, state) {
        // Trigger reset when a new hit is displayed
        if (state.showImagePage && state.latestHit != null) {
          final level = state.latestHit!['id'].toString();
          context.read<JackpotPriceBloc>().add(JackpotPriceResetEvent(level));
          logger.d('Dispatched JackpotPriceResetEvent for level: $level');
        }
      },
     child: BlocSelector<JackpotBloc2, JackpotState2, Map<String, dynamic>?>(
        selector: (state) {
          // Select hit data only when showImagePage is true and latestHit exists
          if (state.showImagePage && state.latestHit != null) {
            logger.d('JackpotHitShowScreen: ${state.latestHit}');
            return state.latestHit;
          }
          // Return null for loading, error, or empty states
          if (!state.isConnected && state.hits.isEmpty) {
            return {'isLoading': true, 'error': state.error};
          }
          return null;
        },
        builder: (context, hitData) {
          debugPrint('JackpotHitScreen BlocSelector: hitData=$hitData ');
          // Loading state
          if (hitData != null && hitData.containsKey('isLoading')) {
            if (hitData['error'] != null) {
              return Center(child: Text('Error: ${hitData['error']}', style: const TextStyle(color: Colors.white)));
            }
            return circularProgessCustom();
          }
          // Empty state
          if (hitData == null) {
            return const Center(child: Text('', style: TextStyle(color: Colors.white)));
          }
          // Hit state
          return JackpotBackgroundVideoHitWindowFadeAnimationP(
            id: hitData['id'].toString(),
            number: hitData['machineNumber'].toString(),
            value: hitData['amount'] == [] ? "0" : hitData['amount'].toString(),
          );
        },
      ),
   );

  }
}




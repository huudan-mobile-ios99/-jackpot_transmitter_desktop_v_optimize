import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/odometer/odometer_child.dart';
import 'package:playtech_transmitter_app/odometer/odometer_child_only_highlimit.dart';
import 'package:playtech_transmitter_app/screen/background_screen/jackpot_screen_page.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_price_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_state_state.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_hive_service.dart';
import 'package:logger/logger.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';

class JackpotDisplayScreenAll extends StatefulWidget {
  const JackpotDisplayScreenAll({super.key});

  @override
  State<JackpotDisplayScreenAll> createState() => _JackpotDisplayScreenAllState();
}

class _JackpotDisplayScreenAllState extends State<JackpotDisplayScreenAll> {
  final SettingsService settingsService = SettingsService();
  final Logger _logger = Logger();
  // late Future<Map<String, double>> _hiveValuesFuture;



  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<VideoBloc, ViddeoState>(
          buildWhen: (previous, current) => previous.id != current.id,
          builder: (context, state) {
            return BlocBuilder<JackpotPriceBloc, JackpotPriceState>(
              buildWhen: (previous, current) =>
                  previous.isConnected != current.isConnected ||
                  previous.error != current.error ||
                  previous.jackpotValues != current.jackpotValues ||
                  previous.previousJackpotValues != current.previousJackpotValues,
              builder: (context, priceState) {
                // _logger.i('Building JackpotDisplayScreenAll: ${priceState.jackpotValues}');
                return Center(
                  child: priceState.isConnected
                      ? SizedBox(
                          width: ConfigCustom.fixWidth/2,
                          height: 100,
                         child:
                          JackpotOdometer(
                            nameJP: ConfigCustom.tagFrequent,
                            valueKey: ConfigCustom.tagFrequent,
                            hiveValue:  0.0,
                          ),
                          // child:  Text("${priceState.jackpotValues['Frequent']}",style:TextStyle(color:Colors.white,fontSize: 12))
                        )
                      :
                      priceState.error != null ? Container() : circularProgessCustom()

                );
              },
            );
          },
        );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/odometer/odometer_child.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_price_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_state_state.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_hive_service.dart';
import 'package:logger/logger.dart';

class JackpotDisplayScreen extends StatefulWidget {
  const JackpotDisplayScreen({super.key});

  @override
  State<JackpotDisplayScreen> createState() => _JackpotDisplayScreenState();
}

class _JackpotDisplayScreenState extends State<JackpotDisplayScreen> {
  final SettingsService settingsService = SettingsService();
  final Logger _logger = Logger();
  late Future<Map<String, double>> _hiveValuesFuture;

  @override
  void initState() {
    super.initState();
    // Fetch Hive data once on initialization
    _hiveValuesFuture = JackpotHiveService().getJackpotHistory().then((state) => state.first);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: _hiveValuesFuture,
      builder: (context, snapshot) {
        Map<String, double> hiveValues = {};
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          hiveValues = snapshot.data!;
        } else if (snapshot.hasError) {
          _logger.e('Error loading Hive data: ${snapshot.error}');
        }

        return BlocBuilder<VideoBloc, ViddeoState>(
          buildWhen: (previous, current) => previous.id != current.id,
          builder: (context, state) {
            return BlocBuilder<JackpotPriceBloc, JackpotPriceState>(
              buildWhen: (previous, current) =>
                  previous.isConnected != current.isConnected ||
                  previous.error != current.error ||
                  previous.jackpotValues != current.jackpotValues ||
                  previous.previousJackpotValues != current.previousJackpotValues,
              builder: (context, priceState) {
                // _logger.i('Building JackpotDisplayScreen: ${priceState.jackpotValues}');
                return Center(
                  child: priceState.isConnected
                      ? SizedBox(
                          width: ConfigCustom.fixWidth,
                          height: ConfigCustom.fixHeight,
                          child: state.id == 1 ? screen1(context, hiveValues) : screen2(context, hiveValues),
                        )
                      : Text(
                          priceState.error != null ? "Error: ${priceState.error}" : "Connecting ...",
                          style: const TextStyle(fontSize: 8.0, color: Colors.white),
                        ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget screen1(BuildContext context, Map<String, double> hiveValues) {
    return Stack(
      children: [
        Positioned(
          top: settingsService.settings!.jpWeeklyScreen1DY,
          left: settingsService.settings!.jpWeeklyScreen1DX,
          child: JackpotOdometer(
            nameJP: "Weekly",
            valueKey: 'Weekly',
            hiveValue: hiveValues['Weekly'] ?? 0.0,
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpDozenScreen1DY,
          right: settingsService.settings!.jpDozenScreen1DX,
          child: JackpotOdometer(
            nameJP: "Dozen",
            valueKey: 'Dozen',
            hiveValue: hiveValues['Dozen'] ?? 0.0,
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpDailygoldenScreen1DY,
          left: settingsService.settings!.jpDailygoldenScreen1DX,
          child: JackpotOdometer(
            nameJP: "Daily Golden",
            valueKey: 'DailyGolden',
            hiveValue: hiveValues['DailyGolden'] ?? 0.0,
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpDailyScreen1DY,
          right: settingsService.settings!.jpDailyScreen1DX,
          child: JackpotOdometer(
            nameJP: "Daily",
            valueKey: 'Daily',
            hiveValue: hiveValues['Daily'] ?? 0.0,
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpFrequentScreen1DY,
          right: settingsService.settings!.jpFrequentScreen1DX,
          child: JackpotOdometer(
            nameJP: "Frequent",
            valueKey: 'Frequent',
            hiveValue: hiveValues['Frequent'] ?? 0.0,
          ),
        ),
      ],
    );
  }

  Widget screen2(BuildContext context, Map<String, double> hiveValues) {
    return Stack(
      children: [
        Positioned(
          top: settingsService.settings!.jpVegasScreen2DY,
          left: settingsService.settings!.getJpVegasScreen1DX,
          child: JackpotOdometer(
            nameJP: "Vegas",
            valueKey: 'Vegas',
            hiveValue: hiveValues['Vegas'] ?? 0.0,
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpMonthlyScreen2DY,
          right: settingsService.settings!.jpMonthlyScreen2DX,
          child: JackpotOdometer(
            nameJP: "Monthly",
            valueKey: 'Monthly',
            hiveValue: hiveValues['Monthly'] ?? 0.0,
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpWeeklyScreen2DY,
          left: settingsService.settings!.jpWeeklyScreen2DX,
          child: JackpotOdometer(
            nameJP: "Weekly",
            valueKey: 'Weekly',
            hiveValue: hiveValues['Weekly'] ?? 0.0,
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpTrippleScreen2DY,
          right: settingsService.settings!.jpTrippleScreen2DX,
          child: JackpotOdometer(
            nameJP: "Triple",
            valueKey: 'Triple',
            hiveValue: hiveValues['Triple'] ?? 0.0,
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpDozenScreen2DY,
          left: settingsService.settings!.jpDozenScreen2DX,
          child: JackpotOdometer(
            nameJP: "Dozen",
            valueKey: 'Dozen',
            hiveValue: hiveValues['Dozen'] ?? 0.0,
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpHighlimitScreen2DY,
          right: settingsService.settings!.jpHighlimitScreen2DX,
          child: JackpotOdometer(
            nameJP: "High Limit",
            valueKey: 'HighLimit',
            hiveValue: hiveValues['HighLimit'] ?? 0.0,
          ),
        ),
      ],
    );
  }
}

class JackpotOdometer extends StatelessWidget {
  final String nameJP;
  final String valueKey;
  final double hiveValue;

  const JackpotOdometer({
    super.key,
    required this.nameJP,
    required this.valueKey,
    required this.hiveValue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<JackpotPriceBloc, JackpotPriceState, ({double startValue, double endValue})>(
      selector: (state) {
        final blocStartValue = state.previousJackpotValues[valueKey] ?? 0.0;
        final endValue = state.jackpotValues[valueKey] ?? 0.0;
        return (startValue: blocStartValue, endValue: endValue);
      },
      builder: (context, values) {
        return GameOdometerChildStyleOptimized(
          startValue: values.startValue,
          endValue: values.endValue,
          nameJP: nameJP,
          hiveValue: hiveValue,
        );
      },
    );
  }
}

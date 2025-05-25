import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/odometer/odometer_child.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_price_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_state_state.dart';


class JackpotDisplayScreen extends StatelessWidget {
  JackpotDisplayScreen({super.key});
  final settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBloc, ViddeoState>(
      buildWhen: (previous, current) => previous.id != current.id,
      builder: (context, state) {
        // debugPrint('JackpotDisplayScreen rebuilt: id=${state.id}');
        return BlocBuilder<JackpotPriceBloc, JackpotPriceState>(
          buildWhen: (previous, current) => previous.isConnected != current.isConnected || previous.error != current.error,
          builder: (context, priceState) {
            return Center(
              child: priceState.isConnected
                  ? SizedBox(
                      width: ConfigCustom.fixWidth,
                      height: ConfigCustom.fixHeight,
                      child: state.id == 1 ? screen1(context) : screen2(context),
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
  }

  Widget screen1(BuildContext context) {
    return   Stack(
      children: [
        Positioned(
          top: settingsService.settings!.jpWeeklyScreen1DY,
          left: settingsService.settings!.jpWeeklyScreen1DX,
          child: const JackpotOdometer(
            nameJP: "Weekly",
            valueKey: 'Weekly',
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpDozenScreen1DY,
          right: settingsService.settings!.jpDozenScreen1DX,
          child: const JackpotOdometer(
            nameJP: "Dozen",
            valueKey: 'Dozen',
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpDailygoldenScreen1DY,
          left: settingsService.settings!.jpDailygoldenScreen1DX,
          child: const JackpotOdometer(
            nameJP: "Daily Golden",
            valueKey: 'DailyGolden',
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpDailyScreen1DY,
          right:settingsService.settings!.jpDailyScreen1DX,
          child: const JackpotOdometer(
            nameJP: "Daily",
            valueKey: 'Daily',
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpFrequentScreen1DY,
          right:settingsService.settings!.jpFrequentScreen1DX,
          child: const JackpotOdometer(
            nameJP: "Frequent",
            valueKey: 'Frequent',
          ),
        ),
      ],
    );
  }

  Widget screen2(BuildContext context) {
    return   Stack(
      children: [
        Positioned(
          top: settingsService.settings!.jpVegasScreen2DY,
          left: settingsService.settings!.getJpVegasScreen1DX,
          child:const JackpotOdometer(
            nameJP: "Vegas",
            valueKey: 'Vegas',
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpMonthlyScreen2DY,
          right: settingsService.settings!.jpMonthlyScreen2DX,
          child:const JackpotOdometer(
            nameJP: "Monthly",
            valueKey: 'Monthly',
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpWeeklyScreen2DY,
          left: settingsService.settings!.jpWeeklyScreen2DX,
          child: const JackpotOdometer(
            nameJP: "Weekly",
            valueKey: 'Weekly',
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpTrippleScreen2DY,
          right: settingsService.settings!.jpTrippleScreen2DX,
          child:const JackpotOdometer(
            nameJP: "Triple",
            valueKey: 'Triple',
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpDozenScreen2DY,
          left: settingsService.settings!.jpDozenScreen2DX,
          child: const JackpotOdometer(
            nameJP: "Dozen",
            valueKey: 'Dozen',
          ),
        ),
        Positioned(
          top: settingsService.settings!.jpHighlimitScreen2DY,
          right: settingsService.settings!.jpHighlimitScreen2DX,
          child: const JackpotOdometer(
            nameJP: "High Limit",
            valueKey: 'HighLimit',
          ),
        ),
      ],
    );
  }
}

class JackpotOdometer extends StatelessWidget {
  final String nameJP;
  final String valueKey;

  const JackpotOdometer({
    super.key,
    required this.nameJP,
    required this.valueKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<JackpotPriceBloc, JackpotPriceState, ({double startValue, double endValue})>(
      selector: (state) {
        final startValue = state.previousJackpotValues[valueKey] ?? 0.0;
        final endValue = state.jackpotValues[valueKey] ?? 0.0;
        // debugPrint('JackpotOdometer selector: $valueKey, startValue=$startValue, endValue=$endValue');
        return (startValue: startValue, endValue: endValue);
      },
      builder: (context, values) {
        // debugPrint('JackpotOdometer rebuilt: $valueKey, endValue=${values.endValue}');
        return GameOdometerChildStyleOptimized(
          startValue: values.startValue,
          endValue: values.endValue,
          nameJP: nameJP,
        );
      },
    );
  }
}

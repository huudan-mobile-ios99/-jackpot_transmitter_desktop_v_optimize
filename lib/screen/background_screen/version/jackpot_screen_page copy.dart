// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:playtech_transmitter_app/odometer/odometer_child.dart';
// import 'package:playtech_transmitter_app/odometer/odometer_child_only_highlimit.dart';
// import 'package:playtech_transmitter_app/service/config_custom.dart';
// import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_price_bloc.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_state_state.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_hive_service.dart';
// import 'package:logger/logger.dart';
// import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_hive_service.dart';


// class JackpotDisplayScreen extends StatefulWidget {
//   const JackpotDisplayScreen({super.key});

//   @override
//   State<JackpotDisplayScreen> createState() => _JackpotDisplayScreenState();
// }

// class _JackpotDisplayScreenState extends State<JackpotDisplayScreen> {
//   final SettingsService settingsService = SettingsService();
//   final Logger _logger = Logger();
//   Map<String, double> _hiveValues = {};
//     late Future<Map<String, double>> _hiveValuesFuture;
//     int _retryCount = 0;
//   static const int _maxRetries = 3;


//   @override
//   void initState() {
//     super.initState();
//     // Get cached Hive data synchronously
//     _fetchHiveData();
//   }
//   void _fetchHiveData() {
//     _hiveValuesFuture = _tryFetchHiveData();
//   }

//   Future<Map<String, double>> _tryFetchHiveData() async {
//     while (_retryCount < _maxRetries) {
//       try {
//         final history = await JackpotHiveService().getJackpotHistory();
//         if (history.isNotEmpty) {
//           _retryCount = 0;
//           return history.first;
//         }
//         _retryCount++;
//         _logger.w('Empty jackpot history, retrying ($_retryCount/$_maxRetries)');
//         await Future.delayed(const Duration(milliseconds: 100));
//       } catch (e) {
//         _retryCount++;
//         _logger.e('Error fetching Hive data: $e, retrying ($_retryCount/$_maxRetries)');
//         await Future.delayed(const Duration(milliseconds: 100));
//       }
//     }
//     _logger.e('Failed to load jackpot history after $_maxRetries retries');
//     return {};
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<VideoBloc, ViddeoState>(
//       buildWhen: (previous, current) => previous.id != current.id,
//       builder: (context, state) {
//         return BlocBuilder<JackpotPriceBloc, JackpotPriceState>(
//           buildWhen: (previous, current) =>
//               previous.isConnected != current.isConnected ||
//               previous.error != current.error ||
//               previous.jackpotValues != current.jackpotValues ||
//               previous.previousJackpotValues != current.previousJackpotValues,
//           builder: (context, priceState) {
//             _logger.i('Building JackpotDisplayScreen: ${priceState.jackpotValues}');
//             return Center(
//               child: priceState.isConnected
//                   ? SizedBox(
//                       width: ConfigCustom.fixWidth,
//                       height: ConfigCustom.fixHeight,
//                       child: state.id == 1 ? screen1(context, _hiveValues) : screen2(context, _hiveValues),
//                     )
//                   : priceState.error != null
//                       ? Container()
//                       : circularProgessCustom(),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget screen1(BuildContext context, Map<String, double> hiveValues) {
//     return Stack(
//       children: [
//         Positioned(
//           top: ConfigCustom.jp_weekly_screen1_dY,
//           left: ConfigCustom.jp_weekly_screen1_dX,
//           child: JackpotOdometer(
//             nameJP: ConfigCustom.tagWeekly,
//             valueKey: ConfigCustom.tagWeekly,
//             hiveValue: hiveValues[ConfigCustom.tagWeekly] ?? 0.0,
//           ),
//         ),
//         Positioned(
//           top: ConfigCustom.jp_dozen_screen1_dY,
//           right: ConfigCustom.jp_dozen_screen1_dX,
//           child: JackpotOdometer(
//             nameJP: ConfigCustom.tagDozen,
//             valueKey: ConfigCustom.tagDozen,
//             hiveValue: hiveValues[ConfigCustom.tagDozen] ?? 0.0,
//           ),
//         ),
//         Positioned(
//           top: ConfigCustom.jp_daily_screen1_dY,
//           left: ConfigCustom.jp_daily_screen1_dX,
//           child: JackpotOdometer(
//             nameJP: ConfigCustom.tagDailyGolden,
//             valueKey: ConfigCustom.tagDailyGolden,
//             hiveValue: hiveValues[ConfigCustom.tagDailyGolden] ?? 0.0,
//           ),
//         ),
//         Positioned(
//           top: ConfigCustom.jp_daily_screen1_dY,
//           right: ConfigCustom.jp_daily_screen1_dX,
//           child: JackpotOdometer(
//             nameJP: ConfigCustom.tagDaily,
//             valueKey: ConfigCustom.tagDaily,
//             hiveValue: hiveValues[ConfigCustom.tagDaily] ?? 0.0,
//           ),
//         ),
//         Positioned(
//           top: ConfigCustom.jp_frequent_screen1_dY,
//           right: ConfigCustom.jp_frequent_screen1_dX,
//           child: JackpotOdometer(
//             nameJP: ConfigCustom.tagFrequent,
//             valueKey: ConfigCustom.tagFrequent,
//             hiveValue: hiveValues[ConfigCustom.tagFrequent] ?? 0.0,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget screen2(BuildContext context, Map<String, double> hiveValues) {
//     return Stack(
//       children: [
//         Positioned(
//           top: ConfigCustom.jp_vegas_screen2_dY,
//           left: ConfigCustom.jp_vegas_screen1_dX,
//           child: JackpotOdometer(
//             nameJP: ConfigCustom.tagVegas,
//             valueKey: ConfigCustom.tagVegas,
//             hiveValue: hiveValues[ConfigCustom.tagVegas] ?? 0.0,
//           ),
//         ),
//         Positioned(
//           top: ConfigCustom.jp_monthly_screen2_dY,
//           right: ConfigCustom.jp_monthly_screen2_dX,
//           child: JackpotOdometer(
//             nameJP: ConfigCustom.tagMonthly,
//             valueKey: ConfigCustom.tagMonthly,
//             hiveValue: hiveValues[ConfigCustom.tagMonthly] ?? 0.0,
//           ),
//         ),
//         Positioned(
//           top: ConfigCustom.jp_weekly_screen2_dY,
//           left: ConfigCustom.jp_weekly_screen2_dX,
//           child: JackpotOdometer(
//             nameJP: ConfigCustom.tagWeekly,
//             valueKey: ConfigCustom.tagWeekly,
//             hiveValue: hiveValues[ConfigCustom.tagWeekly] ?? 0.0,
//           ),
//         ),
//         Positioned(
//           top: ConfigCustom.jp_tripple_screen2_dY,
//           right: ConfigCustom.jp_tripple_screen2_dX,
//           child: JackpotOdometer(
//             nameJP: ConfigCustom.tagTriple,
//             valueKey: ConfigCustom.tagTriple,
//             hiveValue: hiveValues[ConfigCustom.tagTriple] ?? 0.0,
//           ),
//         ),
//         Positioned(
//           top: ConfigCustom.jp_dozen_screen2_dY,
//           left: ConfigCustom.jp_dozen_screen2_dX,
//           child: JackpotOdometer(
//             nameJP: ConfigCustom.tagDozen,
//             valueKey: ConfigCustom.tagDozen,
//             hiveValue: hiveValues[ConfigCustom.tagDozen] ?? 0.0,
//           ),
//         ),
//         Positioned(
//           top: ConfigCustom.jp_highlimit_screen2_dY,
//           right: ConfigCustom.jp_highlimit_screen2_dX,
//           child: JackpotOdometerOnlyHighLimit(
//             nameJP: ConfigCustom.tagHighLimit,
//             valueKey: ConfigCustom.tagHighLimit,
//             hiveValue: hiveValues[ConfigCustom.tagHighLimit] ?? 0.0,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class JackpotOdometer extends StatelessWidget {
//   final String nameJP;
//   final String valueKey;
//   final double hiveValue;

//   const JackpotOdometer({
//     super.key,
//     required this.nameJP,
//     required this.valueKey,
//     required this.hiveValue,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<JackpotPriceBloc, JackpotPriceState, ({double startValue, double endValue})>(
//       selector: (state) {
//         final blocStartValue = state.previousJackpotValues[valueKey] ?? 0.0;
//         final endValue = state.jackpotValues[valueKey] ?? 0.0;
//         return (startValue: blocStartValue, endValue: endValue);
//       },
//       builder: (context, values) {
//         return GameOdometerChildStyleOptimized(
//           startValue: values.startValue,
//           endValue: values.endValue,
//           nameJP: nameJP,
//           hiveValue: hiveValue,
//         );
//       },
//     );
//   }
// }

// class JackpotOdometerOnlyHighLimit extends StatelessWidget {
//   final String nameJP;
//   final String valueKey;
//   final double hiveValue;

//   const JackpotOdometerOnlyHighLimit({
//     super.key,
//     required this.nameJP,
//     required this.valueKey,
//     required this.hiveValue,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<JackpotPriceBloc, JackpotPriceState, ({double startValue, double endValue})>(
//       selector: (state) {
//         final blocStartValue = state.previousJackpotValues[valueKey] ?? 0.0;
//         final endValue = state.jackpotValues[valueKey] ?? 0.0;
//         return (startValue: blocStartValue, endValue: endValue);
//       },
//       builder: (context, values) {
//         return GameOdometerChildStyleOnlyForHighLimit(
//           startValue: values.startValue,
//           endValue: values.endValue,
//           nameJP: nameJP,
//         );
//       },
//     );
//   }
// }

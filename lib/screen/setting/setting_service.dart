import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Settings class (unchanged from previous solution)
class Settings {
  final String endpointWebSocket;
  final String endpointJpHit;
  final String videoBackgroundScreen1;
  final String videoBackgroundScreen2;
  final int durationFadeAnimateScreenSwitchMs;
  final int durationFadeAnimateHitJpMs;
  final int durationShowVideoBackgroundSecond;
  final int durationShowVideoBackgroundJackpotSecond;
  final int durationShowVideoBackgroundHotseatSecond;
  final int windowWidth;
  final int windowHeight;
  final int windowMinWidth;
  final int windowMinHeight;
  final int windowBorderRadius;
  final String fontFamily;
  final double textHitPriceOffsetDx;
  final double textHitPriceOffsetDy;
  final double textHitPriceBlurRadius;
  final double textHitPriceSize;
  final double textHitPriceDX;
  final double textHitPriceDY;
  final double textHitNumberOffsetDx;
  final double textHitNumberOffsetDy;
  final double textHitNumberBlurRadius;
  final double textHitNumberSize;
  final double textHitNumberDX;
  final double textHitNumberDY;
  final double textOdoSize;
  final double textOdoOffsetDx;
  final double textOdoBlurRadius;
  final double textOdoLetterWidth;
  final double textOdoLetterVerticalOffset;
  final double odoWidth;
  final double odoHeight;
  final double odoPositionTop;
  final String textOdoComment;
  final double jpFrequentScreen1DX;
  final double jpFrequentScreen1DY;
  final double jpDailyScreen1DX;
  final double jpDailyScreen1DY;
  final double jpDailygoldenScreen1DX;
  final double jpDailygoldenScreen1DY;
  final double jpDozenScreen1DX;
  final double jpDozenScreen1DY;
  final double jpWeeklyScreen1DX;
  final double jpWeeklyScreen1DY;
  final double jpHighlimitScreen2DX;
  final double jpHighlimitScreen2DY;
  final double jpDozenScreen2DX;
  final double jpDozenScreen2DY;
  final double jpTrippleScreen2DX;
  final double jpTrippleScreen2DY;
  final double jpWeeklyScreen2DX;
  final double jpWeeklyScreen2DY;
  final double jpMonthlyScreen2DX;
  final double jpMonthlyScreen2DY;
  final double jpVegasScreen1DX;
  final double jpVegasScreen2DY;
  final String jpScreenComment;
  final int jpIdFrequent;
  final String jpIdFrequentVideoPath;
  final int jpIdDaily;
  final String jpIdDailyVideoPath;
  final int jpIdDailygolden;
  final String jpIdDailygoldenVideoPath;
  final int jpIdDozen;
  final String jpIdDozenVideoPath;
  final int jpIdWeekly;
  final String jpIdWeeklyVideoPath;
  final int jpIdHighlimit;
  final String jpIdHighlimitVideoPath;
  final int jpIdMonthly;
  final String jpIdMonthlyVideoPath;
  final int jpIdVegas;
  final String jpIdVegasVideoPath;
  final int jpIdTripple;
  final String jpIdTrippleVideoPath;
  final int hotseatId7771st;
  final String jpId7771stVideoPath;
  final int hotseatId7772nd;
  final String jpId7772ndVideoPath;
  final int hotseatId10001st;
  final String jpId10001stVideoPath;
  final int hotseatId10002nd;
  final String jpId10002ndVideoPath;
  final int hotseatIdPpochiMonFri;
  final String jpIdPpochiMonFriVideoPath;
  final int hotseatIdPpochiSatSun;
  final String jpIdPpochiSatSunVideoPath;
  final int hotseatIdRlPpochi;
  final String jpIdRlPpochiVideoPath;
  final int hotseatIdNew20Ppochi;
  final String jpIdNew20PpochiVideoPath;

  Settings({
    required this.endpointWebSocket,
    required this.endpointJpHit,
    required this.videoBackgroundScreen1,
    required this.videoBackgroundScreen2,
    required this.durationFadeAnimateScreenSwitchMs,
    required this.durationFadeAnimateHitJpMs,
    required this.durationShowVideoBackgroundSecond,
    required this.durationShowVideoBackgroundJackpotSecond,
    required this.durationShowVideoBackgroundHotseatSecond,
    required this.windowWidth,
    required this.windowHeight,
    required this.windowMinWidth,
    required this.windowMinHeight,
    required this.windowBorderRadius,
    required this.fontFamily,
    required this.textHitPriceOffsetDx,
    required this.textHitPriceOffsetDy,
    required this.textHitPriceBlurRadius,
    required this.textHitPriceSize,
    required this.textHitPriceDX,
    required this.textHitPriceDY,
    required this.textHitNumberOffsetDx,
    required this.textHitNumberOffsetDy,
    required this.textHitNumberBlurRadius,
    required this.textHitNumberSize,
    required this.textHitNumberDX,
    required this.textHitNumberDY,
    required this.textOdoSize,
    required this.textOdoOffsetDx,
    required this.textOdoBlurRadius,
    required this.textOdoLetterWidth,
    required this.textOdoLetterVerticalOffset,
    required this.odoWidth,
    required this.odoHeight,
    required this.odoPositionTop,
    required this.textOdoComment,
    required this.jpFrequentScreen1DX,
    required this.jpFrequentScreen1DY,
    required this.jpDailyScreen1DX,
    required this.jpDailyScreen1DY,
    required this.jpDailygoldenScreen1DX,
    required this.jpDailygoldenScreen1DY,
    required this.jpDozenScreen1DX,
    required this.jpDozenScreen1DY,
    required this.jpWeeklyScreen1DX,
    required this.jpWeeklyScreen1DY,
    required this.jpHighlimitScreen2DX,
    required this.jpHighlimitScreen2DY,
    required this.jpDozenScreen2DX,
    required this.jpDozenScreen2DY,
    required this.jpTrippleScreen2DX,
    required this.jpTrippleScreen2DY,
    required this.jpWeeklyScreen2DX,
    required this.jpWeeklyScreen2DY,
    required this.jpMonthlyScreen2DX,
    required this.jpMonthlyScreen2DY,
    required this.jpVegasScreen1DX,
    required this.jpVegasScreen2DY,
    required this.jpScreenComment,
    required this.jpIdFrequent,
    required this.jpIdFrequentVideoPath,
    required this.jpIdDaily,
    required this.jpIdDailyVideoPath,
    required this.jpIdDailygolden,
    required this.jpIdDailygoldenVideoPath,
    required this.jpIdDozen,
    required this.jpIdDozenVideoPath,
    required this.jpIdWeekly,
    required this.jpIdWeeklyVideoPath,
    required this.jpIdHighlimit,
    required this.jpIdHighlimitVideoPath,
    required this.jpIdMonthly,
    required this.jpIdMonthlyVideoPath,
    required this.jpIdVegas,
    required this.jpIdVegasVideoPath,
    required this.jpIdTripple,
    required this.jpIdTrippleVideoPath,
    required this.hotseatId7771st,
    required this.jpId7771stVideoPath,
    required this.hotseatId7772nd,
    required this.jpId7772ndVideoPath,
    required this.hotseatId10001st,
    required this.jpId10001stVideoPath,
    required this.hotseatId10002nd,
    required this.jpId10002ndVideoPath,
    required this.hotseatIdPpochiMonFri,
    required this.jpIdPpochiMonFriVideoPath,
    required this.hotseatIdPpochiSatSun,
    required this.jpIdPpochiSatSunVideoPath,
    required this.hotseatIdRlPpochi,
    required this.jpIdRlPpochiVideoPath,
    required this.hotseatIdNew20Ppochi,
    required this.jpIdNew20PpochiVideoPath,
  });
  // settings_data.dart
  Map<String, dynamic> settingsJson = {
    'endpoint_web_socket': 'ws://example.com',
    'endpoint_jp_hit': 'http://example.com',
    // ... other fields
  };

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      endpointWebSocket: json['endpoint_web_socket'] as String,
      endpointJpHit: json['endpoint_jp_hit'] as String,
      videoBackgroundScreen1: json['video_background_screen1'] as String,
      videoBackgroundScreen2: json['video_background_screen2'] as String,
      durationFadeAnimateScreenSwitchMs: json['duration_fade_animate_screen_switch_ms'] as int,
      durationFadeAnimateHitJpMs: json['duration_fade_animate_hit_jp_ms'] as int,
      durationShowVideoBackgroundSecond: json['duration_show_video_background_second'] as int,
      durationShowVideoBackgroundJackpotSecond: json['duration_show_video_background_jackpot_second'] as int,
      durationShowVideoBackgroundHotseatSecond: json['duration_show_video_background_hotseat_second'] as int,
      windowWidth: json['width_height'] as int,
      windowHeight: json['width_height'] as int,
      windowMinWidth: json['window_min_width'] as int,
      windowMinHeight: json['width_min_height'] as int,
      windowBorderRadius: json['window_border_radius'] as int,
      fontFamily: json['font_family'] as String,
      textHitPriceOffsetDx: (json['text_hit_price_offset_dx'] as num).toDouble(),
      textHitPriceOffsetDy: (json['text_hit_price_offset_dy'] as num).toDouble(),
      textHitPriceBlurRadius: (json['text_hit_price_blur_radius'] as num).toDouble(),
      textHitPriceSize: (json['text_hit_price_size'] as num).toDouble(),
      textHitPriceDX: (json['text_hit_price_dX'] as num).toDouble(),
      textHitPriceDY: (json['text_hit_price_dY'] as num).toDouble(),
      textHitNumberOffsetDx: (json['text_hit_number_offset_dx'] as num).toDouble(),
      textHitNumberOffsetDy: (json['text_hit_number_offset_dy'] as num).toDouble(),
      textHitNumberBlurRadius: (json['text_hit__number_blur_radius'] as num).toDouble(),
      textHitNumberSize: (json['text_hit_number_size'] as num).toDouble(),
      textHitNumberDX: (json['text_hit_number_dX'] as num).toDouble(),
      textHitNumberDY: (json['text_hit_number_dY'] as num).toDouble(),
      textOdoSize: (json['text_odo_size'] as num).toDouble(),
      textOdoOffsetDx: (json['text_odo_offset_dx'] as num).toDouble(),
      textOdoBlurRadius: (json['text_odo_blur_radius'] as num).toDouble(),
      textOdoLetterWidth: (json['text_odo_letter_width'] as num).toDouble(),
      textOdoLetterVerticalOffset: (json['text_odo_letter_vertical_offset'] as num).toDouble(),
      odoWidth: (json['odo_width'] as num).toDouble(),
      odoHeight: (json['odo_height'] as num).toDouble(),
      odoPositionTop: (json['odo_position_top'] as num).toDouble(),
      textOdoComment: json['text_odo_comment'] as String,
      jpFrequentScreen1DX: (json['jp_frequent_screen1_dX'] as num).toDouble(),
      jpFrequentScreen1DY: (json['jp_frequent_screen1_dY'] as num).toDouble(),
      jpDailyScreen1DX: (json['jp_daily_screen1_dX'] as num).toDouble(),
      jpDailyScreen1DY: (json['jp_daily_screen1_dY'] as num).toDouble(),
      jpDailygoldenScreen1DX: (json['jp_dailygolden_screen1_dX'] as num).toDouble(),
      jpDailygoldenScreen1DY: (json['jp_dailygolden_screen1_dY'] as num).toDouble(),
      jpDozenScreen1DX: (json['jp_dozen_screen1_dX'] as num).toDouble(),
      jpDozenScreen1DY: (json['jp_dozen_screen1_dY'] as num).toDouble(),
      jpWeeklyScreen1DX: (json['jp_weekly_screen1_dX'] as num).toDouble(),
      jpWeeklyScreen1DY: (json['jp_weekly_screen1_dY'] as num).toDouble(),
      jpHighlimitScreen2DX: (json['jp_highlimit_screen2_dX'] as num).toDouble(),
      jpHighlimitScreen2DY: (json['jp_highlimit_screen2_dY'] as num).toDouble(),
      jpDozenScreen2DX: (json['jp_dozen_screen2_dX'] as num).toDouble(),
      jpDozenScreen2DY: (json['jp_dozen_screen2_dY'] as num).toDouble(),
      jpTrippleScreen2DX: (json['jp_tripple_screen2_dX'] as num).toDouble(),
      jpTrippleScreen2DY: (json['jp_tripple_screen2_dY'] as num).toDouble(),
      jpWeeklyScreen2DX: (json['jp_weekly_screen2_dX'] as num).toDouble(),
      jpWeeklyScreen2DY: (json['jp_weekly_screen2_dY'] as num).toDouble(),
      jpMonthlyScreen2DX: (json['jp_monthly_screen2_dX'] as num).toDouble(),
      jpMonthlyScreen2DY: (json['jp_monthly_screen2_dY'] as num).toDouble(),
      jpVegasScreen1DX: (json['jp_vegas_screen1_dX'] as num).toDouble(),
      jpVegasScreen2DY: (json['jp_vegas_screen2_dY'] as num).toDouble(),
      jpScreenComment: json['jp_screen_comment'] as String,
      jpIdFrequent: json['jp_id_frequent'] as int,
      jpIdFrequentVideoPath: json['jp_id_frequent_video_path'] as String,
      jpIdDaily: json['jp_id_daily'] as int,
      jpIdDailyVideoPath: json['jp_id_daily_video_path'] as String,
      jpIdDailygolden: json['jp_id_dailygolden'] as int,
      jpIdDailygoldenVideoPath: json['jp_id_dailygolden_video_path'] as String,
      jpIdDozen: json['jp_id_dozen'] as int,
      jpIdDozenVideoPath: json['jp_id_dozen_video_path'] as String,
      jpIdWeekly: json['jp_id_weekly'] as int,
      jpIdWeeklyVideoPath: json['jp_id_weekly_video_path'] as String,
      jpIdTripple: json['jp_id_tripple'] as int,
      jpIdTrippleVideoPath: json['jp_id_tripple_video_path'] as String,
      jpIdHighlimit: json['jp_id_highlimit'] as int,
      jpIdHighlimitVideoPath: json['jp_id_highlimit_video_path'] as String,
      jpIdMonthly: json['jp_id_monthly'] as int,
      jpIdMonthlyVideoPath: json['jp_id_monthly_video_path'] as String,
      jpIdVegas: json['jp_id_vegas'] as int,
      jpIdVegasVideoPath: json['jp_id_vegas_video_path'] as String,
      hotseatId7771st: json['hotseat_id_777_1st'] as int,
      jpId7771stVideoPath: json['jp_id_777_1st_video_path'] as String,
      hotseatId7772nd: json['hotseat_id_777_2nd'] as int,
      jpId7772ndVideoPath: json['jp_id_777_2nd_video_path'] as String,
      hotseatId10001st: json['hotseat_id_1000_1st'] as int,
      jpId10001stVideoPath: json['jp_id_1000_1st_video_path'] as String,
      hotseatId10002nd: json['hotseat_id_1000_2nd'] as int,
      jpId10002ndVideoPath: json['jp_id_1000_2nd_video_path'] as String,
      hotseatIdPpochiMonFri: json['hotseat_id_ppochi_Mon_Fri'] as int,
      jpIdPpochiMonFriVideoPath: json['jp_id_ppochi_Mon_Fri_video_path'] as String,
      hotseatIdPpochiSatSun: json['hotseat_id_ppochi_Sat_Sun'] as int,
      jpIdPpochiSatSunVideoPath: json['jp_id_ppochi_Sat_Sun_video_path'] as String,
      hotseatIdRlPpochi: json['hotseat_id_RL_ppochi'] as int,
      jpIdRlPpochiVideoPath: json['jp_id_RL_ppochi_video_path'] as String,
      hotseatIdNew20Ppochi: json['hotseat_id_New_20_ppochi'] as int,
      jpIdNew20PpochiVideoPath: json['jp_id_New_20_ppochi_video_path'] as String,
    );
  }

  // Getters
  String get getEndpointWebSocket => endpointWebSocket;
  String get getEndpointJpHit => endpointJpHit;
  String get getVideoBackgroundScreen1 => videoBackgroundScreen1;
  String get getVideoBackgroundScreen2 => videoBackgroundScreen2;
  int get getDurationFadeAnimateScreenSwitchMs => durationFadeAnimateScreenSwitchMs;
  int get getDurationFadeAnimateHitJpMs => durationFadeAnimateHitJpMs;
  int get getDurationShowVideoBackgroundSecond => durationShowVideoBackgroundSecond;
  int get getDurationShowVideoBackgroundJackpotSecond => durationShowVideoBackgroundJackpotSecond;
  int get getDurationShowVideoBackgroundHotseatSecond => durationShowVideoBackgroundHotseatSecond;
  int get getWindowWidth => windowWidth;
  int get getWindowHeight => windowHeight;
  int get getWindowMinWidth => windowMinWidth;
  int get getWindowMinHeight => windowMinHeight;
  int get getWindowBorderRadius => windowBorderRadius;
  String get getFontFamily => fontFamily;
  double get getTextHitPriceOffsetDx => textHitPriceOffsetDx;
  double get getTextHitPriceOffsetDy => textHitPriceOffsetDy;
  double get getTextHitPriceBlurRadius => textHitPriceBlurRadius;
  double get getTextHitPriceSize => textHitPriceSize;
  double get getTextHitPriceDX => textHitPriceDX;
  double get getTextHitPriceDY => textHitPriceDY;
  double get getTextHitNumberOffsetDx => textHitNumberOffsetDx;
  double get getTextHitNumberOffsetDy => textHitNumberOffsetDy;
  double get getTextHitNumberBlurRadius => textHitNumberBlurRadius;
  double get getTextHitNumberSize => textHitNumberSize;
  double get getTextHitNumberDX => textHitNumberDX;
  double get getTextHitNumberDY => textHitNumberDY;
  double get getTextOdoSize => textOdoSize;
  double get getTextOdoOffsetDx => textOdoOffsetDx;
  double get getTextOdoBlurRadius => textOdoBlurRadius;
  double get getTextOdoLetterWidth => textOdoLetterWidth;
  double get getTextOdoLetterVerticalOffset => textOdoLetterVerticalOffset;
  double get getOdoWidth => odoWidth;
  double get getOdoHeight => odoHeight;
  double get getOdoPositionTop => odoPositionTop;
  String get getTextOdoComment => textOdoComment;
  double get getJpFrequentScreen1DX => jpFrequentScreen1DX;
  double get getJpFrequentScreen1DY => jpFrequentScreen1DY;
  double get getJpDailyScreen1DX => jpDailyScreen1DX;
  double get getJpDailyScreen1DY => jpDailyScreen1DY;
  double get getJpDailygoldenScreen1DX => jpDailygoldenScreen1DX;
  double get getJpDailygoldenScreen1DY => jpDailygoldenScreen1DY;
  double get getJpDozenScreen1DX => jpDozenScreen1DX;
  double get getJpDozenScreen1DY => jpDozenScreen1DY;
  double get getJpWeeklyScreen1DX => jpWeeklyScreen1DX;
  double get getJpWeeklyScreen1DY => jpWeeklyScreen1DY;
  double get getJpHighlimitScreen2DX => jpHighlimitScreen2DX;
  double get getJpHighlimitScreen2DY => jpHighlimitScreen2DY;
  double get getJpDozenScreen2DX => jpDozenScreen2DX;
  double get getJpDozenScreen2DY => jpDozenScreen2DY;
  double get getJpTrippleScreen2DX => jpTrippleScreen2DX;
  double get getJpTrippleScreen2DY => jpTrippleScreen2DY;
  double get getJpWeeklyScreen2DX => jpWeeklyScreen2DX;
  double get getJpWeeklyScreen2DY => jpWeeklyScreen2DY;
  double get getJpMonthlyScreen2DX => jpMonthlyScreen2DX;
  double get getJpMonthlyScreen2DY => jpMonthlyScreen2DY;
  double get getJpVegasScreen1DX => jpVegasScreen1DX;
  double get getJpVegasScreen2DY => jpVegasScreen2DY;
  String get getJpScreenComment => jpScreenComment;
  int get getJpIdFrequent => jpIdFrequent;
  String get getJpIdFrequentVideoPath => jpIdFrequentVideoPath;
  int get getJpIdDaily => jpIdDaily;
  String get getJpIdDailyVideoPath => jpIdDailyVideoPath;
  int get getJpIdDailygolden => jpIdDailygolden;
  String get getJpIdDailygoldenVideoPath => jpIdDailygoldenVideoPath;
  int get getJpIdDozen => jpIdDozen;
  String get getJpIdDozenVideoPath => jpIdDozenVideoPath;
  int get getJpIdWeekly => jpIdWeekly;
  String get getJpIdWeeklyVideoPath => jpIdWeeklyVideoPath;
  int get getJpIdHighlimit => jpIdHighlimit;
  String get getJpIdHighlimitVideoPath => jpIdHighlimitVideoPath;
  int get getJpIdMonthly => jpIdMonthly;
  String get getJpIdMonthlyVideoPath => jpIdMonthlyVideoPath;
  int get getJpIdVegas => jpIdVegas;
  String get getJpIdVegasVideoPath => jpIdVegasVideoPath;
  int get getJpIdTripple => jpIdTripple;
  String get getJpIdTrippleVideoPath => jpIdTrippleVideoPath;
  int get getHotseatId7771st => hotseatId7771st;
  String get getJpId7771stVideoPath => jpId7771stVideoPath;
  int get getHotseatId7772nd => hotseatId7772nd;
  String get getJpId7772ndVideoPath => jpId7772ndVideoPath;
  int get getHotseatId10001st => hotseatId10001st;
  String get getJpId10001stVideoPath => jpId10001stVideoPath;
  int get getHotseatId10002nd => hotseatId10002nd;
  String get getJpId10002ndVideoPath => jpId10002ndVideoPath;
  int get getHotseatIdPpochiMonFri => hotseatIdPpochiMonFri;
  String get getJpIdPpochiMonFriVideoPath => jpIdPpochiMonFriVideoPath;
  int get getHotseatIdPpochiSatSun => hotseatIdPpochiSatSun;
  String get getJpIdPpochiSatSunVideoPath => jpIdPpochiSatSunVideoPath;
  int get getHotseatIdRlPpochi => hotseatIdRlPpochi;
  String get getJpIdRlPpochiVideoPath => jpIdRlPpochiVideoPath;
  int get getHotseatIdNew20Ppochi => hotseatIdNew20Ppochi;
  String get getJpIdNew20PpochiVideoPath => jpIdNew20PpochiVideoPath;
}





// // Singleton SettingsService
// class SettingsService {
//   static final SettingsService _instance = SettingsService._internal();
//   factory SettingsService() => _instance;
//   SettingsService._internal();

//   Settings? _settings;
//   String? _formattedJson;
//   String? _error;

//   Future<void> init(BuildContext context) async {
//     try {
//       final jsonString = await DefaultAssetBundle.of(context).loadString('asset/setting.json');
//       final jsonData = json.decode(jsonString);
//       _settings = Settings.fromJson(jsonData);
//       _formattedJson = const JsonEncoder.withIndent('  ').convert(jsonData);
//       _error = null;
//     } catch (e) {
//       _error = 'Error loading JSON: $e';
//       _settings = null;
//       _formattedJson = null;
//     }
//   }

//   Settings? get settings => _settings;
//   String? get formattedJson => _formattedJson;
//   String? get error => _error;
// }

// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;

class SettingsService {
  static SettingsService? _instance;
  Map<String, dynamic>? _settings;
  String? _error;
  bool _isInitialized = false;

  static SettingsService get instance {
    _instance ??= SettingsService();
    return _instance!;
  }

  Map<String, dynamic>? get settings => _settings;
  String? get error => _error;

  Future<void> init(BuildContext? context) async {
    if (_isInitialized) return;
    try {
      final jsonString = await rootBundle.loadString('assets/setting.json');
      _settings = jsonDecode(jsonString) as Map<String, dynamic>;
      _isInitialized = true;
    } catch (e) {
      _error = 'Failed to load settings: $e';
      _isInitialized = true; // Mark as initialized to avoid retrying
    }
  }
}

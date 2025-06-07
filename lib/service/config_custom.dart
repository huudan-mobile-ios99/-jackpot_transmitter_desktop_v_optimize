class ConfigCustom {
  static const String endpoint_web_socket = 'ws://192.168.100.165:8080';// static const String urlSocketJPHit = 'http://30.0.0.56:3002';
  static const String endpoint_jp_hit = 'http://192.168.101.58:8097'; //endpointWebSocket= "ws://localhost:8080"
  // static const String endpointWebSocket= "ws://192.168.101.58:8081";  //endpointWebSocket= "ws://localhost:8080"
  static const double fixWidth= 1920; //1.25 ratio
  static const double fixHeight= 1080;//1.25 ratio

  static int durationSwitchVideoSecond = 30; //swich video 1 and video background 2 after every 2min
  static int durationGetDataToBloc = 0;
  static int durationGetDataToBlocFirstMS = 100;
  static int switchBetweeScreenDuration = 0;
  static int switchBetweeScreenDurationForHitScreen = 0;
  static int durationTimerVideoHitShow_Jackpot = 30; //show video hit for 30
  static int durationTimerVideoHitShow_Hotseat = 20; //show video hit for 30
  static int secondToReConnect = 10;


  static int totalCountToRestart = 100; //1count will be 1min



  // Reset values
  static const double resetFrequentJP = 300.0;
  static const double resetDailyJP = 5000.0;
  static const double resetDailyGoldenJP = 10000.0;
  static const double resetDozenJP = 20000.0;
  static const double resetWeeklyJP = 50000.0;
  static const double resetHighLimitJP = 10000.0;
  static const double resetTripleJP = 30000.0;
  static const double resetMonthlyJP = 105000.0;
  static const double resetVegasJP = 100000.0;

  // Levels
  static const int levelFrequent = 0;
  static const int levelDaily = 1;
  static const int levelDailyGolden = 34;
  static const int levelDozen = 2;
  static const int levelWeekly = 3;
  static const int levelHighLimit = 45;
  static const int levelTriple = 35;
  static const int levelMonthly = 46;
  static const int levelVegas = 4;
  static const int level7771st = 80;
  static const int level7771stAlt = 81;
  static const int level10001st = 88;
  static const int level10001stAlt = 89;
  static const int levelPpochiMonFri = 97;
  static const int levelPpochiMonFriAlt = 98;
  static const int levelRlPpochi = 109;
  static const int levelNew20Ppochi = 119;


  // Jackpot names
  static const String tagFrequent = 'Frequent';
  static const String tagDaily = 'Daily';
  static const String tagDailyGolden = 'DailyGolden';
  static const String tagDozen = 'Dozen';
  static const String tagWeekly = 'Weekly';
  static const String tagHighLimit = 'HighLimit';
  static const String tagTriple = 'Triple';
  static const String tagMonthly = 'Monthly';
  static const String tagVegas = 'Vegas';
  static const String tag7771st = '7771st';
  static const String tag10001st = '10001st';
  static const String tagPpochiMonFri = 'PpochiMonFri';
  static const String tagRlPpochi = 'RlPpochi';
  static const String tagNew20Ppochi = 'New20Ppochi';



  static const  String  videoBackgroundScreen1 = 'asset/video/video_background.mp4';
  static const  String  videoBackgroundScreen2 = 'asset/video/video_background2.mp4';


  static const String video_background_screen1 = 'asset/video/video_background.mp4';
  static const String video_background_screen2 = 'asset/video/video_background2.mp4';
  static const int duration_fade_animate_screen_switch_ms = 500;
  static const int duration_fade_animate_hit_jp_ms = 600;
  static const int duration_show_video_background_second = 30;
  static const int duration_show_video_background_jackpot_second = 30;
  static const int duration_show_video_background_hotseat_second = 30;
  static const int window_width = 1536;
  static const int width_height = 864;
  static const int window_min_width = 1536;
  static const int width_min_height = 864;
  static const int window_border_radius = 16;
  static const String font_family = 'sf-pro-display';

  static const double text_hit_price_offset_dx = 0.0;
  static const double text_hit_price_offset_dy = 3.0;
  static const double text_hit_price_blur_radius = 4.0;
  static const double text_hit_price_size = 125.0;
  static const double text_hit_price_dX = 100.0;
  static const double text_hit_price_dY = 100.0;
  static const double text_hit_number_offset_dx = 0.0;
  static const double text_hit_number_offset_dy = 2.0;
  static const double text_hit_number_blur_radius = 4.0;
  static const double text_hit_number_size = 55.0;
  static const double text_hit_number_dX = 68.0;
  static const double text_hit_number_dY = 30.0;
  static const double text_odo_size = 108.5;
  static const double text_odo_offset_dx = 0.0;
  static const double text_odo_blur_radius = 3.5;
  static const double text_odo_letter_width = 68.5;
  static const double text_odo_letter_vertical_offset = 100.0;
  static const double odo_width = 768.0;
  static const double odo_height = 112.5;
  static const double odo_position_top = 23.5;
  static const String text_odo_comment = 'odo_width=width/2 (current:1536/2);text odo_letter_width = text_odo_size*0.615; text_odo_letter_vertical_offset =text_odo_size* 1.1';
  static const double jp_frequent_screen1_dX = -103.5;
  static const double jp_frequent_screen1_dY = 777.0;
  static const double jp_daily_screen1_dX = -30.0;
  static const double jp_daily_screen1_dY = 485.0;
  static const double jp_dailygolden_screen1_dX = 16.0;
  static const double jp_dailygolden_screen1_dY = 485.0;
  static const double jp_dozen_screen1_dX = 0.0;
  static const double jp_dozen_screen1_dY = 193.5;
  static const double jp_weekly_screen1_dX = 24.0;
  static const double jp_weekly_screen1_dY = 193.5;
  static const double jp_highlimit_screen2_dX = -16.0;
  static const double jp_highlimit_screen2_dY = 777.0;
  static const double jp_dozen_screen2_dX = -16.0;
  static const double jp_dozen_screen2_dY = 777.0;
  static const double jp_tripple_screen2_dX = -8.0;
  static const double jp_tripple_screen2_dY = 485.0;
  static const double jp_weekly_screen2_dX = -8.0;
  static const double jp_weekly_screen2_dY = 485.0;
  static const double jp_monthly_screen2_dX = -5.0;
  static const double jp_monthly_screen2_dY = 193.5;
  static const double jp_vegas_screen1_dX = -8.0;
  static const double jp_vegas_screen2_dY = 193.5;
  static const String jp_screen_comment = 'jp_screen1 for layout 1 content 5 prices jackpot, jp_screen2 for layout 2 content 6 price jackpot';
  static const int jp_id_frequent = 0;
  static const String jp_id_frequent_video_path = 'asset/video/frequent.mpg';
  static const int jp_id_daily = 1;
  static const String jp_id_daily_video_path = 'asset/video/daily.mpg';
  static const int jp_id_dailygolden = 34;
  static const String jp_id_dailygolden_video_path = 'asset/video/daily_golden.mpg';
  static const int jp_id_dozen = 2;
  static const String jp_id_dozen_video_path = 'asset/video/dozen.mpg';
  static const int jp_id_weekly = 3;
  static const String jp_id_weekly_video_path = 'asset/video/weekly.mpg';
  static const int jp_id_highlimit = 45;
  static const String jp_id_highlimit_video_path = 'asset/video/high_limit.mpg';
  static const int jp_id_monthly = 46;
  static const String jp_id_monthly_video_path = 'asset/video/monthly.mp4';
  static const int jp_id_vegas = 4;
  static const String jp_id_vegas_video_path = 'asset/video/vegas.mpg';
  static const int jp_id_tripple = 35;
  static const String jp_id_tripple_video_path = 'asset/video/tripple.mpg';
  static const int hotseat_id_777_1st = 80;
  static const String jp_id_777_1st_video_path = 'asset/video/tripple777.mp4';
  static const int hotseat_id_777_2nd = 81;
  static const String jp_id_777_2nd_video_path = 'asset/video/tripple777.mp4';
  static const int hotseat_id_1000_1st = 88;
  static const String jp_id_1000_1st_video_path = 'asset/video/1000.mpg';
  static const int hotseat_id_1000_2nd = 89;
  static const String jp_id_1000_2nd_video_path = 'asset/video/1000.mpg';
  static const int hotseat_id_ppochi_Mon_Fri = 97;
  static const String jp_id_ppochi_Mon_Fri_video_path = 'asset/video/ppochi.mp4';
  static const int hotseat_id_ppochi_Sat_Sun = 98;
  static const String jp_id_ppochi_Sat_Sun_video_path = 'asset/video/ppochi.mp4';
  static const int hotseat_id_RL_ppochi = 109;
  static const String jp_id_RL_ppochi_video_path = 'asset/video/ppochi_rl.mp4';
  static const int hotseat_id_New_20_ppochi = 119;
  static const String jp_id_New_20_ppochi_video_path = 'asset/video/ppochi_slot.mp4';


  // Helper methods
  static String? getJackpotNameByLevel(String level) {
    switch (level) {
      case '$levelFrequent':
        return tagFrequent;
      case '$levelDaily':
        return tagDaily;
      case '$levelDailyGolden':
        return tagDailyGolden;
      case '$levelDozen':
        return tagDozen;
      case '$levelWeekly':
        return tagWeekly;
      case '$levelHighLimit':
        return tagHighLimit;
      case '$levelTriple':
        return tagTriple;
      case '$levelMonthly':
        return tagMonthly;
      case '$levelVegas':
        return tagVegas;
      case '$level7771st':
      case '$level7771stAlt':
        return tag7771st;
      case '$level10001st':
      case '$level10001stAlt':
        return tag10001st;
      case '$levelPpochiMonFri':
      case '$levelPpochiMonFriAlt':
        return tagPpochiMonFri;
      case '$levelRlPpochi':
        return tagRlPpochi;
      case '$levelNew20Ppochi':
        return tagNew20Ppochi;
      default:
        return null;
    }
  }





  static double? getResetValueByLevel(String level) {
    switch (level) {
      case '$levelFrequent':
        return resetFrequentJP;
      case '$levelDaily':
        return resetDailyJP;
      case '$levelDailyGolden':
        return resetDailyGoldenJP;
      case '$levelDozen':
        return resetDozenJP;
      case '$levelWeekly':
        return resetWeeklyJP;
      case '$levelHighLimit':
        return resetHighLimitJP;
      case '$levelTriple':
        return resetTripleJP;
      case '$levelMonthly':
        return resetMonthlyJP;
      case '$levelVegas':
        return resetVegasJP;
      case '$level7771st':
      default:
        return null;
    }
  }



  static List<String> get validJackpotNames => [
        tagFrequent,
        tagDaily,
        tagDailyGolden,
        tagDozen,
        tagWeekly,
        tagHighLimit,
        tagTriple,
        tagMonthly,
        tagVegas,
        tag7771st,
        tag10001st,
        tagPpochiMonFri,
        tagRlPpochi,
        tagNew20Ppochi,
      ];


}


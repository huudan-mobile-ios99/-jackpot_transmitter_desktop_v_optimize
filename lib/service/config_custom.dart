class ConfigCustom {
  static const String urlSocketJPHit = 'http://192.168.101.58:8097';  // static const String urlSocketJPHit = 'http://30.0.0.56:3002';
  static const String endpointWebSocket= "ws://192.168.100.165:8080";  //endpointWebSocket= "ws://localhost:8080"
  // static const String endpointWebSocket= "ws://192.168.101.58:8081";  //endpointWebSocket= "ws://localhost:8080"
  static const double fixWidth= 1920; //1.25 ratio
  static const double fixHeight= 1080;//1.25 ratio
  static String videoBg = 'asset/video/video_background.mp4';
  static String videoBg2 = 'asset/video/video_background2.mp4';
  static int durationSwitchVideoSecond = 30; //swich video 1 and video background 2 after every 2min
  static int durationGetDataToBloc = 10;
  static int durationGetDataToBlocFirstMS = 50;
  static int switchBetweeScreenDuration = 300;
  static int switchBetweeScreenDurationForHitScreen = 300;
  static int durationTimerVideoHitShow = 30; //show video hit for 30
  static int secondToReConnect = 10;



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


class ConfigCustom {
  static const String urlSocketJPHit = 'http://192.168.101.58:8097';  // static const String urlSocketJPHit = 'http://30.0.0.56:3002';
  static const String endpointWebSocket= "ws://192.168.100.165:8080";  //endpointWebSocket= "ws://localhost:8080"
  // static const String endpointWebSocket= "ws://192.168.101.58:8081";  //endpointWebSocket= "ws://localhost:8080"
  static const double fixWidth= 1920; //1.25 ratio
  static const double fixHeight= 1080;//1.25 ratio
  static String videoBg = 'asset/video/video_background.mp4';
  static String videoBg2 = 'asset/video/video_background2.mp4';
  static int durationSwitchVideoSecond = 300; //swich video 1 and video background 2 after every 2min
  static int durationGetDataToBloc = 5;
  static int durationGetDataToBlocFirstMS = 25;
  static int switchBetweeScreenDuration = 300;
  static int switchBetweeScreenDurationForHitScreen = 300;
  static int durationTimerVideoHitShow = 30; //show video hit for 30
  static int secondToReConnect = 10;
}

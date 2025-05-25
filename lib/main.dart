import 'dart:async';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/jackpot_video_bg_page2.dart';
import 'package:playtech_transmitter_app/screen/background_screen/jackpot_video_bghit_page2.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/setting/bloc/setting_bloc.dart';
import 'package:playtech_transmitter_app/screen/setting/bloc/setting_event.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_price_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/jackpot_hit_page.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_bloc2.dart';
import 'package:media_kit/media_kit.dart';                      // Provides [Player], [Media], [Playlist] etc.


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await Window.initialize();
  await Window.makeTitlebarTransparent();
  await Window.hideWindowControls();
  await Window.disableCloseButton();
  runApp(const MyApp());

  doWhenWindowReady(() {
      appWindow
        ..size =const Size(ConfigCustom.fixWidth, ConfigCustom.fixHeight)
        ..alignment = Alignment.center
        ..startDragging()
        ..minimize()
        ..show();
    });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent
      ),
      home: const MyAppBody(),
    );
  }
}

class MyAppBody extends StatefulWidget {
  const MyAppBody({super.key});
  @override
  MyAppBodyState createState() => MyAppBodyState();
}

class MyAppBodyState extends State<MyAppBody> {
  WindowEffect effect = WindowEffect.aero;
  @override
  void initState() {
    super.initState();
    Window.setEffect(
      effect: WindowEffect.transparent,
      color: Colors.transparent,
      dark: true,
    );
  }



  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => JackpotBloc2(),),
        BlocProvider(create: (context) => SettingsBloc()..add(LoadSettingsEvent()),),
        BlocProvider(create: (context) => JackpotPriceBloc(),),
        BlocProvider(create: (context) => VideoBloc(videoBg1: ConfigCustom.videoBg, videoBg2: ConfigCustom.videoBg2),
      ),
      ],
      child: FutureBuilder(
        future: SettingsService().init(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: circularProgessCustom()),
          );
        }
        final settingsService = SettingsService();
        if (settingsService.error != null) {
          return Scaffold(
            body: Center(child: Text(settingsService.error!)),
          );
        }
        return
        const Scaffold(
          body:
           Stack(
            children: [
               RepaintBoundary(child: JackpotBackgroundShowWindowFadeAnimateV2()), //show first (contain background and number jp prices)
               RepaintBoundary(child: JackpotHitShowScreen()), //show second (contain video background of types of jp prices based on its id)
            ],
          )
        );}
      ),
    );
  }
}


import 'dart:async';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_hive_service.dart';
import 'package:window_manager/window_manager.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:playtech_transmitter_app/screen/background_screen/jackpot_video_bg_page.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/setting/bloc/setting_bloc.dart';
import 'package:playtech_transmitter_app/screen/setting/bloc/setting_event.dart';

import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/jackpot_price_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/jackpot_hit_page.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_bloc2.dart';
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final hiveService = JackpotHiveService();
  await Hive.initFlutter();
  await hiveService.initHive();
  // await hiveService.getJackpotHistory(); // Preload Hive data
  await Window.initialize();
  await Window.makeTitlebarTransparent();
  await Window.hideWindowControls();
  await Window.disableCloseButton();
  await Window.setWindowBackgroundColorToClear();

  runApp(Phoenix(child: const MyApp()));

  doWhenWindowReady(() {
    appWindow
      ..size = const Size(ConfigCustom.fixWidth, ConfigCustom.fixHeight)
      ..alignment = Alignment.center
      ..startDragging()
      ..maximize()
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
      theme: ThemeData(scaffoldBackgroundColor: Colors.transparent),
      home: const MyAppBody(),
    );
  }
}

class MyAppBody extends StatefulWidget {
  const MyAppBody({super.key});
  @override
  MyAppBodyState createState() => MyAppBodyState();
}

class MyAppBodyState extends State<MyAppBody> with WindowListener {
  Timer? _restartTimer; // Timer for auto-restart
  WindowEffect effect = WindowEffect.transparent;
  @override
  void initState() {
    super.initState();
    Window.setEffect(
      effect: WindowEffect.transparent,
      color: Colors.transparent,
      dark: false,
    );
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _restartTimer?.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }

  Future<void> _initWindowManager() async {
    // Prevent window from closing immediately to show confirmation dialog
    await windowManager.setPreventClose(true);
    await windowManager.setBackgroundColor(Colors.transparent);
    setState(() {});
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose && mounted) {}
  }

  //Restart App
  void _restartApp() {
    final start = DateTime.now();
    Phoenix.rebirth(context);
    final end = DateTime.now();
    debugPrint('RESTART ACTION TAKE: ${end.difference(start).inMilliseconds}ms');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => JackpotBloc2(),
          ),
          BlocProvider(
            create: (context) => SettingsBloc()..add(LoadSettingsEvent()),
          ),
          BlocProvider(
            create: (context) => JackpotPriceBloc(),
          ),
          BlocProvider(
            create: (context) => VideoBloc(
                videoBg1: ConfigCustom.videoBackgroundScreen1,
                videoBg2: ConfigCustom.videoBackgroundScreen2,
                context: context),
          ),
        ],
        child: BlocListener<VideoBloc, ViddeoState>(
            listener: (context, state) {
              if (state.isRestart) {
                debugPrint( 'MyAppBody: Triggering app restart via BlocListener');
                _restartApp();
              }
            },
            child:   Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  const RepaintBoundary( child: JackpotBackgroundShowWindowFadeAnimateP()),
                  RepaintBoundary(child:
                    JackpotHitShowScreen()
                    ),
                ],
              ),
            )));
  }
}

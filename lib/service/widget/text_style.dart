import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
final settingsService = SettingsService();
final textStyleOdo =  TextStyle(
    fontSize: settingsService.settings!.textOdoSize,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.normal,
    // shadows: const [
    //   Shadow(
    //     color: Colors.orangeAccent,
    //     offset: Offset(0, 2),
    //     blurRadius: 4,
    //   ),
    // ],
  );
final textStyleJPHit = TextStyle(
      fontSize: settingsService.settings!.textHitPriceSize,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.normal,
      // shadows: const [
      //   Shadow(
      //     color: Colors.orangeAccent,
      //     offset: Offset(0, 2),
      //     blurRadius: 4,
      //   ),
      // ],
    );
    final textStyleSmall = TextStyle(
      fontSize: settingsService.settings!.textHitNumberSize,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.normal,
      // shadows: const [
      //   Shadow(
      //     color: Colors.orangeAccent,
      //     offset: Offset(0, 2),
      //     blurRadius: 4,
      //   ),
      // ],
    );
const textStyleOdoSmall =  TextStyle(
    fontSize: 50,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.normal,
    // shadows: [
    //   Shadow(
    //     color: Colors.orangeAccent,
    //     offset: Offset(0, 2),
    //     blurRadius: 4,
    //   ),
    // ],
  );

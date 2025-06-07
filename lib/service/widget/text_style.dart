import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
final settingsService = SettingsService();
final textStyleOdo =  TextStyle(
    fontSize: ConfigCustom.text_odo_size,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.normal,
  );
final textStyleJPHit =  TextStyle(
      fontSize:  ConfigCustom.text_hit_price_size,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.normal,
      shadows: const [
        Shadow(
          color: Colors.orangeAccent,
          offset: Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    );
    final textStyleSmall = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.normal,
      shadows: const [
        Shadow(
          color: Colors.orangeAccent,
          offset: Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    );
const textStyleOdoSmall =  TextStyle(
    fontSize: 50,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.normal,

  );

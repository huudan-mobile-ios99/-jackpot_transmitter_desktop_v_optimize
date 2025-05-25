

import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/service/color_custom.dart';

Widget circularProgessCustom(){
    return const Center(child: CircularProgressIndicator(
      color: ColorCustom.yellowMain,
      strokeWidth: .5,
    )) ;// Loading indicator
}

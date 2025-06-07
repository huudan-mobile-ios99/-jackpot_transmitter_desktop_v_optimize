

import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/service/color_custom.dart';

Widget circularProgessCustom(){
    return Container(
      color:Colors.transparent,
      child: const Center(child: CircularProgressIndicator(
        color: ColorCustom.yellowMain,
        strokeWidth: .25,
      )),
    ) ;// Loading indicator
}

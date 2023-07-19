import 'package:flutter/material.dart';

const String fontFamily = "Instrument Sans";

class AppTheme {
  static Color primaryColor = const Color(0xff633CFF);
  static TextStyle headerText = const TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: Color(0xff333333)
  );
  static TextStyle bodyText = const TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: Color(0xff333333)
  );
  static TextStyle buttonText = const TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: Colors.white
  );
}

import 'package:flutter/material.dart';

class SizeUtils {
  static double getScreenWidth(BuildContext context, int percent) {
    return MediaQuery.of(context).size.width * percent / 100;
  }

  static getScreenHeight(BuildContext context, int percent) {
    return MediaQuery.of(context).size.height * percent / 100;
  }

  static double getDynamicFontSize(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * percent / 100;
  }
}

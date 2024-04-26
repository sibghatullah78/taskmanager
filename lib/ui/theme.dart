import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

const Color purple = Colors.purple;
const Color darkBlue = Colors.lightBlue;`
const Color pinkClr = Colors.pinkAccent;
const Color white = Colors.white;
const primaryClr = purple;
const Color darkGreyClr = Color(0xFF121212);
Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
    primaryColor: primaryClr, //color of appbar and buttons
    brightness: Brightness.light, colorScheme: ColorScheme(background: Colors.white), //background color of body
  );

  static final dark = ThemeData(
    primaryColor: darkGreyClr, //color of appbar and buttons
    brightness: Brightness.dark, colorScheme: ColorScheme(background: darkGreyClr), //background color of body
  );
}

TextStyle get subheadingStyle {
  return TextStyle(
    fontFamily: 'Lateef',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
  );
}

TextStyle get headingStyle {
  return TextStyle(
    fontFamily: 'Lateef',
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  );
}

TextStyle get titleStyle {
  return TextStyle(
    fontFamily: 'Lateef',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  );
}

TextStyle get subTitleStyle {
  return TextStyle(
    fontFamily: 'Lateef',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  );
}

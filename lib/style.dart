import 'package:flutter/material.dart';

Color mainColor = const Color(0xFF81D0D6);
Color bgColor = Colors.white;
Color iBgColor = Colors.grey.withOpacity(0.1);
Color txtColor = Colors.black;
Color iTxtColor = Colors.black38;
double cardSize = 150.0;

MaterialColor mainMColor = MaterialColor(
  mainColor.value,
  <int, Color>{
    50: mainColor,
    100: mainColor,
    200: mainColor,
    300: mainColor,
    400: mainColor,
    500: mainColor,
    600: mainColor,
    700: mainColor,
    800: mainColor,
    900: mainColor,
  },
);

TextStyle sTs = const TextStyle(fontSize: 12.0);
TextStyle mTs = const TextStyle(fontSize: 16.0);
TextStyle lTs = const TextStyle(fontSize: 20.0);

void changeToDarkMode() {
  bgColor = const Color(0xFF3A3A3C);
  txtColor = Colors.white;
}

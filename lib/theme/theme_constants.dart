import 'package:flutter/material.dart';

Color primaryColor = const Color.fromARGB(255, 17, 100, 102);
Color secondaryColor = const Color.fromARGB(255, 217, 176, 140);
Color tertiaryColor = const Color.fromARGB(255, 255, 203, 154);
Color backgroundColor = const Color.fromARGB(255, 18, 19, 18);
Color cardColor = const Color.fromARGB(255, 209, 232, 226);

ThemeData customTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
    ));

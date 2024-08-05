import 'package:book_frontend/theme/button_themes.dart';
import 'package:flutter/material.dart';

Color primaryColor = const Color.fromARGB(255, 17, 100, 102);
Color secondaryColor = const Color.fromARGB(255, 217, 176, 140);
Color tertiaryColor = const Color.fromARGB(255, 255, 203, 154);
Color backgroundColor = const Color.fromARGB(255, 18, 19, 18);
Color bottomNavBarColor = const Color.fromARGB(255, 32, 35, 32);
Color cardColor = const Color.fromARGB(255, 209, 232, 226);

Color appBarColor = const Color.fromARGB(255, 25, 26, 25);

ThemeData customTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(backgroundColor: appBarColor, elevation: 5),
    elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
    ));

import 'package:book_frontend/theme/theme_constants.dart';
import 'package:flutter/material.dart';

TextStyle? prominentTextStyle(TextTheme appTextTheme) => appTextTheme.bodyMedium
    ?.copyWith(color: primaryColor, fontWeight: FontWeight.bold);

TextStyle? bookNameStyle(TextTheme appTextTheme) => appTextTheme.bodyLarge
    ?.copyWith(color: secondaryColor, fontWeight: FontWeight.bold);

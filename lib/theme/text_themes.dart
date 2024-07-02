import 'package:book_frontend/theme/theme_constants.dart';
import 'package:flutter/material.dart';

TextStyle? prominentTextStyle(TextTheme appTextTheme) => appTextTheme.bodyMedium
    ?.copyWith(color: primaryColor, fontWeight: FontWeight.bold);

TextStyle? categoryNameStyle(TextTheme appTextTheme) =>
    appTextTheme.bodySmall?.copyWith();

// book name styles
TextStyle? bookNameStyle(TextTheme appTextTheme) => appTextTheme.bodyLarge
    ?.copyWith(color: secondaryColor, fontWeight: FontWeight.bold);

TextStyle? bookNameLargeStyle(TextTheme appTextTheme) =>
    appTextTheme.bodyLarge?.copyWith(
        color: secondaryColor, fontSize: 20, fontWeight: FontWeight.bold);

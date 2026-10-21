import 'package:flutter/material.dart';

class AppTheme {
  static const teal = Color(0xFF0F766E);
  static const background = Color(0xFFF8FAFC);

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: teal),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: teal,
      foregroundColor: Colors.white,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: teal,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
      ),
    ),
  );
}

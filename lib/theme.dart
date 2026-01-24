import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = const Color.fromRGBO(0, 38, 163, 1);
  static const Color secondaryColor = Colors.deepPurple;
  static const Color backgroundColor = Color(0xFFF5F5F5);

  static const TextStyle subText = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static ThemeData init() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
      ),
    );
  }
}

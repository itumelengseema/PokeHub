import 'package:flutter/material.dart';
class AppThemeData {

  AppThemeData._();


  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      primaryColor: Colors.red,
      colorScheme: const ColorScheme.light(
        primary: Colors.red,
        secondary: Colors.blue,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.red,
      colorScheme: const ColorScheme.dark(
        primary: Colors.red,
        secondary: Colors.blue,
      ),
      scaffoldBackgroundColor: Colors.grey.shade900,
      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.grey[850],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

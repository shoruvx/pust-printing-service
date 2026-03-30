import 'package:flutter/material.dart';

// Define the Material Design 3 theme for the application.
class AppTheme {
  static ThemeData getThemeData() {
    final base = ThemeData.fallback();

    return base.copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ).copyWith(
        primary: Colors.blue,
        secondary: Colors.green,
        error: Colors.red,
      ),
      textTheme: Typography.material2021().copyWith(
        bodyText1: TextStyle(color: Colors.black, fontSize: 16),
        bodyText2: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          textStyle: TextStyle(fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      // Add more custom styles here
    );
  }
}
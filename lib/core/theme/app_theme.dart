import 'package:flutter/material.dart';

class AppTheme {
  // Define custom colors
  static const Color _primaryPurple = Color(0xFF6200EE);
  static const Color _secondaryPurple = Color(0xFF03DAC6);
  static const Color _backgroundBlack = Color(0xFF121212);
  static const Color _surfaceBlack = Color(0xFF1E1E1E);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: _primaryPurple,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: _primaryPurple,
      secondary: _secondaryPurple,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryPurple,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryPurple, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: _primaryPurple,
    scaffoldBackgroundColor: _backgroundBlack,
    colorScheme: const ColorScheme.dark(
      primary: _primaryPurple,
      secondary: _secondaryPurple,
      surface: _surfaceBlack,
      background: _backgroundBlack,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _surfaceBlack,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surfaceBlack,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryPurple, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      color: _surfaceBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

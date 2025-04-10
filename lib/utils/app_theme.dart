import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF1F8B4C);
  static const Color primaryDarkColor = Color(0xFF2E7D32);
  static const Color accentColor = Color(0xFF4CAF50);
  
  // Background colors
  static const Color lightBackground = Colors.white;
  static const Color darkBackground = Color(0xFF121212);
  
  // Surface colors
  static const Color lightSurface = Colors.white;
  static const Color darkSurface = Color(0xFF1E1E1E);
  
  // Text colors
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
  
  // Islamic-themed colors
  static const Color kaaba = Color(0xFF000000);
  static const Color gold = Color(0xFFD4AF37);
  static const Color mosque = Color(0xFF81C784);
  
  // Font families
  static const String primaryFont = 'Roboto';
  static const String arabicFont = 'Amiri';
  
  // Font sizes
  static const double fontSizeXSmall = 12;
  static const double fontSizeSmall = 14;
  static const double fontSizeMedium = 16;
  static const double fontSizeLarge = 18;
  static const double fontSizeXLarge = 20;
  static const double fontSizeXXLarge = 24;
  
  // Border radius
  static const double borderRadiusSmall = 4;
  static const double borderRadiusMedium = 8;
  static const double borderRadiusLarge = 12;
  static const double borderRadiusXLarge = 16;
  
  // Spacing
  static const double spacingXSmall = 4;
  static const double spacingSmall = 8;
  static const double spacingMedium = 16;
  static const double spacingLarge = 24;
  static const double spacingXLarge = 32;
  
  // Elevation
  static const double elevationSmall = 2;
  static const double elevationMedium = 4;
  static const double elevationLarge = 8;
  
  // Animation durations
  static const Duration animationShort = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationLong = Duration(milliseconds: 500);
  
  // Get light theme
  static ThemeData getLightTheme() {
    return ThemeData(
      primarySwatch: Colors.green,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        tertiary: mosque,
        background: lightBackground,
        surface: lightSurface,
        brightness: Brightness.light,
      ),
      fontFamily: primaryFont,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: lightTextPrimary),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: lightTextPrimary),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: lightTextPrimary),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: lightTextPrimary),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: lightTextPrimary),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: lightTextPrimary),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: lightTextPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: lightTextPrimary),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: lightTextPrimary),
        bodyLarge: TextStyle(fontSize: 16, color: lightTextPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: lightTextPrimary),
        bodySmall: TextStyle(fontSize: 12, color: lightTextSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: spacingMedium, vertical: spacingSmall),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: spacingMedium, vertical: spacingSmall),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: elevationLarge,
      ),
    );
  }
  
  // Get dark theme
  static ThemeData getDarkTheme() {
    return ThemeData(
      primarySwatch: Colors.green,
      primaryColor: primaryDarkColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDarkColor,
        primary: primaryDarkColor,
        secondary: accentColor,
        tertiary: mosque,
        background: darkBackground,
        surface: darkSurface,
        brightness: Brightness.dark,
      ),
      fontFamily: primaryFont,
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkSurface,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: darkTextPrimary),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkTextPrimary),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkTextPrimary),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: darkTextPrimary),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: darkTextPrimary),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: darkTextPrimary),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: darkTextPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: darkTextPrimary),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: darkTextPrimary),
        bodyLarge: TextStyle(fontSize: 16, color: darkTextPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: darkTextPrimary),
        bodySmall: TextStyle(fontSize: 12, color: darkTextSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDarkColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        color: darkSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDarkColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: spacingMedium, vertical: spacingSmall),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: primaryDarkColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: spacingMedium, vertical: spacingSmall),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: accentColor,
        unselectedItemColor: darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: elevationLarge,
      ),
    );
  }
}

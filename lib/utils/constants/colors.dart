import 'package:flutter/material.dart';

class TColors {
  TColors._();

  // App Basic Colors
  static const Color primaryColor = Color(0xFF7CB342);
  static const Color secondaryColor = Color(0xFF33691E);
  static const Color tertiaryColor = Color(0xFFF1F8E9);
  static const Color darkgrey =Color(0xfff212121);
  static const Color lightgrey =Color(0xFF3C3C3C);
  static const Color black = Color(0xfff212121);
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;

  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Dark grey for better readability
  static const Color textSecondary = Colors.white;
  static const Color textTertiary = Color(0xFF795548);
  static const Color textWhite = Colors.white;// Brown for tertiary text

  // Background Colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);
  static const Color lighttabbar = Color(0xFFF6F6F6);
  static const Color darktabbar = Color(0xFF272727);

  // Background Containers Colors
  static const Color containerLight = Color(0xFFFFFFFF); // White for light containers
  static const Color containerDark = Color(0xFF3C3C3C); // Dark grey for dark containers

  // Button Colors
  static const Color buttonPrimary = Color(0xFF7CB342);
  static const Color buttonSecondary = Color(0xFF33691E);
  static const Color buttonDisabled = Color(0xFFB0B0B0); // Grey for disabled buttons

  // Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF80AB), Color(0xFFC51162)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Gradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFFFF3E0), Color(0xFFFF80AB)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0); // Light grey for borders
  static const Color borderDark = Color(0xFF3C3C3C); // Dark grey for borders

  // Neutral Shades
  static const Color neutralLight = Color(0xFFF5F5F5); // Very light grey
  static const Color neutralMedium = Color(0xFFB0B0B0); // Medium grey
  static const Color neutralDark = Color(0xFF4A4A4A); // Dark grey

  // Error and Validation Colors
  static const Color errorColor = Color(0xFFD32F2F); // Red for errors
  static const Color validationColor = Color(0xFF4CAF50); // Green for validation
}









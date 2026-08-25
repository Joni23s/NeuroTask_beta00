import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class NeumorphicTheme {
  // Light Double Elevation Shadows
  static List<BoxShadow> get softElevation => [
    const BoxShadow(
      color: AppColors.shadowDark,
      offset: Offset(6, 6),
      blurRadius: 14,
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: AppColors.shadowLight,
      offset: Offset(-6, -6),
      blurRadius: 14,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get subtleElevation => [
    const BoxShadow(
      color: AppColors.shadowDark,
      offset: Offset(3, 3),
      blurRadius: 8,
    ),
    const BoxShadow(
      color: AppColors.shadowLight,
      offset: Offset(-3, -3),
      blurRadius: 8,
    ),
  ];

  static List<BoxShadow> get pressedElevation => [
    const BoxShadow(
      color: Color(0x66A6B2C4),
      offset: Offset(3, 3),
      blurRadius: 6,
    ),
    const BoxShadow(
      color: AppColors.shadowLight,
      offset: Offset(-3, -3),
      blurRadius: 6,
    ),
  ];

  // Dark Soft Slate Elevation Shadows
  static List<BoxShadow> get darkSoftElevation => [
    const BoxShadow(
      color: AppColors.darkShadowDark,
      offset: Offset(6, 6),
      blurRadius: 16,
    ),
    const BoxShadow(
      color: AppColors.darkShadowLight,
      offset: Offset(-4, -4),
      blurRadius: 12,
    ),
  ];

  static List<BoxShadow> get darkSubtleElevation => [
    const BoxShadow(
      color: AppColors.darkShadowDark,
      offset: Offset(3, 3),
      blurRadius: 8,
    ),
    const BoxShadow(
      color: AppColors.darkShadowLight,
      offset: Offset(-2, -2),
      blurRadius: 6,
    ),
  ];

  static List<BoxShadow> get darkPressedElevation => [
    const BoxShadow(
      color: Color(0xCC000000),
      offset: Offset(3, 3),
      blurRadius: 6,
    ),
    const BoxShadow(
      color: Color(0x0DFFFFFF),
      offset: Offset(-2, -2),
      blurRadius: 4,
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryIndigo,
        brightness: Brightness.light,
        surface: AppColors.cardSurface,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textMain),
        titleLarge: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textMain),
        titleMedium: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain),
        bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textMain),
        bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.textSecondary),
        bodySmall: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textMuted),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryIndigo,
        brightness: Brightness.dark,
        surface: AppColors.darkCardSurface,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.darkTextMain),
        titleLarge: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkTextMain),
        titleMedium: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkTextMain),
        bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.darkTextMain),
        bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.darkTextSecondary),
        bodySmall: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.darkTextMuted),
      ),
    );
  }
}

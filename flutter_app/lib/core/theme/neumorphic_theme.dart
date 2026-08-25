import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class NeumorphicTheme {
  // Soft Double Elevation Shadows
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

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryIndigo,
        surface: AppColors.cardSurface,
        background: AppColors.background,
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
}

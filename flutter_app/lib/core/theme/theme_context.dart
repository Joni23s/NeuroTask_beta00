import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'neumorphic_theme.dart';

extension ThemeContext on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get backgroundColor => isDarkMode ? AppColors.darkBackground : AppColors.background;
  Color get cardSurface => isDarkMode ? AppColors.darkCardSurface : AppColors.cardSurface;
  Color get pressedSurface => isDarkMode ? AppColors.darkPressedSurface : AppColors.pressedSurface;
  Color get textMain => isDarkMode ? AppColors.darkTextMain : AppColors.textMain;
  Color get textSecondary => isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary;
  Color get textMuted => isDarkMode ? AppColors.darkTextMuted : AppColors.textMuted;
  Color get borderLight => isDarkMode ? const Color(0x1AFFFFFF) : AppColors.borderLight;

  List<BoxShadow> get softElevation => isDarkMode ? NeumorphicTheme.darkSoftElevation : NeumorphicTheme.softElevation;
  List<BoxShadow> get subtleElevation => isDarkMode ? NeumorphicTheme.darkSubtleElevation : NeumorphicTheme.subtleElevation;
  List<BoxShadow> get pressedElevation => isDarkMode ? NeumorphicTheme.darkPressedElevation : NeumorphicTheme.pressedElevation;
}

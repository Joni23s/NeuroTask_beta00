import 'package:flutter/material.dart';

/// Design System Color Palette for NeuroTask
/// Supports Light Soft Paper and Dark Soft Slate themes
class AppColors {
  // Base Paper Surfaces (Light Mode)
  static const Color background = Color(0xFFF4F6F9); // Light Soft Paper
  static const Color cardSurface = Color(0xFFF4F6F9);
  static const Color pressedSurface = Color(0xFFE9EDF4);

  // Dark Soft Slate Surfaces (Dark Mode)
  static const Color darkBackground = Color(0xFF131822); // Deep calming slate
  static const Color darkCardSurface = Color(0xFF1C2331); // Elevated slate card
  static const Color darkPressedSurface = Color(0xFF161C28); // Inset slate

  // Brand Logo Colors (from NeuroTask_logo.jpg)
  static const Color brandDeepBlue = Color(0xFF2B5B84); // Isotype deep blue
  static const Color brandSteelBlue = Color(0xFF4A7D9D); // Subtitle steel blue
  static const Color brandGlowCyan = Color(0xFF38BDF8); // Illuminated target node glow
  static const Color brandGlowLight = Color(0xFFE0F2FE); // Soft cyan wash

  // Indigo Zen Focus Colors
  static const Color primaryIndigo = Color(0xFF4F46E5);
  static const Color primaryIndigoLight = Color(0xFF6366F1);
  static const Color indigoGlow = Color(0x406366F1);

  // Emerald Sage Success Colors (Tildes de avance)
  static const Color successEmerald = Color(0xFF10B981);
  static const Color successEmeraldDark = Color(0xFF059669);
  static const Color emeraldGlow = Color(0x4010B981);

  // Amber Gentle Warning (Rescate cognitivo)
  static const Color amberWarning = Color(0xFFF59E0B);
  static const Color amberLight = Color(0xFFFEF3C7);
  static const Color amberDark = Color(0xFFD97706);

  // Typography & Content (Light)
  static const Color textMain = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Typography & Content (Dark)
  static const Color darkTextMain = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Shadows (Light)
  static const Color shadowDark = Color(0x73A6B2C4); // rgba(166, 178, 196, 0.45)
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xB3FFFFFF); // 70% white

  // Shadows (Dark)
  static const Color darkShadowDark = Color(0x99000000); // 60% black
  static const Color darkShadowLight = Color(0x14FFFFFF); // 8% white edge highlight
}

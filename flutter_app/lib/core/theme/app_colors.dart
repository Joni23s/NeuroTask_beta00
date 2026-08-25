import 'package:flutter/material.dart';

/// Design System Color Palette for NeuroTask
/// Light Soft Paper / Sensory-Calming Palette aligned with official branding
class AppColors {
  // Base Paper Surfaces
  static const Color background = Color(0xFFF4F6F9); // Light Soft Paper
  static const Color cardSurface = Color(0xFFF4F6F9);
  static const Color pressedSurface = Color(0xFFE9EDF4);

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

  // Typography & Content
  static const Color textMain = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Shadows
  static const Color shadowDark = Color(0x73A6B2C4); // rgba(166, 178, 196, 0.45)
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xB3FFFFFF); // 70% white
}

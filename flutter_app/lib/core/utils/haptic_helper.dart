import 'package:flutter/services.dart';

class HapticHelper {
  static bool enabled = true;

  static void lightTap() {
    if (!enabled) return;
    HapticFeedback.lightImpact();
  }

  static void success() {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
  }

  static void mediumImpact() {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
  }

  static void selectionClick() {
    if (!enabled) return;
    HapticFeedback.selectionClick();
  }

  static void warning() {
    if (!enabled) return;
    HapticFeedback.heavyImpact();
  }
}

import 'package:flutter/services.dart';

class HapticHelper {
  static void lightTap() {
    HapticFeedback.lightImpact();
  }

  static void success() {
    HapticFeedback.mediumImpact();
  }

  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  static void warning() {
    HapticFeedback.heavyImpact();
  }
}

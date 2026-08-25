import 'package:flutter/services.dart';

class HapticHelper {
  static void lightTap() {
    HapticFeedback.lightImpact();
  }

  static void success() {
    HapticFeedback.mediumImpact();
  }

  static void warning() {
    HapticFeedback.heavyImpact();
  }
}

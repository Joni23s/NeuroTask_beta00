import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/haptic_helper.dart';

class SettingsState {
  final bool anchorNotifications;
  final bool autoBrownNoise;
  final bool hapticFeedback;
  final bool isLoaded;

  const SettingsState({
    this.anchorNotifications = true,
    this.autoBrownNoise = false,
    this.hapticFeedback = true,
    this.isLoaded = false,
  });

  SettingsState copyWith({
    bool? anchorNotifications,
    bool? autoBrownNoise,
    bool? hapticFeedback,
    bool? isLoaded,
  }) {
    return SettingsState(
      anchorNotifications: anchorNotifications ?? this.anchorNotifications,
      autoBrownNoise: autoBrownNoise ?? this.autoBrownNoise,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  static const String _keyAnchorNotifications =
      'neurotask_settings_anchor_alerts_v1';
  static const String _keyAutoBrownNoise =
      'neurotask_settings_auto_brown_noise_v1';
  static const String _keyHapticFeedback =
      'neurotask_settings_haptic_feedback_v1';

  @override
  SettingsState build() {
    Future.microtask(() => loadSettings());
    return const SettingsState();
  }

  /// Carga las preferencias guardadas desde SharedPreferences.
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final anchorAlerts = prefs.getBool(_keyAnchorNotifications) ?? true;
      final autoNoise = prefs.getBool(_keyAutoBrownNoise) ?? false;
      final haptic = prefs.getBool(_keyHapticFeedback) ?? true;

      HapticHelper.enabled = haptic;

      state = SettingsState(
        anchorNotifications: anchorAlerts,
        autoBrownNoise: autoNoise,
        hapticFeedback: haptic,
        isLoaded: true,
      );
    } catch (_) {
      state = state.copyWith(isLoaded: true);
    }
  }

  /// Activa o desactiva las alertas visuales de anclas horarias.
  Future<void> toggleAnchorNotifications(bool val) async {
    HapticHelper.lightTap();
    state = state.copyWith(anchorNotifications: val, isLoaded: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyAnchorNotifications, val);
    } catch (_) {}
  }

  /// Activa o desactiva el inicio automático de ruido marrón en foco.
  Future<void> toggleAutoBrownNoise(bool val) async {
    HapticHelper.lightTap();
    state = state.copyWith(autoBrownNoise: val, isLoaded: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyAutoBrownNoise, val);
    } catch (_) {}
  }

  /// Activa o desactiva globalmente la retroalimentación háptica.
  Future<void> toggleHapticFeedback(bool val) async {
    HapticHelper.enabled = val;
    if (val) {
      HapticHelper.lightTap();
    }
    state = state.copyWith(hapticFeedback: val, isLoaded: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyHapticFeedback, val);
    } catch (_) {}
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);

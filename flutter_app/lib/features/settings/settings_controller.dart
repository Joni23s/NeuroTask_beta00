import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/haptic_helper.dart';

class SettingsState {
  final bool anchorNotifications;
  final bool autoBrownNoise;
  final bool hapticFeedback;
  final bool useAiDecompression;
  final String geminiApiKey;
  final bool isLoaded;

  const SettingsState({
    this.anchorNotifications = true,
    this.autoBrownNoise = false,
    this.hapticFeedback = true,
    this.useAiDecompression = true,
    this.geminiApiKey = '',
    this.isLoaded = false,
  });

  bool get hasGeminiApiKey => geminiApiKey.trim().isNotEmpty;
  bool get isAiActive => useAiDecompression && hasGeminiApiKey;

  SettingsState copyWith({
    bool? anchorNotifications,
    bool? autoBrownNoise,
    bool? hapticFeedback,
    bool? useAiDecompression,
    String? geminiApiKey,
    bool? isLoaded,
  }) {
    return SettingsState(
      anchorNotifications: anchorNotifications ?? this.anchorNotifications,
      autoBrownNoise: autoBrownNoise ?? this.autoBrownNoise,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      useAiDecompression: useAiDecompression ?? this.useAiDecompression,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
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
  static const String _keyUseAiDecompression =
      'neurotask_settings_use_ai_v1';
  static const String _keyGeminiApiKey =
      'neurotask_settings_gemini_api_key_v1';

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
      final useAi = prefs.getBool(_keyUseAiDecompression) ?? true;
      final apiKey = prefs.getString(_keyGeminiApiKey) ?? '';

      HapticHelper.enabled = haptic;

      state = SettingsState(
        anchorNotifications: anchorAlerts,
        autoBrownNoise: autoNoise,
        hapticFeedback: haptic,
        useAiDecompression: useAi,
        geminiApiKey: apiKey,
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

  /// Activa o desactiva la descompresión asistida con Gemini API cuando hay clave.
  Future<void> toggleUseAiDecompression(bool val) async {
    HapticHelper.lightTap();
    state = state.copyWith(useAiDecompression: val, isLoaded: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyUseAiDecompression, val);
    } catch (_) {}
  }

  /// Guarda o elimina la API key opcional de Google Gemini en SharedPreferences.
  Future<void> setGeminiApiKey(String key) async {
    final trimmed = key.trim();
    HapticHelper.lightTap();
    state = state.copyWith(geminiApiKey: trimmed, isLoaded: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      if (trimmed.isEmpty) {
        await prefs.remove(_keyGeminiApiKey);
      } else {
        await prefs.setString(_keyGeminiApiKey, trimmed);
      }
    } catch (_) {}
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);

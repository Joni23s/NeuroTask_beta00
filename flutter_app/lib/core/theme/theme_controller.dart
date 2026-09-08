import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/haptic_helper.dart';

class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({this.themeMode = ThemeMode.light});

  bool get isDarkMode => themeMode == ThemeMode.dark;

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class ThemeNotifier extends Notifier<ThemeState> {
  static const String _keyThemeMode = 'neurotask_theme_mode_v1';

  @override
  ThemeState build() {
    Future.microtask(() => _loadTheme());
    return const ThemeState();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_keyThemeMode);
      if (isDark != null) {
        state = ThemeState(themeMode: isDark ? ThemeMode.dark : ThemeMode.light);
      }
    } catch (_) {
      // Graceful fallback to default light theme
    }
  }

  Future<void> toggleTheme() async {
    HapticHelper.lightTap();
    final newMode = state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    state = state.copyWith(themeMode: newMode);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyThemeMode, state.isDarkMode);
    } catch (_) {
      // Ignored
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);

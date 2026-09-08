import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/time_anchor.dart';

class AnchorsStorageService {
  static const String _keyAnchors = 'neurotask_user_anchors_v1';

  /// Carga las anclas guardadas localmente. Si es la primera vez, devuelve los presets predeterminados.
  static Future<List<TimeAnchor>> loadAnchors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_keyAnchors);
      if (raw == null || raw.trim().isEmpty) {
        final defaults = TimeAnchor.initialPresets();
        await saveAnchors(defaults);
        return defaults;
      }

      final list = jsonDecode(raw) as List<dynamic>;
      final anchors = list.map((item) => TimeAnchor.fromJson(item as Map<String, dynamic>)).toList();
      return anchors;
    } catch (_) {
      return TimeAnchor.initialPresets();
    }
  }

  /// Guarda la lista completa de anclas
  static Future<void> saveAnchors(List<TimeAnchor> anchors) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = anchors.map((a) => a.toJson()).toList();
      await prefs.setString(_keyAnchors, jsonEncode(list));
    } catch (_) {
      // Ignored
    }
  }

  /// Restaura los presets predeterminados de la vida universitaria
  static Future<List<TimeAnchor>> resetToDefaults() async {
    final defaults = TimeAnchor.initialPresets();
    await saveAnchors(defaults);
    return defaults;
  }
}

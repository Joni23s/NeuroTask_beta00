import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementsStorageService {
  static const String _keyAchievements = 'neurotask_unlocked_achievements_v1';
  static const String _keyTotalCompletedFlows = 'neurotask_total_completed_flows_v1';

  /// Saves the map of unlocked achievement IDs with their unlock timestamp
  static Future<void> saveUnlockedAchievements(Map<String, String> unlockedMap) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyAchievements, jsonEncode(unlockedMap));
    } catch (_) {}
  }

  /// Loads the map of unlocked achievement IDs
  static Future<Map<String, String>> loadUnlockedAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_keyAchievements);
      if (raw == null || raw.isEmpty) return {};

      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  /// Increments and returns the count of fully completed focus flows
  static Future<int> incrementCompletedFlows() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final count = (prefs.getInt(_keyTotalCompletedFlows) ?? 0) + 1;
      await prefs.setInt(_keyTotalCompletedFlows, count);
      return count;
    } catch (_) {
      return 1;
    }
  }

  /// Gets the count of fully completed focus flows
  static Future<int> getCompletedFlowsCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyTotalCompletedFlows) ?? 0;
    } catch (_) {
      return 0;
    }
  }
}

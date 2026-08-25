import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/focus_viewport/controllers/focus_controller.dart';
import '../../features/graph_engine/models/task_graph.dart';
import '../../features/graph_engine/models/task_node.dart';

class SessionStorageService {
  static const String _keySession = 'neurotask_focus_session_v1';

  /// Saves the current FocusState to local device storage
  static Future<void> saveSession(FocusState state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (state.isCompletedAll) {
        await prefs.remove(_keySession);
        return;
      }

      final data = {
        'graph': state.graph.toJson(),
        'executionQueue': state.executionQueue.map((n) => n.toJson()).toList(),
        'currentIndex': state.currentIndex,
        'isLowEnergyMode': state.isLowEnergyMode,
        'isCompletedAll': state.isCompletedAll,
        'sessionStartTime': state.sessionStartTime?.toIso8601String(),
        'elapsedSeconds': state.elapsedSeconds,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await prefs.setString(_keySession, jsonEncode(data));
    } catch (_) {
      // Gracefully handle storage errors without crashing the app
    }
  }

  /// Restores saved session from storage if it exists and is valid
  static Future<FocusState?> loadSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_keySession);
      if (raw == null || raw.isEmpty) return null;

      final data = jsonDecode(raw) as Map<String, dynamic>;
      final graph = TaskGraph.fromJson(data['graph'] as Map<String, dynamic>);
      final queue = (data['executionQueue'] as List<dynamic>)
          .map((n) => TaskNode.fromJson(n as Map<String, dynamic>))
          .toList();
      final currentIndex = (data['currentIndex'] as num?)?.toInt() ?? 0;
      final isLowEnergy = data['isLowEnergyMode'] as bool? ?? false;
      final isCompletedAll = data['isCompletedAll'] as bool? ?? false;
      final sessionStartStr = data['sessionStartTime'] as String?;
      final sessionStartTime = sessionStartStr != null ? DateTime.tryParse(sessionStartStr) : null;
      final elapsedSeconds = (data['elapsedSeconds'] as num?)?.toInt() ?? 0;

      if (queue.isEmpty || isCompletedAll) return null;

      return FocusState(
        graph: graph,
        executionQueue: queue,
        currentIndex: currentIndex,
        isLowEnergyMode: isLowEnergy,
        isCompletedAll: isCompletedAll,
        sessionStartTime: sessionStartTime,
        elapsedSeconds: elapsedSeconds,
      );
    } catch (_) {
      return null;
    }
  }

  /// Clears stored session
  static Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keySession);
    } catch (_) {
      // Ignored
    }
  }
}

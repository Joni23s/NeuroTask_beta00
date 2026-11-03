import 'task_graph.dart';
import 'task_node.dart';

/// Estado de una sesión de foco en NeuroTask.
/// Pertenece a la capa de dominio/modelos, permitiendo desacoplar los servicios
/// de almacenamiento (core/services) de los controladores visuales (features/focus).
class FocusState {
  final TaskGraph graph;
  final List<TaskNode> executionQueue;
  final int currentIndex;
  final bool isLowEnergyMode;
  final bool isCompletedAll;
  final bool isRestoredFromStorage;
  final DateTime? sessionStartTime;
  final int elapsedSeconds;

  const FocusState({
    required this.graph,
    required this.executionQueue,
    this.currentIndex = 0,
    this.isLowEnergyMode = false,
    this.isCompletedAll = false,
    this.isRestoredFromStorage = false,
    this.sessionStartTime,
    this.elapsedSeconds = 0,
  });

  TaskNode? get currentTask {
    if (currentIndex >= 0 && currentIndex < executionQueue.length) {
      return executionQueue[currentIndex];
    }
    return null;
  }

  int get totalSteps => executionQueue.length;
  int get currentStepNumber => currentIndex + 1;
  bool get hasActiveSession => executionQueue.isNotEmpty && !isCompletedAll;

  int get totalEstimatedMinutes =>
      executionQueue.fold<int>(0, (sum, item) => sum + item.estimatedMinutes);

  String get formattedRealTime {
    final mins = elapsedSeconds ~/ 60;
    final secs = elapsedSeconds % 60;
    if (mins == 0) {
      return '${secs > 0 ? secs : 1}s';
    } else if (secs == 0) {
      return '${mins}m';
    } else {
      return '${mins}m ${secs}s';
    }
  }

  FocusState copyWith({
    TaskGraph? graph,
    List<TaskNode>? executionQueue,
    int? currentIndex,
    bool? isLowEnergyMode,
    bool? isCompletedAll,
    bool? isRestoredFromStorage,
    DateTime? sessionStartTime,
    int? elapsedSeconds,
  }) {
    return FocusState(
      graph: graph ?? this.graph,
      executionQueue: executionQueue ?? this.executionQueue,
      currentIndex: currentIndex ?? this.currentIndex,
      isLowEnergyMode: isLowEnergyMode ?? this.isLowEnergyMode,
      isCompletedAll: isCompletedAll ?? this.isCompletedAll,
      isRestoredFromStorage: isRestoredFromStorage ?? this.isRestoredFromStorage,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }

  /// Serialización relacional a Map
  Map<String, dynamic> toMap() {
    return {
      'graph': graph.toJson(),
      'executionQueue': executionQueue.map((n) => n.toJson()).toList(),
      'currentIndex': currentIndex,
      'isLowEnergyMode': isLowEnergyMode,
      'isCompletedAll': isCompletedAll,
      'sessionStartTime': sessionStartTime?.toIso8601String(),
      'elapsedSeconds': elapsedSeconds,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Deserialización fromObject
  factory FocusState.fromObject(dynamic o) {
    if (o is Map<String, dynamic>) {
      final graph = TaskGraph.fromJson(o['graph'] as Map<String, dynamic>);
      final queue = (o['executionQueue'] as List<dynamic>)
          .map((n) => TaskNode.fromJson(n as Map<String, dynamic>))
          .toList();
      final currentIndex = (o['currentIndex'] as num?)?.toInt() ?? 0;
      final isLowEnergy = o['isLowEnergyMode'] as bool? ?? false;
      final isCompletedAll = o['isCompletedAll'] as bool? ?? false;
      final sessionStartStr = o['sessionStartTime'] as String?;
      final sessionStartTime =
          sessionStartStr != null ? DateTime.tryParse(sessionStartStr) : null;
      final elapsedSeconds = (o['elapsedSeconds'] as num?)?.toInt() ?? 0;

      return FocusState(
        graph: graph,
        executionQueue: queue,
        currentIndex: currentIndex,
        isLowEnergyMode: isLowEnergy,
        isCompletedAll: isCompletedAll,
        sessionStartTime: sessionStartTime,
        elapsedSeconds: elapsedSeconds,
      );
    } else if (o is Map) {
      return FocusState.fromObject(Map<String, dynamic>.from(o));
    }
    throw ArgumentError('El objeto debe ser un Map');
  }
}


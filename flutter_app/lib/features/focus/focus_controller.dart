import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/models/task_graph.dart';
import '../../core/domain/models/task_node.dart';
import '../../core/domain/models/time_anchor.dart';
import '../../core/domain/services/anchor_schedule_fitter.dart';
import '../../core/domain/services/topological_sorter.dart';
import '../../core/services/session_storage_service.dart';

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
}

class FocusNotifier extends Notifier<FocusState> {
  @override
  FocusState build() {
    Future.microtask(() => restoreFromStorage());
    return _initialState();
  }

  static FocusState _initialState() {
    final graph = TopologicalSorter.defaultSampleGraph();
    final sorted = TopologicalSorter.sort(graph);
    final fit = AnchorScheduleFitter.fitTasks(
      tasks: sorted,
      anchors: TimeAnchor.initialPresets(),
    );
    return FocusState(
      graph: graph,
      executionQueue: fit.scheduledTasks,
      currentIndex: 0,
      sessionStartTime: DateTime.now(),
      elapsedSeconds: 0,
    );
  }

  Future<void> restoreFromStorage() async {
    final saved = await SessionStorageService.loadSavedSession();
    if (saved != null) {
      state = saved.copyWith(isRestoredFromStorage: true);
    }
  }

  void loadFromRawText(String text) {
    final graph = TopologicalSorter.parseRawText(text);
    final sorted = TopologicalSorter.sort(graph);
    final fit = AnchorScheduleFitter.fitTasks(
      tasks: sorted,
      anchors: TimeAnchor.initialPresets(),
    );
    state = FocusState(
      graph: graph,
      executionQueue: fit.scheduledTasks,
      currentIndex: 0,
      isLowEnergyMode: false,
      isCompletedAll: false,
      isRestoredFromStorage: false,
      sessionStartTime: DateTime.now(),
      elapsedSeconds: 0,
    );
    SessionStorageService.saveSession(state);
  }

  void applyAnchorSchedule(List<TimeAnchor> anchors) {
    final fit = AnchorScheduleFitter.fitTasks(
      tasks: state.executionQueue,
      anchors: anchors,
    );
    state = state.copyWith(executionQueue: fit.scheduledTasks);
    SessionStorageService.saveSession(state);
  }

  void updateElapsedSeconds(int seconds) {
    state = state.copyWith(elapsedSeconds: seconds);
  }

  void completeCurrentTask() {
    int currentElapsed = state.elapsedSeconds;
    if (state.sessionStartTime != null) {
      final diff = DateTime.now().difference(state.sessionStartTime!).inSeconds;
      if (diff > currentElapsed) {
        currentElapsed = diff;
      }
    }

    if (state.currentIndex < state.executionQueue.length - 1) {
      // Mark current completed
      final updatedQueue = List<TaskNode>.from(state.executionQueue);
      updatedQueue[state.currentIndex] = updatedQueue[state.currentIndex].copyWith(isCompleted: true);

      state = state.copyWith(
        executionQueue: updatedQueue,
        currentIndex: state.currentIndex + 1,
        elapsedSeconds: currentElapsed,
      );
    } else {
      final updatedQueue = List<TaskNode>.from(state.executionQueue);
      if (updatedQueue.isNotEmpty) {
        updatedQueue[state.currentIndex] = updatedQueue[state.currentIndex].copyWith(isCompleted: true);
      }
      state = state.copyWith(
        executionQueue: updatedQueue,
        isCompletedAll: true,
        elapsedSeconds: currentElapsed > 0 ? currentElapsed : 1,
      );
    }
    SessionStorageService.saveSession(state);
  }

  void splitCurrentTask() {
    final current = state.currentTask;
    if (current == null) return;

    final micro1 = TaskNode(
      id: '${current.id}_micro1',
      title: 'Paso Inicial (3 min): Preparar el espacio y abrir archivos para "${current.title}"',
      category: 'Desbloqueo Inmediato',
      subtext: 'Micro-acción sin fricción: solo tené listos los programas necesarios.',
      estimatedMinutes: 3,
      energyLevel: EnergyLevel.low,
      isAtomicSubstep: true,
    );

    final micro2 = TaskNode(
      id: '${current.id}_micro2',
      title: 'Paso de Acción (5 min): Realizar el primer borrador / prueba',
      category: current.category,
      subtext: 'Continuación enfocada del paso.',
      estimatedMinutes: 5,
      energyLevel: EnergyLevel.medium,
      isAtomicSubstep: true,
    );

    final updatedQueue = List<TaskNode>.from(state.executionQueue);
    updatedQueue.removeAt(state.currentIndex);
    updatedQueue.insert(state.currentIndex, micro2);
    updatedQueue.insert(state.currentIndex, micro1);

    state = state.copyWith(
      executionQueue: updatedQueue,
    );
    SessionStorageService.saveSession(state);
  }

  void activateLowEnergyMode() {
    final remaining = state.executionQueue.sublist(state.currentIndex);
    remaining.sort((a, b) => a.energyLevel.index.compareTo(b.energyLevel.index));

    final newQueue = [
      ...state.executionQueue.sublist(0, state.currentIndex),
      ...remaining,
    ];

    state = state.copyWith(
      executionQueue: newQueue,
      isLowEnergyMode: true,
    );
    SessionStorageService.saveSession(state);
  }

  void reset() {
    SessionStorageService.clearSession();
    state = _initialState();
  }
}

final focusProvider = NotifierProvider<FocusNotifier, FocusState>(
  FocusNotifier.new,
);

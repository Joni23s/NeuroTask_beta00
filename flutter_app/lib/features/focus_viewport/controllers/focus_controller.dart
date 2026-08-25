import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../graph_engine/models/task_graph.dart';
import '../../graph_engine/models/task_node.dart';
import '../../graph_engine/services/topological_sorter.dart';

class FocusState {
  final TaskGraph graph;
  final List<TaskNode> executionQueue;
  final int currentIndex;
  final bool isLowEnergyMode;
  final bool isCompletedAll;

  const FocusState({
    required this.graph,
    required this.executionQueue,
    this.currentIndex = 0,
    this.isLowEnergyMode = false,
    this.isCompletedAll = false,
  });

  TaskNode? get currentTask {
    if (currentIndex >= 0 && currentIndex < executionQueue.length) {
      return executionQueue[currentIndex];
    }
    return null;
  }

  int get totalSteps => executionQueue.length;
  int get currentStepNumber => currentIndex + 1;

  FocusState copyWith({
    TaskGraph? graph,
    List<TaskNode>? executionQueue,
    int? currentIndex,
    bool? isLowEnergyMode,
    bool? isCompletedAll,
  }) {
    return FocusState(
      graph: graph ?? this.graph,
      executionQueue: executionQueue ?? this.executionQueue,
      currentIndex: currentIndex ?? this.currentIndex,
      isLowEnergyMode: isLowEnergyMode ?? this.isLowEnergyMode,
      isCompletedAll: isCompletedAll ?? this.isCompletedAll,
    );
  }
}

class FocusNotifier extends StateNotifier<FocusState> {
  FocusNotifier() : super(_initialState());

  static FocusState _initialState() {
    final graph = TopologicalSorter.defaultSampleGraph();
    final sorted = TopologicalSorter.sort(graph);
    return FocusState(
      graph: graph,
      executionQueue: sorted,
      currentIndex: 0,
    );
  }

  void loadFromRawText(String text) {
    final graph = TopologicalSorter.parseRawText(text);
    final sorted = TopologicalSorter.sort(graph);
    state = FocusState(
      graph: graph,
      executionQueue: sorted,
      currentIndex: 0,
      isLowEnergyMode: false,
      isCompletedAll: false,
    );
  }

  void completeCurrentTask() {
    if (state.currentIndex < state.executionQueue.length - 1) {
      // Mark current completed
      final updatedQueue = List<TaskNode>.from(state.executionQueue);
      updatedQueue[state.currentIndex] = updatedQueue[state.currentIndex].copyWith(isCompleted: true);

      state = state.copyWith(
        executionQueue: updatedQueue,
        currentIndex: state.currentIndex + 1,
      );
    } else {
      final updatedQueue = List<TaskNode>.from(state.executionQueue);
      if (updatedQueue.isNotEmpty) {
        updatedQueue[state.currentIndex] = updatedQueue[state.currentIndex].copyWith(isCompleted: true);
      }
      state = state.copyWith(
        executionQueue: updatedQueue,
        isCompletedAll: true,
      );
    }
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
  }

  void reset() {
    state = _initialState();
  }
}

final focusProvider = StateNotifierProvider<FocusNotifier, FocusState>((ref) {
  return FocusNotifier();
});

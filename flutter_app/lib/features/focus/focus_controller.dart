import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/models/focus_state.dart';
import '../../core/domain/models/task_graph.dart';
import '../../core/domain/models/task_node.dart';
import '../../core/domain/models/time_anchor.dart';
import '../../core/domain/services/anchor_schedule_fitter.dart';
import '../../core/domain/services/topological_sorter.dart';
import '../../data/repositories/providers.dart';

export '../../core/domain/models/focus_state.dart';

/// Controlador del Flujo de Foco y Ejecución Paso a Paso (Capa de Lógica/Estado).
///
/// Consume datos puramente a través de los Repositorios de datos dinámicos
/// ([TaskRepository], [AnchorRepository], [UserRepository], [AchievementRepository]),
/// desacoplando la persistencia de las vistas visuales y cumpliendo el Tema 1 (DAM).
class FocusNotifier extends Notifier<FocusState> {
  @override
  FocusState build() {
    // Estado inicial seguro mientras se resuelven las promesas asíncronas de la capa de datos
    Future.microtask(() => restoreOrLoadFromRepository());
    return const FocusState(
      graph: TaskGraph(),
      executionQueue: [],
      currentIndex: 0,
      elapsedSeconds: 0,
    );
  }

  /// Carga la sesión desde la persistencia o consulta el grafo inicial del TaskRepository
  Future<void> restoreOrLoadFromRepository() async {
    final taskRepo = ref.read(taskRepositoryProvider);
    final anchorRepo = ref.read(anchorRepositoryProvider);

    // 1. Intentar restaurar sesión activa guardada
    final saved = await taskRepo.restoreActiveSession();
    if (saved != null && saved.executionQueue.isNotEmpty && !saved.isCompletedAll) {
      state = saved.copyWith(isRestoredFromStorage: true);
      return;
    }

    // 2. Si no hay sesión previa, cargar el grafo de tareas inicial dinámico desde el repositorio
    final graph = await taskRepo.getInitialTaskGraph();
    final sorted = TopologicalSorter.sort(graph);
    final anchors = await anchorRepo.getAllAnchors();
    final fit = AnchorScheduleFitter.fitTasks(
      tasks: sorted,
      anchors: anchors,
    );

    state = FocusState(
      graph: graph,
      executionQueue: fit.scheduledTasks,
      currentIndex: 0,
      sessionStartTime: DateTime.now(),
      elapsedSeconds: 0,
    );
  }

  /// Procesa texto libre de volcado mental mediante el repositorio y construye el camino crítico
  Future<void> loadFromRawText(String text) async {
    final taskRepo = ref.read(taskRepositoryProvider);
    final anchorRepo = ref.read(anchorRepositoryProvider);

    final graph = await taskRepo.parseAndStoreBrainDump(text);
    final sorted = TopologicalSorter.sort(graph);
    final anchors = await anchorRepo.getAllAnchors();
    final fit = AnchorScheduleFitter.fitTasks(
      tasks: sorted,
      anchors: anchors,
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

    await taskRepo.saveActiveSession(state);
  }

  /// Aplica una nueva configuración de anclas horarias al cronograma actual
  Future<void> applyAnchorSchedule(List<TimeAnchor> anchors) async {
    final taskRepo = ref.read(taskRepositoryProvider);
    final fit = AnchorScheduleFitter.fitTasks(
      tasks: state.executionQueue,
      anchors: anchors,
    );
    state = state.copyWith(executionQueue: fit.scheduledTasks);
    await taskRepo.saveActiveSession(state);
  }

  void updateElapsedSeconds(int seconds) {
    state = state.copyWith(elapsedSeconds: seconds);
  }

  /// Marca la tarea actual como completada, avanzando el puntero de foco
  /// y registrando el impacto en las métricas del [UserRepository] y [AchievementRepository].
  Future<void> completeCurrentTask() async {
    final taskRepo = ref.read(taskRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);
    final achievementRepo = ref.read(achievementRepositoryProvider);

    int currentElapsed = state.elapsedSeconds;
    if (state.sessionStartTime != null) {
      final diff = DateTime.now().difference(state.sessionStartTime!).inSeconds;
      if (diff > currentElapsed) {
        currentElapsed = diff;
      }
    }

    final currentTask = state.currentTask;
    final taskMinutes = currentTask?.estimatedMinutes ?? 15;

    // Actualizar métricas dinámicas del perfil de usuario en el UserRepository
    await userRepo.recordTaskCompletion(minutes: taskMinutes);

    if (state.currentIndex < state.executionQueue.length - 1) {
      // Marcar actual completada y avanzar
      final updatedQueue = List<TaskNode>.from(state.executionQueue);
      updatedQueue[state.currentIndex] =
          updatedQueue[state.currentIndex].copyWith(isCompleted: true);

      state = state.copyWith(
        executionQueue: updatedQueue,
        currentIndex: state.currentIndex + 1,
        elapsedSeconds: currentElapsed,
      );
    } else {
      // Flujo completado en su totalidad
      final updatedQueue = List<TaskNode>.from(state.executionQueue);
      if (updatedQueue.isNotEmpty) {
        updatedQueue[state.currentIndex] =
            updatedQueue[state.currentIndex].copyWith(isCompleted: true);
      }
      state = state.copyWith(
        executionQueue: updatedQueue,
        isCompletedAll: true,
        elapsedSeconds: currentElapsed > 0 ? currentElapsed : 1,
      );

      // Registrar finalización en logros
      await achievementRepo.recordFlowCompleted();
    }

    await taskRepo.saveActiveSession(state);
  }

  /// Rescate cognitivo: Divide la tarea actual en 2 micro-pasos inmediatos sin fricción
  Future<void> splitCurrentTask() async {
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

    await ref.read(taskRepositoryProvider).saveActiveSession(state);
  }

  /// Reorganiza la cola de ejecución priorizando tareas de baja energía
  Future<void> activateLowEnergyMode() async {
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

    await ref.read(taskRepositoryProvider).saveActiveSession(state);
  }

  /// Resetea la sesión actual y restaura los datos iniciales del repositorio
  Future<void> reset() async {
    final taskRepo = ref.read(taskRepositoryProvider);
    await taskRepo.clearActiveSession();
    await restoreOrLoadFromRepository();
  }
}

final focusProvider = NotifierProvider<FocusNotifier, FocusState>(
  FocusNotifier.new,
);

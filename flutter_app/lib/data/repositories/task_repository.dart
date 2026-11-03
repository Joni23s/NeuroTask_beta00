import 'dart:async';
import '../../core/domain/models/focus_state.dart';
import '../../core/domain/models/task_graph.dart';
import '../../core/domain/models/task_node.dart';
import '../../core/domain/services/topological_sorter.dart';
import '../../core/services/session_storage_service.dart';

/// Repositorio de Tareas y Grafos de Ejecución (Capa de Datos).
///
/// Implementa el patrón Repository para desacoplar completamente la UI
/// y los controladores de la persistencia y origen de datos (Mocks, DB local o API).
/// Cumple con los lineamientos de la Unidad 3.1.1 de la cátedra DAM (Tema 1).
class TaskRepository {
  // Simulación de origen de datos remoto / base de datos local con latencia asíncrona
  static final List<Map<String, dynamic>> _mockTasksTable = [
    {
      'id': 'n1',
      'title': 'Testear los endpoints en Postman y verificar respuestas JSON',
      'category': 'Backend & Integración',
      'subtext': 'Paso 1 del camino crítico. Sin dependencias activas.',
      'estimatedMinutes': 15,
      'energyLevel': 1, // EnergyLevel.medium
      'dependencies': <String>[],
      'isCompleted': false,
      'isAtomicSubstep': false,
    },
    {
      'id': 'n2',
      'title': 'Redactar el resumen ejecutivo de 2 párrafos para el informe',
      'category': 'Documentación',
      'subtext': 'Desbloqueado tras validar los endpoints.',
      'estimatedMinutes': 20,
      'energyLevel': 2, // EnergyLevel.high
      'dependencies': ['n1'],
      'isCompleted': false,
      'isAtomicSubstep': false,
    },
    {
      'id': 'n3',
      'title': 'Armar las 7 diapositivas visuales del Slide Deck en Figma',
      'category': 'Presentación Final',
      'subtext': 'Último nodo del grafo. Listo para la entrega de cátedra.',
      'estimatedMinutes': 15,
      'energyLevel': 0, // EnergyLevel.low
      'dependencies': ['n2'],
      'isCompleted': false,
      'isAtomicSubstep': false,
    },
    {
      'id': 'n4',
      'title': 'Configurar variables de entorno y perfiles de despliegue',
      'category': 'DevOps & Cloud',
      'subtext': 'Asegurar consistencia entre desarrollo y producción.',
      'estimatedMinutes': 10,
      'energyLevel': 1,
      'dependencies': ['n1'],
      'isCompleted': false,
      'isAtomicSubstep': false,
    },
    {
      'id': 'n5',
      'title': 'Ensayo general de la defensa oral con temporizador en vivo',
      'category': 'Defensa Cátedra',
      'subtext': 'Verificar sincronización entre oradores y diapositivas.',
      'estimatedMinutes': 25,
      'energyLevel': 2,
      'dependencies': ['n3'],
      'isCompleted': false,
      'isAtomicSubstep': false,
    },
  ];

  // Presets de volcado mental (movidos desde los controladores a la capa de datos)
  static const Map<String, String> _brainDumpPresets = {
    'dam':
        'Testear los endpoints del backend en Postman, redactar el resumen ejecutivo de 2 párrafos para el informe y armar las 7 diapositivas visuales en Figma para la entrega de ITU.',
    'flutter':
        'Definir los tokens de color Soft Paper en Dart, armar la NeumorphicCard reutilizable y programar la pantalla de foco 1 a 1 con Riverpod.',
    'examen':
        'Repasar conceptos teóricos de arquitectura por capas, resolver 3 ejercicios prácticos de Dart y armar el mapa conceptual para el coloquio.',
  };

  /// Obtiene los presets disponibles de volcado mental
  Future<Map<String, String>> getBrainDumpPresets() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return Map.unmodifiable(_brainDumpPresets);
  }

  /// Obtiene el texto de un preset por su clave
  Future<String?> getPresetText(String key) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _brainDumpPresets[key];
  }

  /// Retorna la lista completa de tareas desde el origen de datos
  Future<List<TaskNode>> getAllTasks() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockTasksTable.map((row) => TaskNode.fromObject(row)).toList();
  }

  /// Obtiene el grafo inicial de tareas para la sesión de foco
  Future<TaskGraph> getInitialTaskGraph() async {
    await Future.delayed(const Duration(milliseconds: 250));
    final tasks = await getAllTasks();

    // Solo tomamos las primeras 3 para el camino crítico inicial
    final initialNodes = tasks.take(3).toList();
    final edges = [
      const TaskEdge(fromId: 'n1', toId: 'n2'),
      const TaskEdge(fromId: 'n1', toId: 'n3'),
    ];

    return TaskGraph(nodes: initialNodes, edges: edges);
  }

  /// Transforma texto sin procesar en un grafo tipado y lo almacena
  Future<TaskGraph> parseAndStoreBrainDump(String rawText) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final graph = TopologicalSorter.parseRawText(rawText);

    // Guardar los nodos en la tabla mock para que estén disponibles
    for (final node in graph.nodes) {
      final exists = _mockTasksTable.any((row) => row['id'] == node.id);
      if (!exists) {
        _mockTasksTable.add(node.toMap());
      }
    }

    return graph;
  }

  /// Inserta una nueva tarea en el repositorio
  Future<int> insertTask(TaskNode task) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _mockTasksTable.removeWhere((row) => row['id'] == task.id);
    _mockTasksTable.add(task.toMap());
    return 1;
  }

  /// Actualiza una tarea existente
  Future<int> updateTask(TaskNode task) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _mockTasksTable.indexWhere((row) => row['id'] == task.id);
    if (index == -1) return 0;
    _mockTasksTable[index] = task.toMap();
    return 1;
  }

  /// Elimina una tarea por ID
  Future<int> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final initialLen = _mockTasksTable.length;
    _mockTasksTable.removeWhere((row) => row['id'] == id);
    return (_mockTasksTable.length < initialLen) ? 1 : 0;
  }

  /// Guarda la sesión activa en el motor de persistencia
  Future<void> saveActiveSession(FocusState state) async {
    await SessionStorageService.saveSession(state);
  }

  /// Carga la sesión guardada desde persistencia
  Future<FocusState?> restoreActiveSession() async {
    return SessionStorageService.loadSavedSession();
  }

  /// Limpia la sesión almacenada
  Future<void> clearActiveSession() async {
    await SessionStorageService.clearSession();
  }
}


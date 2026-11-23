import '../models/task_graph.dart';
import '../models/task_node.dart';
import 'cognitive_decompression_engine.dart';

class TopologicalSorter {
  /// Resolves execution order using Kahn's Algorithm on Directed Acyclic Graph
  static List<TaskNode> sort(TaskGraph graph) {
    final Map<String, int> inDegree = {};
    final Map<String, List<String>> adj = {};
    final Map<String, TaskNode> nodeMap = {for (var n in graph.nodes) n.id: n};

    for (var node in graph.nodes) {
      inDegree[node.id] = 0;
      adj[node.id] = [];
    }

    for (var edge in graph.edges) {
      if (adj.containsKey(edge.fromId) && inDegree.containsKey(edge.toId)) {
        adj[edge.fromId]!.add(edge.toId);
        inDegree[edge.toId] = (inDegree[edge.toId] ?? 0) + 1;
      }
    }

    final List<String> queue = [];
    inDegree.forEach((id, degree) {
      if (degree == 0) {
        queue.add(id);
      }
    });

    final List<TaskNode> sorted = [];
    while (queue.isNotEmpty) {
      final currentId = queue.removeAt(0);
      final node = nodeMap[currentId];
      if (node != null) sorted.add(node);

      final neighbors = adj[currentId] ?? [];
      for (var neighborId in neighbors) {
        inDegree[neighborId] = (inDegree[neighborId] ?? 1) - 1;
        if (inDegree[neighborId] == 0) {
          queue.add(neighborId);
        }
      }
    }

    // Append any isolated or unvisited nodes safely
    for (var node in graph.nodes) {
      if (!sorted.any((n) => n.id == node.id)) {
        sorted.add(node);
      }
    }

    return sorted;
  }

  /// Parses natural language Brain Dump into an intelligent branching DAG graph
  /// delegando al [CognitiveDecompressionEngine] local.
  static TaskGraph parseRawText(String text) {
    return CognitiveDecompressionEngine.decompressLocal(text);
  }

  static TaskGraph defaultSampleGraph() {
    const n1 = TaskNode(
      id: 'n1',
      title: 'Testear los endpoints en Postman y verificar respuestas JSON',
      category: 'Backend & Integración',
      subtext: 'Paso 1 del camino crítico. Sin dependencias activas.',
      estimatedMinutes: 15,
      energyLevel: EnergyLevel.medium,
    );

    const n2 = TaskNode(
      id: 'n2',
      title: 'Redactar el resumen ejecutivo de 2 párrafos para el informe',
      category: 'Documentación',
      subtext: 'Desbloqueado tras validar los endpoints.',
      estimatedMinutes: 20,
      energyLevel: EnergyLevel.high,
      dependencies: ['n1'],
    );

    const n3 = TaskNode(
      id: 'n3',
      title: 'Armar las 7 diapositivas visuales del Slide Deck en Figma',
      category: 'Presentación Final',
      subtext: 'Último nodo del grafo. Listo para la entrega de cátedra.',
      estimatedMinutes: 15,
      energyLevel: EnergyLevel.low,
      dependencies: ['n2'],
    );

    return const TaskGraph(
      nodes: [n1, n2, n3],
      edges: [
        TaskEdge(fromId: 'n1', toId: 'n2'),
        TaskEdge(fromId: 'n1', toId: 'n3'),
      ],
    );
  }
}

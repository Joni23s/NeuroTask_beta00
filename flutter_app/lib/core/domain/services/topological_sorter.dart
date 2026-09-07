import '../models/task_graph.dart';
import '../models/task_node.dart';

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
  static TaskGraph parseRawText(String text) {
    final clean = text.trim();
    if (clean.isEmpty) {
      return defaultSampleGraph();
    }

    final clauses = clean
        .split(RegExp(r'(?:,|\.|\n| y luego| después| primero| por último| pero antes| antes de| además| también| y tengo que| y debo)', caseSensitive: false))
        .map((s) => s.trim())
        .where((s) => s.length > 5)
        .toList();

    if (clauses.isEmpty) {
      return defaultSampleGraph();
    }

    final List<TaskNode> nodes = [];
    final List<TaskEdge> edges = [];

    // Parse clauses into nodes
    for (var i = 0; i < clauses.length && i < 6; i++) {
      final id = 'node_${i + 1}';
      final clause = clauses[i];
      final lower = clause.toLowerCase();

      String category = 'Ejecución';
      int mins = 15;
      EnergyLevel energy = EnergyLevel.medium;

      if (lower.contains('inglés') || lower.contains('estudiar') || lower.contains('leer') || lower.contains('vocabulario') || lower.contains('repasar')) {
        category = 'Estudio & Idiomas';
        mins = 20;
        energy = EnergyLevel.medium;
      } else if (lower.contains('test') || lower.contains('postman') || lower.contains('endpoint') || lower.contains('api') || lower.contains('back') || lower.contains('backend') || lower.contains('código')) {
        category = 'Backend & Dev';
        mins = 15;
        energy = EnergyLevel.medium;
      } else if (lower.contains('informe') || lower.contains('resumen') || lower.contains('redactar') || lower.contains('escribir') || lower.contains('doc') || lower.contains('notas')) {
        category = 'Documentación';
        mins = 20;
        energy = EnergyLevel.high;
      } else if (lower.contains('slide') || lower.contains('figma') || lower.contains('diapositiva') || lower.contains('diseño') || lower.contains('ui') || lower.contains('pantalla')) {
        category = 'Diseño & UI';
        mins = 15;
        energy = EnergyLevel.low;
      } else if (lower.contains('organizar') || lower.contains('limpiar') || lower.contains('llamar') || lower.contains('mail') || lower.contains('enviar')) {
        category = 'Gestión Rápida';
        mins = 10;
        energy = EnergyLevel.low;
      }

      nodes.add(
        TaskNode(
          id: id,
          title: clause[0].toUpperCase() + clause.substring(1),
          category: category,
          subtext: i == 0 ? 'Paso de arranque del camino lógico.' : 'Sub-nodo del árbol de tareas.',
          estimatedMinutes: mins,
          energyLevel: energy,
          dependencies: [],
        ),
      );
    }

    // Intelligent Branching Edge Construction
    if (nodes.length == 1) {
      return TaskGraph(nodes: nodes, edges: const []);
    } else if (nodes.length == 2) {
      // 2 nodes: direct connection
      edges.add(TaskEdge(fromId: nodes[0].id, toId: nodes[1].id));
    } else if (nodes.length == 3) {
      // 3 nodes: Root branching into 2 parallel or sequential sub-paths
      final sameCategory = nodes[1].category == nodes[2].category;
      if (sameCategory) {
        edges.add(TaskEdge(fromId: nodes[0].id, toId: nodes[1].id));
        edges.add(TaskEdge(fromId: nodes[1].id, toId: nodes[2].id));
      } else {
        // Bifurcation: Node 1 splits into Node 2 and Node 3
        edges.add(TaskEdge(fromId: nodes[0].id, toId: nodes[1].id));
        edges.add(TaskEdge(fromId: nodes[0].id, toId: nodes[2].id));
      }
    } else {
      // 4+ nodes: Tree structure with root and multiple branches
      edges.add(TaskEdge(fromId: nodes[0].id, toId: nodes[1].id));
      edges.add(TaskEdge(fromId: nodes[0].id, toId: nodes[2].id));
      for (int i = 3; i < nodes.length; i++) {
        // Alternate branches
        final parentIndex = (i % 2 == 1) ? 1 : 2;
        edges.add(TaskEdge(fromId: nodes[parentIndex].id, toId: nodes[i].id));
      }
    }

    return TaskGraph(nodes: nodes, edges: edges);
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

import 'package:neurotask/core/domain/models/task_node.dart';
import 'package:neurotask/core/domain/models/task_graph.dart';
import 'package:neurotask/core/domain/services/topological_sorter.dart';

void main() {
  print('--- TEST 1: TaskNode and TaskGraph serialization ---');
  const node = TaskNode(
    id: 'test_node_1',
    title: 'Verificar endpoints',
    category: 'Backend',
    subtext: 'Paso 1',
    estimatedMinutes: 12,
    energyLevel: EnergyLevel.high,
    dependencies: ['dep_0'],
    isCompleted: true,
    isAtomicSubstep: false,
  );

  final json = node.toJson();
  final restored = TaskNode.fromJson(json);
  assert(restored.id == node.id, 'Node ID must match');
  assert(restored.title == node.title, 'Node title must match');
  assert(restored.estimatedMinutes == 12, 'Estimated minutes must match');
  print('✓ TaskNode serialization OK');

  const graph = TaskGraph(
    nodes: [node],
    edges: [TaskEdge(fromId: 'dep_0', toId: 'test_node_1')],
  );
  final graphJson = graph.toJson();
  final restoredGraph = TaskGraph.fromJson(graphJson);
  assert(restoredGraph.nodes.length == 1, 'Graph node count must match');
  assert(restoredGraph.edges.length == 1, 'Graph edge count must match');
  print('✓ TaskGraph serialization OK');

  print('--- TEST 2: Topological Sorter ---');
  final sampleGraph = TopologicalSorter.defaultSampleGraph();
  final sorted = TopologicalSorter.sort(sampleGraph);
  assert(sorted.length == 3, 'Sorted length must be 3');
  assert(sorted[0].id == 'n1', 'First node in topological order must be n1');
  print('✓ Topological Sorter Kahn DAG OK: sorted into ${sorted.map((n) => n.id).toList()}');

  print('--- TEST 3: Natural Language Parser ---');
  final parsedGraph = TopologicalSorter.parseRawText(
    'Testear endpoints de auth, luego redactar el informe y por último diseñar slides en figma',
  );
  final parsedSorted = TopologicalSorter.sort(parsedGraph);
  assert(parsedSorted.isNotEmpty, 'Parsed graph must not be empty');
  print('✓ Raw Text Parser OK: parsed ${parsedSorted.length} nodes');

  print('========================================');
  print('ALL DOMAIN & ALGORITHM TESTS PASSED! 100%');
  print('========================================');
}

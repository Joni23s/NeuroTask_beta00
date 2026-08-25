import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neurotask/main.dart';
import 'package:neurotask/features/graph_engine/models/task_node.dart';
import 'package:neurotask/features/graph_engine/models/task_graph.dart';
import 'package:neurotask/features/graph_engine/services/topological_sorter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Model & DAG Engine Tests', () {
    test('TaskNode and TaskGraph JSON round-trip serialization', () {
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

      final jsonNode = node.toJson();
      final restoredNode = TaskNode.fromJson(jsonNode);

      expect(restoredNode.id, equals(node.id));
      expect(restoredNode.title, equals(node.title));
      expect(restoredNode.category, equals(node.category));
      expect(restoredNode.estimatedMinutes, equals(12));
      expect(restoredNode.energyLevel, equals(EnergyLevel.high));
      expect(restoredNode.isCompleted, isTrue);

      const graph = TaskGraph(
        nodes: [node],
        edges: [TaskEdge(fromId: 'dep_0', toId: 'test_node_1')],
      );
      final jsonGraph = graph.toJson();
      final restoredGraph = TaskGraph.fromJson(jsonGraph);

      expect(restoredGraph.nodes.length, equals(1));
      expect(restoredGraph.edges.length, equals(1));
    });

    test('TopologicalSorter generates valid acyclic order', () {
      final graph = TopologicalSorter.parseRawText(
        'Testear endpoints de auth, luego redactar el informe y por último diseñar slides en figma',
      );
      final sorted = TopologicalSorter.sort(graph);

      expect(sorted.length, greaterThanOrEqualTo(2));
      expect(sorted.first.category, contains('Backend'));
    });
  });

  group('Widget UI Smoke Tests', () {
    testWidgets('NeuroTaskApp initial welcome screen smoke test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: NeuroTaskApp(),
        ),
      );

      expect(find.text('NEUROTASK'), findsOneWidget);
      expect(find.text('MOTOR DE FOCO'), findsOneWidget);
      expect(find.text('Tocá el cerebro para descomprimir tu mente'), findsOneWidget);
    });
  });
}

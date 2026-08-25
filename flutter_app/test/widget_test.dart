import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neurotask/main.dart';

void main() {
  testWidgets('NeuroTaskApp initial screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: NeuroTaskApp(),
      ),
    );

    // Verify that the title and cognitive decompress elements exist
    expect(find.text('¿Qué ronda por tu cabeza?'), findsOneWidget);
    expect(find.text('Descompresión Cognitiva'), findsOneWidget);
    expect(find.text('NEUROTASK'), findsOneWidget);
  });
}

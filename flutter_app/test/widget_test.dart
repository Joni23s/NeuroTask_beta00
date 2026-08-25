import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neurotask/main.dart';

void main() {
  testWidgets('NeuroTaskApp initial welcome screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: NeuroTaskApp(),
      ),
    );

    // Verify that the Welcome screen renders the branding
    expect(find.text('NEUROTASK'), findsOneWidget);
    expect(find.text('MOTOR DE FOCO'), findsOneWidget);
    expect(find.text('Tocar para Descomprimir'), findsOneWidget);
  });
}

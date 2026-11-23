import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neurotask/core/domain/services/cognitive_decompression_engine.dart';
import 'package:neurotask/core/domain/services/topological_sorter.dart';
import 'package:neurotask/core/services/achievements_storage_service.dart';
import 'package:neurotask/core/utils/haptic_helper.dart';
import 'package:neurotask/data/repositories/user_repository.dart';
import 'package:neurotask/features/achievements/achievements_controller.dart';
import 'package:neurotask/features/focus/focus_controller.dart';
import 'package:neurotask/features/settings/settings_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    HapticHelper.enabled = true;
  });

  group('SettingsNotifier & HapticHelper', () {
    test('Persists switches and updates HapticHelper.enabled', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(settingsProvider.notifier);
      await notifier.loadSettings();

      await notifier.toggleAnchorNotifications(false);
      await notifier.toggleAutoBrownNoise(true);
      await notifier.toggleHapticFeedback(false);

      final state = container.read(settingsProvider);
      expect(state.anchorNotifications, isFalse);
      expect(state.autoBrownNoise, isTrue);
      expect(state.hapticFeedback, isFalse);
      expect(HapticHelper.enabled, isFalse);

      // Verificar recarga desde SharedPreferences en una nueva instancia
      final reloadedContainer = ProviderContainer();
      addTearDown(reloadedContainer.dispose);
      await reloadedContainer.read(settingsProvider.notifier).loadSettings();

      final reloadedState = reloadedContainer.read(settingsProvider);
      expect(reloadedState.anchorNotifications, isFalse);
      expect(reloadedState.autoBrownNoise, isTrue);
      expect(reloadedState.hapticFeedback, isFalse);
      expect(HapticHelper.enabled, isFalse);
    });
  });

  group('FocusNotifier Cognitive Rescue Branch Skip', () {
    test('skipCurrentTaskToAlternativeBranch postpones current task without marking complete', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(focusProvider.notifier);
      await notifier.loadFromRawText(
        'Testear endpoints en Postman, redactar el informe final, diseñar slides en Figma',
      );

      final initialQueue = container.read(focusProvider).executionQueue;
      expect(initialQueue.length, equals(3));
      final firstId = initialQueue.first.id;
      final secondId = initialQueue[1].id;

      final skipped = await notifier.skipCurrentTaskToAlternativeBranch();
      expect(skipped, isTrue);

      final afterState = container.read(focusProvider);
      expect(afterState.currentIndex, equals(0));
      expect(afterState.executionQueue.first.id, equals(secondId));
      expect(afterState.executionQueue.last.id, equals(firstId));
      expect(afterState.executionQueue.last.isCompleted, isFalse);
    });

    test('skipCurrentTaskToAlternativeBranch returns false when only 1 pending task remains', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(focusProvider.notifier);
      await notifier.loadFromRawText('Resolver ejercicio puntual en 5 min');

      expect(container.read(focusProvider).executionQueue.length, equals(1));
      final skipped = await notifier.skipCurrentTaskToAlternativeBranch();
      expect(skipped, isFalse);
    });
  });

  group('AchievementsNotifier Single Flow Count', () {
    test('recordFlowCompletion increments completed flows counter exactly once', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(achievementsProvider.notifier);
      await notifier.recordFlowCompletion(
        isFaster: true,
        isLonger: false,
        usedDarkMode: false,
        usedBrownNoise: true,
        usedRescue: false,
      );

      final flowsState = container.read(achievementsProvider).totalFlowsCompleted;
      final flowsStored = await AchievementsStorageService.getCompletedFlowsCount();

      expect(flowsState, equals(1));
      expect(flowsStored, equals(1));
    });
  });

  group('UserRepository Profile Email Migration, Streak & Auth Session', () {
    test('updateProfile migrates account key when email changes and preserves login', () async {
      final repo = UserRepository();
      const oldEmail = 'alumno.original@itu.uncuyo.edu.ar';
      const newEmail = 'alumno.nuevo@itu.uncuyo.edu.ar';
      const password = 'claveSegura123';

      final reg = await repo.register(
        name: 'Estudiante Prueba',
        email: oldEmail,
        password: password,
      );
      expect(reg.success, isTrue);

      final updated = reg.user!.copyWith(
        name: 'Estudiante Actualizado',
        email: newEmail,
      );
      await repo.updateProfile(updated, previousEmail: oldEmail);

      final oldLogin = await repo.login(oldEmail, password);
      expect(oldLogin.success, isFalse);

      final newLogin = await repo.login(newEmail, password);
      expect(newLogin.success, isTrue);
      expect(newLogin.user?.name, equals('Estudiante Actualizado'));
      expect(await repo.isLoggedIn(), isTrue);

      await repo.logout();
      expect(await repo.isLoggedIn(), isFalse);
    });

    test('recordTaskCompletion tracks tasks, minutes, level progression and consecutive day streak', () async {
      final repo = UserRepository();
      final reg = await repo.register(
        name: 'Racha Tester',
        email: 'racha@itu.uncuyo.edu.ar',
        password: 'password123',
      );
      expect(reg.success, isTrue);
      await repo.login('racha@itu.uncuyo.edu.ar', 'password123');

      final day1 = DateTime(2026, 11, 20);
      final day2 = DateTime(2026, 11, 21);
      final day5 = DateTime(2026, 11, 24);

      final afterDay1 = await repo.recordTaskCompletion(minutes: 15, activityDate: day1);
      expect(afterDay1.totalTasksCompleted, equals(1));
      expect(afterDay1.totalFocusMinutes, equals(15));
      expect(afterDay1.currentStreak, equals(1));

      // Mismo día mantiene racha
      final afterSameDay = await repo.recordTaskCompletion(minutes: 15, activityDate: day1);
      expect(afterSameDay.totalTasksCompleted, equals(2));
      expect(afterSameDay.currentStreak, equals(1));

      // Día consecutivo incrementa racha a 2
      final afterDay2 = await repo.recordTaskCompletion(minutes: 20, activityDate: day2);
      expect(afterDay2.totalTasksCompleted, equals(3));
      expect(afterDay2.totalFocusMinutes, equals(50));
      expect(afterDay2.currentStreak, equals(2));

      // Salto de días reinicia racha a 1
      final afterGap = await repo.recordTaskCompletion(minutes: 10, activityDate: day5);
      expect(afterGap.currentStreak, equals(1));

      // Completar hasta 10 tareas sube a Nivel 2
      var latest = afterGap;
      while (latest.totalTasksCompleted < 10) {
        latest = await repo.recordTaskCompletion(minutes: 10, activityDate: day5);
      }
      expect(latest.totalTasksCompleted, equals(10));
      expect(latest.level, equals(2));
      expect(latest.levelTitle, equals('Practicante Resiliente'));
    });
  });

  group('CognitiveDecompressionEngine & Hybrid AI Settings', () {
    test('Automatically decomposes a single macro-task into 3-4 atomic micro-steps', () {
      final graph = CognitiveDecompressionEngine.decompressLocal(
        'Estudiar para el parcial de programación',
      );
      final sorted = TopologicalSorter.sort(graph);

      expect(sorted.length, inInclusiveRange(3, 4));
      expect(sorted.every((n) => n.isAtomicSubstep), isTrue);
      expect(sorted.first.dependencies, isEmpty);
      expect(sorted.last.dependencies, isNotEmpty);
      expect(graph.edges, isNotEmpty);
    });

    test('Cleans fillers, extracts explicit durations, splits "y + verb" and applies causal inversion', () {
      final multiGraph = CognitiveDecompressionEngine.decompressLocal(
        'Hoy tengo que armar slides en Figma 25 min y pagar internet media hora',
      );
      expect(multiGraph.nodes.length, equals(2));
      expect(multiGraph.nodes[0].title, startsWith('Armar slides'));
      expect(multiGraph.nodes[0].title.toLowerCase(), isNot(contains('hoy tengo que')));
      expect(multiGraph.nodes[0].estimatedMinutes, equals(25));
      expect(multiGraph.nodes[1].title, startsWith('Pagar internet'));
      expect(multiGraph.nodes[1].estimatedMinutes, equals(30));

      final causalGraph = CognitiveDecompressionEngine.decompressLocal(
        'Enviar el informe pero antes revisar la ortografía',
      );
      final causalSorted = TopologicalSorter.sort(causalGraph);
      expect(causalSorted.length, equals(2));
      expect(causalSorted.first.title.toLowerCase(), contains('revisar'));
      expect(causalSorted.last.title.toLowerCase(), contains('enviar el informe'));
      expect(causalSorted.last.dependencies, contains(causalSorted.first.id));
    });

    test('Persists Gemini AI settings and handles valid AI response or offline fallback safely', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(settingsProvider.notifier);
      await notifier.loadSettings();

      expect(container.read(settingsProvider).isAiActive, isFalse);

      await notifier.setGeminiApiKey('AIzaTestKey123456');
      await notifier.toggleUseAiDecompression(true);
      expect(container.read(settingsProvider).hasGeminiApiKey, isTrue);
      expect(container.read(settingsProvider).isAiActive, isTrue);

      final reloadedContainer = ProviderContainer();
      addTearDown(reloadedContainer.dispose);
      await reloadedContainer.read(settingsProvider.notifier).loadSettings();
      expect(
        reloadedContainer.read(settingsProvider).geminiApiKey,
        equals('AIzaTestKey123456'),
      );
      expect(reloadedContainer.read(settingsProvider).isAiActive, isTrue);

      final mockSuccessClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'candidates': [
              {
                'content': {
                  'parts': [
                    {
                      'text': jsonEncode({
                        'nodes': [
                          {
                            'id': 'ai_1',
                            'title': 'Preparar resumen teórico IA',
                            'category': 'Estudio & Idiomas',
                            'subtext': 'Generado por Gemini AI.',
                            'estimatedMinutes': 10,
                            'energyLevel': 0,
                            'dependencies': [],
                            'isAtomicSubstep': true,
                          },
                          {
                            'id': 'ai_2',
                            'title': 'Practicar ejercicios clave',
                            'category': 'Estudio & Idiomas',
                            'subtext': 'Segundo micro-paso IA.',
                            'estimatedMinutes': 15,
                            'energyLevel': 1,
                            'dependencies': ['ai_1'],
                            'isAtomicSubstep': true,
                          },
                        ],
                        'edges': [
                          {'fromId': 'ai_1', 'toId': 'ai_2'}
                        ],
                      }),
                    }
                  ],
                },
              }
            ],
          }),
          200,
        );
      });

      final aiGraph = await CognitiveDecompressionEngine.decompress(
        'Estudiar algoritmo de grafos',
        geminiApiKey: 'AIzaTestKey123456',
        useAiIfAvailable: true,
        client: mockSuccessClient,
      );
      expect(aiGraph.nodes.length, equals(2));
      expect(aiGraph.nodes.first.title, equals('Preparar resumen teórico IA'));

      final mockErrorClient = MockClient((request) async {
        return http.Response('{"error": "rate_limit"}', 500);
      });

      final fallbackGraph = await CognitiveDecompressionEngine.decompress(
        'Estudiar para el parcial de programación',
        geminiApiKey: 'AIzaTestKey123456',
        useAiIfAvailable: true,
        client: mockErrorClient,
      );
      expect(fallbackGraph.nodes.length, inInclusiveRange(3, 4));
      expect(fallbackGraph.nodes.every((n) => n.isAtomicSubstep), isTrue);
    });
  });
}

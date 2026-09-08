import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neurotask/core/domain/models/achievement.dart';
import 'package:neurotask/features/achievements/achievements_controller.dart';
import 'package:neurotask/features/achievements/achievements_vault_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Achievements Model & Logic Tests', () {
    test('Initial catalog contains 10 curated achievements', () {
      final catalog = Achievement.initialCatalog();
      expect(catalog.length, 10);
      expect(catalog.every((a) => !a.isUnlocked), true);
    });

    test('Achievement JSON serialization and deserialization', () {
      final achievement = Achievement(
        id: 'test_achievement',
        title: 'Test Title',
        description: 'Test Description',
        iconEmoji: '🏆',
        category: AchievementCategory.foco,
        unlockedAt: DateTime(2026, 8, 25, 12, 0),
        rewardInsight: 'Gran insight de prueba',
      );

      final json = achievement.toJson();
      expect(json['id'], 'test_achievement');
      expect(json['category'], 'foco');
      expect(json['unlockedAt'], isNotNull);

      final fromJson = Achievement.fromJson(json);
      expect(fromJson.id, achievement.id);
      expect(fromJson.title, achievement.title);
      expect(fromJson.isUnlocked, true);
      expect(fromJson.category, AchievementCategory.foco);
    });

    test('AchievementsNotifier unlocks achievements and calculates progress', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(achievementsProvider.notifier);

      expect(container.read(achievementsProvider).unlockedCount, 0);
      expect(container.read(achievementsProvider).progressPercentage, 0.0);

      // Unlock first brain dump
      final res = await notifier.unlock('first_brain_dump');
      expect(res, true);
      expect(container.read(achievementsProvider).unlockedCount, 1);
      expect(container.read(achievementsProvider).progressPercentage, greaterThan(0.0));

      // Attempting to unlock again returns false
      final secondTry = await notifier.unlock('first_brain_dump');
      expect(secondTry, false);
    });
  });

  group('Achievements Vault UI Smoke Tests', () {
    testWidgets('AchievementsVaultScreen renders with progress and categories', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AchievementsVaultScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('BAÚL DE LOGROS'), findsOneWidget);
      expect(find.textContaining('Conquistados'), findsOneWidget);
      expect(find.text('Todos'), findsOneWidget);
      expect(find.text('🎯 Foco'), findsOneWidget);
      expect(find.text('🌱 Resiliencia'), findsOneWidget);
      expect(find.text('Descompresión Inicial'), findsOneWidget);
    });
  });
}

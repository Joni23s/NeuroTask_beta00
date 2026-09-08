import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/achievements_storage_service.dart';
import '../models/achievement.dart';

class AchievementsState {
  final List<Achievement> achievements;
  final int totalFlowsCompleted;
  final Achievement? latestUnlockedAchievement;

  const AchievementsState({
    required this.achievements,
    this.totalFlowsCompleted = 0,
    this.latestUnlockedAchievement,
  });

  int get unlockedCount => achievements.where((a) => a.isUnlocked).length;
  int get totalCount => achievements.length;
  double get progressPercentage => totalCount > 0 ? (unlockedCount / totalCount) : 0.0;

  AchievementsState copyWith({
    List<Achievement>? achievements,
    int? totalFlowsCompleted,
    Achievement? latestUnlockedAchievement,
  }) {
    return AchievementsState(
      achievements: achievements ?? this.achievements,
      totalFlowsCompleted: totalFlowsCompleted ?? this.totalFlowsCompleted,
      latestUnlockedAchievement: latestUnlockedAchievement,
    );
  }
}

class AchievementsNotifier extends Notifier<AchievementsState> {
  @override
  AchievementsState build() {
    Future.microtask(() => _loadStoredAchievements());
    return AchievementsState(achievements: Achievement.initialCatalog());
  }

  Future<void> _loadStoredAchievements() async {
    final unlockedMap = await AchievementsStorageService.loadUnlockedAchievements();
    final flowsCount = await AchievementsStorageService.getCompletedFlowsCount();

    final updated = state.achievements.map((item) {
      if (unlockedMap.containsKey(item.id)) {
        final date = DateTime.tryParse(unlockedMap[item.id]!) ?? DateTime.now();
        return item.copyWith(unlockedAt: date);
      }
      return item;
    }).toList();

    state = state.copyWith(
      achievements: updated,
      totalFlowsCompleted: flowsCount,
    );
  }

  Future<bool> unlock(String id) async {
    final index = state.achievements.indexWhere((a) => a.id == id);
    if (index == -1) return false;

    final target = state.achievements[index];
    if (target.isUnlocked) return false; // Already unlocked

    final now = DateTime.now();
    final updatedTarget = target.copyWith(unlockedAt: now);
    final updatedList = List<Achievement>.from(state.achievements);
    updatedList[index] = updatedTarget;

    // Check if neuro_master (>= 5 achievements) should unlock
    final unlockedSoFar = updatedList.where((a) => a.isUnlocked).length;
    if (unlockedSoFar >= 5 && id != 'neuro_master') {
      final masterIndex = updatedList.indexWhere((a) => a.id == 'neuro_master');
      if (masterIndex != -1 && !updatedList[masterIndex].isUnlocked) {
        updatedList[masterIndex] = updatedList[masterIndex].copyWith(unlockedAt: now);
      }
    }

    state = state.copyWith(
      achievements: updatedList,
      latestUnlockedAchievement: updatedTarget,
    );

    // Persist to storage
    final mapToSave = <String, String>{};
    for (final a in updatedList) {
      if (a.isUnlocked && a.unlockedAt != null) {
        mapToSave[a.id] = a.unlockedAt!.toIso8601String();
      }
    }
    await AchievementsStorageService.saveUnlockedAchievements(mapToSave);
    return true;
  }

  Future<void> recordBrainDump() async {
    await unlock('first_brain_dump');
  }

  Future<void> recordVoiceDictation() async {
    await unlock('voice_thinker');
  }

  Future<void> recordRescueUsed() async {
    await unlock('rescue_master');
  }

  Future<void> recordFlowCompletion({
    required bool isFaster,
    required bool isLonger,
    required bool usedDarkMode,
    required bool usedBrownNoise,
    required bool usedRescue,
  }) async {
    final newFlowsCount = await AchievementsStorageService.incrementCompletedFlows();
    state = state.copyWith(totalFlowsCompleted: newFlowsCount);

    await unlock('first_flow_completed');

    if (newFlowsCount >= 3) {
      await unlock('trilogy_flow');
    }

    if (isFaster) {
      await unlock('hyperfocus_ray');
    } else if (isLonger) {
      await unlock('resilience_champion');
    }

    if (usedDarkMode) {
      await unlock('night_guardian');
    }

    if (usedBrownNoise) {
      await unlock('sensory_bubble');
    }

    if (usedRescue) {
      await unlock('rescue_master');
    }
  }

  void clearLatestUnlocked() {
    state = state.copyWith(latestUnlockedAchievement: null);
  }
}

final achievementsProvider = NotifierProvider<AchievementsNotifier, AchievementsState>(
  AchievementsNotifier.new,
);

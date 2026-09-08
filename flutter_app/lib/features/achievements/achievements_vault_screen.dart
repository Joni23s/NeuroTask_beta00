import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/models/achievement.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/neumorphic_card.dart';
import '../../core/widgets/neuro_badge.dart';
import '../../core/widgets/theme_toggle_button.dart';
import 'achievements_controller.dart';

class AchievementsVaultScreen extends ConsumerStatefulWidget {
  const AchievementsVaultScreen({super.key});

  @override
  ConsumerState<AchievementsVaultScreen> createState() => _AchievementsVaultScreenState();
}

class _AchievementsVaultScreenState extends ConsumerState<AchievementsVaultScreen> {
  AchievementCategory? _selectedCategory;

  void _showAchievementDetail(Achievement achievement) {
    HapticHelper.lightTap();
    final isDark = context.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: context.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Central Trophy Icon
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: achievement.isUnlocked
                      ? AppColors.primaryIndigo.withValues(alpha: 0.12)
                      : context.pressedSurface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: achievement.isUnlocked ? AppColors.successEmerald : context.borderLight,
                    width: 2,
                  ),
                  boxShadow: achievement.isUnlocked
                      ? [
                          const BoxShadow(
                            color: AppColors.emeraldGlow,
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    achievement.iconEmoji,
                    style: TextStyle(
                      fontSize: 36,
                      color: achievement.isUnlocked ? null : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                achievement.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.textMain,
                ),
              ),
              const SizedBox(height: 6),

              NeuroBadge.highlight(
                label: achievement.isUnlocked ? '✨ DESBLOQUEADO' : '🔒 BLOQUEADO',
                backgroundColor: achievement.isUnlocked
                    ? AppColors.successEmerald.withValues(alpha: 0.15)
                    : context.pressedSurface,
                textColor: achievement.isUnlocked ? AppColors.successEmerald : context.textMuted,
                borderRadius: 10,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
              const SizedBox(height: 14),

              Text(
                achievement.description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: context.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 16),

              // Insight Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.pressedSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded, size: 16, color: AppColors.amberDark),
                        const SizedBox(width: 6),
                        Text(
                          'Impacto Neuro-Cognitivo:',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? AppColors.brandGlowCyan : AppColors.brandDeepBlue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement.rewardInsight,
                      style: TextStyle(fontSize: 12, color: context.textMain, height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              NeumorphicButton(
                variant: NeumorphicButtonVariant.primary,
                height: 46,
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Entendido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final achievementsState = ref.watch(achievementsProvider);
    final allList = achievementsState.achievements;
    final filteredList = _selectedCategory == null
        ? allList
        : allList.where((a) => a.category == _selectedCategory).toList();

    final unlockedCount = achievementsState.unlockedCount;
    final totalCount = achievementsState.totalCount;
    final progress = achievementsState.progressPercentage;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: context.textMain),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Volver',
                  ),
                  Text(
                    'BAÚL DE LOGROS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: context.textMain,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const ThemeToggleButton(),
                ],
              ),
              const SizedBox(height: 14),

              // Progress Overview Card
              NeumorphicCard(
                padding: const EdgeInsets.all(18),
                borderRadius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$unlockedCount de $totalCount Conquistados',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: context.textMain,
                                  ),
                                ),
                                Text(
                                  'Progreso cognitivo: ${(progress * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: context.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.successEmerald.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(progress * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.successEmerald,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: context.pressedSurface,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.successEmerald),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Category Filter Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildCategoryFilterPill(label: 'Todos', category: null),
                    _buildCategoryFilterPill(label: '🎯 Foco', category: AchievementCategory.foco),
                    _buildCategoryFilterPill(label: '🌱 Resiliencia', category: AchievementCategory.resiliencia),
                    _buildCategoryFilterPill(label: '🌿 Calma', category: AchievementCategory.calma),
                    _buildCategoryFilterPill(label: '🧠 Exploración', category: AchievementCategory.exploracion),
                    _buildCategoryFilterPill(label: '👑 Maestría', category: AchievementCategory.maestria),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Achievements List
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    final isUnlocked = item.isUnlocked;

                    return NeumorphicCard(
                      padding: const EdgeInsets.all(16),
                      borderRadius: 20,
                      onTap: () => _showAchievementDetail(item),
                      border: isUnlocked
                          ? Border.all(color: AppColors.successEmerald.withValues(alpha: 0.4), width: 1.2)
                          : null,
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isUnlocked
                                  ? AppColors.primaryIndigo.withValues(alpha: 0.12)
                                  : context.pressedSurface,
                              shape: BoxShape.circle,
                              boxShadow: isUnlocked
                                  ? [
                                      const BoxShadow(
                                        color: AppColors.emeraldGlow,
                                        blurRadius: 12,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                isUnlocked ? item.iconEmoji : '🔒',
                                style: TextStyle(
                                  fontSize: isUnlocked ? 24 : 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        item.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isUnlocked ? context.textMain : context.textMuted,
                                        ),
                                      ),
                                    ),
                                    if (isUnlocked)
                                      const Icon(Icons.check_circle_rounded, color: AppColors.successEmerald, size: 16),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isUnlocked ? context.textSecondary : context.textMuted.withValues(alpha: 0.7),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilterPill({required String label, required AchievementCategory? category}) {
    final isSelected = _selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          HapticHelper.lightTap();
          setState(() {
            _selectedCategory = category;
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryIndigo : context.cardSurface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isSelected ? null : context.subtleElevation,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : context.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

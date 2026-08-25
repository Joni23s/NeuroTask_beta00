import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../core/widgets/flow_indicator.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../../core/widgets/swipe_to_complete_card.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../../core/widgets/zen_timer_widget.dart';
import '../../unblock_mode/presentation/cognitive_rescue_sheet.dart';
import '../../unblock_mode/presentation/graph_overview_modal.dart';
import '../controllers/focus_controller.dart';
import 'summary_celebration_screen.dart';

class SingleTaskScreen extends ConsumerWidget {
  const SingleTaskScreen({super.key});

  void _openRescueSheet(BuildContext context) {
    HapticHelper.lightTap();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CognitiveRescueSheet(),
    );
  }

  void _openGraphModal(BuildContext context) {
    HapticHelper.lightTap();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const GraphOverviewModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusState = ref.watch(focusProvider);
    final audioState = ref.watch(audioServiceProvider);
    final isDark = context.isDarkMode;

    // If completed all tasks, navigate to the celebratory summary screen
    if (focusState.isCompletedAll || focusState.currentTask == null) {
      return const SummaryCelebrationScreen();
    }

    final task = focusState.currentTask!;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Navigation & Sensory Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlowIndicator(
                    currentStep: focusState.currentStepNumber,
                    totalSteps: focusState.totalSteps,
                  ),
                  Row(
                    children: [
                      // Ambient Noise Toggle
                      IconButton(
                        icon: Icon(
                          audioState.ambientType == AmbientSoundType.brownNoise
                              ? Icons.cloud_queue_rounded
                              : Icons.cloud_outlined,
                          color: audioState.ambientType == AmbientSoundType.brownNoise
                              ? AppColors.primaryIndigo
                              : context.textSecondary,
                        ),
                        onPressed: () {
                          ref.read(audioServiceProvider.notifier).toggleAmbient(AmbientSoundType.brownNoise);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2),
                              content: Text(
                                audioState.ambientType == AmbientSoundType.brownNoise
                                    ? '🔇 Sonido ambiental pausado'
                                    : '🌧️ Ruido Marrón activo para concentración',
                              ),
                            ),
                          );
                        },
                        tooltip: 'Sonido de Enfoque',
                      ),
                      IconButton(
                        icon: Icon(Icons.hub_outlined, color: context.textSecondary),
                        onPressed: () => _openGraphModal(context),
                        tooltip: 'Ver Mapa del Grafo',
                      ),
                      IconButton(
                        icon: const Icon(Icons.spa_outlined, color: AppColors.primaryIndigo),
                        onPressed: () => _openRescueSheet(context),
                        tooltip: 'Rescate Cognitivo',
                      ),
                      const SizedBox(width: 4),
                      const ThemeToggleButton(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                'ESTÁS ENFOCADO EN ESTO AHORA:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.9,
                  color: context.textMuted,
                ),
              ),
              const Spacer(),

              // Swipe-to-Complete Interactive Hero Card
              SwipeToCompleteCard(
                onSwipeCompleted: () {
                  ref.read(audioServiceProvider.notifier).playCompletionChime();
                  ref.read(focusProvider.notifier).completeCurrentTask();
                },
                onPullRescue: () => _openRescueSheet(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.brandGlowCyan : AppColors.brandDeepBlue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          task.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.brandGlowCyan : AppColors.brandDeepBlue,
                            letterSpacing: 1.1,
                          ),
                        ),
                        if (task.isAtomicSubstep)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.amberLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Micro-Paso (3m)',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.amberDark),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.textMain,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      task.subtext,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Divider(color: context.borderLight),
                    const SizedBox(height: 12),

                    // Organic Zen Timer
                    ZenTimerWidget(initialMinutes: task.estimatedMinutes),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Center(
                child: Text(
                  '👉 Deslizá la tarjeta hacia la derecha para completar',
                  style: TextStyle(fontSize: 11, color: context.textMuted, fontWeight: FontWeight.w500),
                ),
              ),

              const Spacer(),

              // Action Buttons
              NeumorphicButton(
                variant: NeumorphicButtonVariant.success,
                borderRadius: 20,
                height: 56,
                onPressed: () {
                  ref.read(audioServiceProvider.notifier).playCompletionChime();
                  ref.read(focusProvider.notifier).completeCurrentTask();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Paso Completado',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              NeumorphicButton(
                variant: NeumorphicButtonVariant.flat,
                borderRadius: 18,
                height: 48,
                onPressed: () => _openRescueSheet(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.help_outline_rounded, color: AppColors.amberWarning, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Estoy Bloqueado / Dividir más',
                      style: TextStyle(color: context.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

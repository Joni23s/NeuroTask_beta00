import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/neumorphic_theme.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../core/widgets/flow_indicator.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../../core/widgets/zen_timer_widget.dart';
import '../../brain_dump/presentation/brain_dump_screen.dart';
import '../../unblock_mode/presentation/cognitive_rescue_sheet.dart';
import '../../unblock_mode/presentation/graph_overview_modal.dart';
import '../controllers/focus_controller.dart';

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

    // If completed all tasks, show celebratory view
    if (focusState.isCompletedAll || focusState.currentTask == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: NeumorphicTheme.softElevation,
                  ),
                  child: const Center(
                    child: Text('🏆', style: TextStyle(fontSize: 42)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '¡Objetivo Cumplido!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textMain),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Completaste todos los nodos del camino lógico sin sobrecarga sensorial ni parálisis por análisis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 36),
                NeumorphicButton(
                  variant: NeumorphicButtonVariant.primary,
                  height: 54,
                  onPressed: () {
                    ref.read(focusProvider.notifier).reset();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const BrainDumpScreen()),
                    );
                  },
                  child: const Text('Iniciar Nuevo Volcado (Brain Dump)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final task = focusState.currentTask!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlowIndicator(
                    currentStep: focusState.currentStepNumber,
                    totalSteps: focusState.totalSteps,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.hub_outlined, color: AppColors.textSecondary),
                        onPressed: () => _openGraphModal(context),
                        tooltip: 'Ver Mapa del Grafo',
                      ),
                      IconButton(
                        icon: const Icon(Icons.spa_outlined, color: AppColors.primaryIndigo),
                        onPressed: () => _openRescueSheet(context),
                        tooltip: 'Rescate Cognitivo',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                'ESTÁS ENFOCADO EN ESTO AHORA:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.9,
                  color: AppColors.textMuted,
                ),
              ),
              const Spacer(),

              // Neumorphic Central Focus Hero Card
              NeumorphicCard(
                borderRadius: 32,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primaryIndigo,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          task.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryIndigo,
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
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.amberWarning),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      task.subtext,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 12),

                    // Organic Zen Timer
                    ZenTimerWidget(initialMinutes: task.estimatedMinutes),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              NeumorphicButton(
                variant: NeumorphicButtonVariant.success,
                borderRadius: 20,
                height: 58,
                onPressed: () {
                  HapticHelper.success();
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help_outline_rounded, color: AppColors.amberWarning, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Estoy Bloqueado / Dividir más',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
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

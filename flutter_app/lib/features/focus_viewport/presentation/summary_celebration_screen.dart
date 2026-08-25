import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/neumorphic_theme.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../brain_dump/presentation/brain_dump_screen.dart';
import '../../unblock_mode/presentation/graph_overview_modal.dart';
import '../controllers/focus_controller.dart';

class SummaryCelebrationScreen extends ConsumerWidget {
  const SummaryCelebrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusState = ref.watch(focusProvider);
    final totalNodes = focusState.executionQueue.length;
    final totalMinutes = focusState.executionQueue.fold<int>(0, (sum, item) => sum + item.estimatedMinutes);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header Brand Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: NeumorphicTheme.subtleElevation,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(radius: 3.5, backgroundColor: AppColors.successEmerald),
                    SizedBox(width: 8),
                    Text(
                      'Objetivo Conquistado',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.successEmerald,
                      ),
                    ),
                  ],
                ),
              ),

              // Central Celebration Content
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emeraldGlow,
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-8, -8),
                          blurRadius: 18,
                        ),
                        BoxShadow(
                          color: AppColors.shadowDark,
                          offset: Offset(8, 8),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🏆', style: TextStyle(fontSize: 48)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    '¡Flujo Completado!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Completaste todos los pasos del camino lógico sin sobrecarga sensorial ni parálisis ejecutiva.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Metrics Cards
                  Row(
                    children: [
                      Expanded(
                        child: NeumorphicCard(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          borderRadius: 20,
                          child: Column(
                            children: [
                              const Text('🎯', style: TextStyle(fontSize: 20)),
                              const SizedBox(height: 6),
                              Text(
                                '$totalNodes / $totalNodes',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMain),
                              ),
                              const Text(
                                'Nodos Logrados',
                                style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: NeumorphicCard(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          borderRadius: 20,
                          child: Column(
                            children: [
                              const Text('⏳', style: TextStyle(fontSize: 20)),
                              const SizedBox(height: 6),
                              Text(
                                '${totalMinutes}m',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryIndigo),
                              ),
                              const Text(
                                'Tiempo Sereno',
                                style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: NeumorphicCard(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          borderRadius: 20,
                          child: Column(
                            children: [
                              Text('🌿', style: TextStyle(fontSize: 20)),
                              SizedBox(height: 6),
                              Text(
                                '100%',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.successEmerald),
                              ),
                              Text(
                                'Calma Mental',
                                style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Bottom Actions
              Column(
                children: [
                  NeumorphicButton(
                    variant: NeumorphicButtonVariant.flat,
                    height: 50,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => const GraphOverviewModal(),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hub_outlined, size: 18, color: AppColors.primaryIndigo),
                        SizedBox(width: 8),
                        Text('Inspeccionar Grafo Vectorial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textMain)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  NeumorphicButton(
                    variant: NeumorphicButtonVariant.primary,
                    height: 56,
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
            ],
          ),
        ),
      ),
    );
  }
}

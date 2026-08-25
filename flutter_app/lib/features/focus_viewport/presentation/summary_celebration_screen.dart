import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../brain_dump/presentation/brain_dump_screen.dart';
import '../../unblock_mode/presentation/graph_overview_modal.dart';
import '../controllers/focus_controller.dart';
import 'cognitive_insight_card.dart';

class SummaryCelebrationScreen extends ConsumerWidget {
  const SummaryCelebrationScreen({super.key});

  String _buildFormattedReport(FocusState state) {
    final totalNodes = state.executionQueue.length;
    final elapsedSecs = state.elapsedSeconds;
    final estimatedMins = state.totalEstimatedMinutes;
    final realMins = (elapsedSecs / 60).ceil();
    final buffer = StringBuffer();

    buffer.writeln('🧠 *NeuroTask — Victoria de Foco Conquistada* ✨');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('🎯 *Nodos completados:* $totalNodes / $totalNodes (100%)');
    buffer.writeln('⏳ *Tiempo real de foco:* ${state.formattedRealTime} (Estimado: $estimatedMins min)');
    buffer.writeln('🌿 *Calma mental:* 100% (Sin sobrecarga)');

    if (realMins < estimatedMins && elapsedSecs < (estimatedMins * 60)) {
      final saved = estimatedMins - (elapsedSecs ~/ 60);
      buffer.writeln('⚡ *Logro:* ¡Modo Hiperfoco! Ahorraste ~$saved min de libertad mental.');
    } else if (realMins > estimatedMins) {
      buffer.writeln('🌱 *Logro:* ¡Victoria de Resiliencia! Empezaste y terminaste sin abandonar.');
    } else {
      buffer.writeln('🎯 *Logro:* Sincronía y ritmo perfecto entre estimación y ejecución.');
    }

    buffer.writeln('');
    buffer.writeln('📋 *Camino Lógico Ejecutado:*');

    for (int i = 0; i < state.executionQueue.length; i++) {
      final node = state.executionQueue[i];
      buffer.writeln('✅ ${i + 1}. [${node.category}] ${node.title} (${node.estimatedMinutes}m)');
    }

    buffer.writeln('');
    buffer.writeln('✨ _"Menos ruido mental, más foco sereno."_');
    buffer.writeln('🚀 Generado con NeuroTask Mobile — DAM ITU UNCuyo');

    return buffer.toString();
  }

  void _copyReportToClipboard(BuildContext context, FocusState state) {
    HapticHelper.success();
    final report = _buildFormattedReport(state);
    Clipboard.setData(ClipboardData(text: report));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.brandDeepBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.successEmerald, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '¡Resumen copiado al portapapeles! Listo para compartir.',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showReportPreviewDialog(BuildContext context, FocusState state) {
    HapticHelper.lightTap();
    final report = _buildFormattedReport(state);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: context.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reporte de Victoria 🏆',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.textMain),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20, color: context.textMuted),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                constraints: const BoxConstraints(maxHeight: 220),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.pressedSurface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: context.pressedElevation,
                  border: Border.all(color: context.borderLight),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    report,
                    style: TextStyle(fontSize: 12, height: 1.4, color: context.textMain, fontFamily: 'monospace'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              NeumorphicButton(
                variant: NeumorphicButtonVariant.success,
                height: 48,
                onPressed: () {
                  Navigator.pop(ctx);
                  _copyReportToClipboard(context, state);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.copy_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Copiar al Portapapeles', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusState = ref.watch(focusProvider);
    final totalNodes = focusState.executionQueue.length;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                // Top Header Badge & Theme Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: context.subtleElevation,
                        border: Border.all(color: context.borderLight),
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
                    const ThemeToggleButton(),
                  ],
                ),
                const SizedBox(height: 24),

                // Central Celebration Hero
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: context.cardSurface,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      const BoxShadow(
                        color: AppColors.emeraldGlow,
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: isDark ? Colors.white10 : Colors.white,
                        offset: const Offset(-8, -8),
                        blurRadius: 18,
                      ),
                      BoxShadow(
                        color: isDark ? AppColors.darkShadowDark : AppColors.shadowDark,
                        offset: const Offset(8, 8),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🏆', style: TextStyle(fontSize: 44)),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  '¡Flujo Completado!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: context.textMain,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Completaste todos los pasos del camino lógico sin sobrecarga sensorial ni parálisis ejecutiva.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // Metrics Cards (Real Measured Metrics)
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicCard(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                        borderRadius: 20,
                        child: Column(
                          children: [
                            const Text('🎯', style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 4),
                            Text(
                              '$totalNodes / $totalNodes',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: context.textMain),
                            ),
                            Text(
                              'Nodos Logrados',
                              style: TextStyle(fontSize: 10, color: context.textMuted, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NeumorphicCard(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                        borderRadius: 20,
                        child: Column(
                          children: [
                            const Text('⏳', style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 4),
                            Text(
                              focusState.formattedRealTime,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryIndigo),
                            ),
                            Text(
                              'Tiempo Real',
                              style: TextStyle(fontSize: 10, color: context.textMuted, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NeumorphicCard(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                        borderRadius: 20,
                        child: Column(
                          children: [
                            const Text('🌿', style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 4),
                            const Text(
                              '100%',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.successEmerald),
                            ),
                            Text(
                              'Calma Mental',
                              style: TextStyle(fontSize: 10, color: context.textMuted, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Empathetic Cognitive Insight Card (Dual outcome reward)
                CognitiveInsightCard(focusState: focusState),
                const SizedBox(height: 20),

                // Report and Sharing Actions
                NeumorphicButton(
                  variant: NeumorphicButtonVariant.success,
                  height: 52,
                  onPressed: () => _copyReportToClipboard(context, focusState),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('Compartir / Copiar Logro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        variant: NeumorphicButtonVariant.flat,
                        height: 48,
                        onPressed: () => _showReportPreviewDialog(context, focusState),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.description_outlined, size: 16, color: isDark ? AppColors.brandGlowCyan : AppColors.brandDeepBlue),
                            const SizedBox(width: 6),
                            Text('Ver Reporte', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: context.textMain)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NeumorphicButton(
                        variant: NeumorphicButtonVariant.flat,
                        height: 48,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => const GraphOverviewModal(),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.hub_outlined, size: 16, color: AppColors.primaryIndigo),
                            const SizedBox(width: 6),
                            Text('Mapa Grafo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: context.textMain)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

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
      ),
    );
  }
}

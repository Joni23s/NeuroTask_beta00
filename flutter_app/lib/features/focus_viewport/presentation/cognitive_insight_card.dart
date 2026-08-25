import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../controllers/focus_controller.dart';

class CognitiveInsightCard extends StatelessWidget {
  final FocusState focusState;

  const CognitiveInsightCard({
    super.key,
    required this.focusState,
  });

  @override
  Widget build(BuildContext context) {
    final elapsedSecs = focusState.elapsedSeconds;
    final estimatedMins = focusState.totalEstimatedMinutes;
    final realMins = (elapsedSecs / 60).ceil();
    final isDark = context.isDarkMode;

    final bool isFaster = realMins < estimatedMins && elapsedSecs < (estimatedMins * 60);
    final bool isLonger = realMins > estimatedMins;

    String title;
    String subtitle;
    String motivation;
    IconData icon;
    Color accentColor;

    if (isFaster) {
      final savedMins = estimatedMins - (elapsedSecs ~/ 60);
      title = '⚡ ¡Modo Hiperfoco Conquistado!';
      subtitle = 'Completaste en ${focusState.formattedRealTime} (Estimado: ${estimatedMins}m)';
      motivation = savedMins > 0
          ? '¡Ganaste ~$savedMins min de libertad mental! Venciste la parálisis y demostraste que la tarea era mucho más liviana de lo que tu cabeza temía.'
          : '¡Excelente velocidad y fluidez! Venciste la fricción inicial con foco sereno.';
      icon = Icons.bolt_rounded;
      accentColor = AppColors.successEmerald;
    } else if (isLonger) {
      title = '🌱 Victoria de Persistencia y Calma';
      subtitle = 'Tiempo dedicado: ${focusState.formattedRealTime} (Estimado: ${estimatedMins}m)';
      motivation =
          '¡Iniciaste y lograste terminar la tarea hasta el final! No abandonaste ante la dificultad. En neurodiversidad, la constancia serena vale el doble.';
      icon = Icons.spa_rounded;
      accentColor = isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo;
    } else {
      title = '🎯 Ritmo y Precisión Armónica';
      subtitle = 'Completaste en ${focusState.formattedRealTime} (Estimado: ${estimatedMins}m)';
      motivation =
          'Sincronía perfecta entre estimación y ejecución. Un flujo balanceado y sin sobrecarga cognitiva.';
      icon = Icons.track_changes_rounded;
      accentColor = isDark ? AppColors.brandGlowCyan : AppColors.brandSteelBlue;
    }

    return NeumorphicCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 24,
      border: Border.all(
        color: accentColor.withValues(alpha: isDark ? 0.4 : 0.35),
        width: 1.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: context.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: context.pressedSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.borderLight),
            ),
            child: Text(
              motivation,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: context.textMain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

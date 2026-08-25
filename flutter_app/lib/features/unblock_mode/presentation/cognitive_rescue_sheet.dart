import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../achievements/controllers/achievements_controller.dart';
import '../../focus_viewport/controllers/focus_controller.dart';

class CognitiveRescueSheet extends ConsumerWidget {
  const CognitiveRescueSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: context.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Descompresión y Rescate Cognitivo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.textMain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Elegí cómo querés continuar sin culpas ni presiones.',
            style: TextStyle(fontSize: 12, color: context.textSecondary),
          ),
          const SizedBox(height: 20),

          // Option 1: Split in 3 min micro-steps
          _RescueOptionCard(
            badgeNumber: '1',
            badgeColor: AppColors.primaryIndigoLight,
            title: 'Subdividir en micro-pasos de 3 min',
            subtitle: 'Desarma la tarea en un paso mínimo para arrancar ya.',
            onTap: () {
              ref.read(focusProvider.notifier).splitCurrentTask();
              ref.read(achievementsProvider.notifier).recordRescueUsed();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✨ Tarea dividida en micro-pasos de 3 min sin fricción'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Option 2: Low Energy Mode
          _RescueOptionCard(
            badgeNumber: '2',
            badgeColor: AppColors.amberWarning,
            title: 'Activar Modo Baja Energía',
            subtitle: 'Reordena el grafo para hacer únicamente lo menos demandante.',
            onTap: () {
              ref.read(focusProvider.notifier).activateLowEnergyMode();
              ref.read(achievementsProvider.notifier).recordRescueUsed();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🌱 Modo Baja Energía Activo: Priorizando lo liviano'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Option 3: Skip / Complete
          _RescueOptionCard(
            badgeNumber: '3',
            badgeColor: AppColors.successEmerald,
            title: 'Saltar a rama independiente',
            subtitle: 'Avanzá por otra tarea desbloqueada sin bloquear el flujo.',
            onTap: () {
              ref.read(focusProvider.notifier).completeCurrentTask();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🔀 Saltando a rama alternativa'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),

          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Volver a la tarea',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RescueOptionCard extends StatelessWidget {
  final String badgeNumber;
  final Color badgeColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RescueOptionCard({
    required this.badgeNumber,
    required this.badgeColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 20,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                badgeNumber,
                style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.textMain),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: context.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

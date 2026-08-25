import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/neumorphic_theme.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../focus_viewport/controllers/focus_controller.dart';

class CognitiveRescueSheet extends ConsumerWidget {
  const CognitiveRescueSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
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
                color: AppColors.textMuted.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Descompresión y Rescate Cognitivo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Elegí cómo querés continuar sin culpas ni presiones.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          // Option 1: Split in 3 min micro-steps
          _RescueOptionCard(
            badgeNumber: '1',
            badgeColor: AppColors.primaryIndigoLight,
            title: 'Subdividir en micro-pasos de 3 min',
            subtitle: 'Desarma la tarea en algo minúsculo para bajar fricción.',
            onTap: () {
              ref.read(focusProvider.notifier).splitCurrentTask();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✨ Tarea dividida en micro-pasos de 3 min')),
              );
            },
          ),
          const SizedBox(height: 12),

          // Option 2: Low Energy Mode
          _RescueOptionCard(
            badgeNumber: '2',
            badgeColor: AppColors.amberWarning,
            title: 'Activar Modo Baja Energía',
            subtitle: 'Reordenar para hacer únicamente lo menos demandante.',
            onTap: () {
              ref.read(focusProvider.notifier).activateLowEnergyMode();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🌱 Modo Baja Energía Activo')),
              );
            },
          ),
          const SizedBox(height: 12),

          // Option 3: Skip / Complete
          _RescueOptionCard(
            badgeNumber: '3',
            badgeColor: AppColors.successEmerald,
            title: 'Saltar / Avanzar al siguiente nodo',
            subtitle: 'Avanzá por otra rama independiente del proyecto.',
            onTap: () {
              ref.read(focusProvider.notifier).completeCurrentTask();
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Volver a la tarea',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
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
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.15),
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
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMain),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

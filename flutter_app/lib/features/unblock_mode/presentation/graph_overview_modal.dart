import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../focus_viewport/controllers/focus_controller.dart';

class GraphOverviewModal extends ConsumerWidget {
  const GraphOverviewModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusState = ref.watch(focusProvider);
    final queue = focusState.executionQueue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
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
                color: AppColors.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mapa del Grafo (Tus ideas)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Secuencia topológica calculada',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryIndigoLight.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'DAG Engine',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryIndigo),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 340),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: queue.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final node = queue[index];
                final isCurrent = index == focusState.currentIndex && !focusState.isCompletedAll;
                final isCompleted = node.isCompleted;

                return NeumorphicCard(
                  padding: const EdgeInsets.all(14),
                  borderRadius: 18,
                  backgroundColor: isCurrent ? AppColors.primaryIndigoLight.withValues(alpha: 0.08) : AppColors.cardSurface,
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.successEmerald
                              : isCurrent
                                  ? AppColors.primaryIndigo
                                  : AppColors.pressedSurface,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Center(
                          child: Text(
                            isCompleted ? '✓' : '${index + 1}',
                            style: TextStyle(
                              color: isCompleted || isCurrent ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  node.category.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isCompleted
                                        ? AppColors.successEmerald
                                        : isCurrent
                                            ? AppColors.primaryIndigo
                                            : AppColors.textMuted,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  '${node.estimatedMinutes}m',
                                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              node.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMain),
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

          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cerrar Mapa',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

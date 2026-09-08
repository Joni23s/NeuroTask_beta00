import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../../core/widgets/neuro_badge.dart';
import '../../../core/widgets/neuro_modal_sheet.dart';
import '../focus_controller.dart';
import 'dag_canvas_widget.dart';

class GraphOverviewModal extends StatefulWidget {
  const GraphOverviewModal({super.key});

  @override
  State<GraphOverviewModal> createState() => _GraphOverviewModalState();
}

class _GraphOverviewModalState extends State<GraphOverviewModal> {
  bool _showVectorCanvas = true;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final focusState = ref.watch(focusProvider);
        final queue = focusState.executionQueue;

        return NeuroModalSheet(
          title: 'Mapa del Grafo (Tus ideas)',
          subtitle: 'Secuencia topológica calculada',
          trailing: NeuroBadge.chip(
            label: _showVectorCanvas ? 'Ver Lista' : 'Ver Grafo',
            icon: _showVectorCanvas ? Icons.view_list_rounded : Icons.hub_outlined,
            textColor: AppColors.primaryIndigo,
            iconColor: AppColors.primaryIndigo,
            backgroundColor: AppColors.primaryIndigoLight.withValues(alpha: 0.12),
            onTap: () => setState(() => _showVectorCanvas = !_showVectorCanvas),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Content Area (Tree DAG Canvas or Structured List)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: _showVectorCanvas
                    ? DagCanvasWidget(
                        nodes: queue,
                        currentIndex: focusState.currentIndex,
                        graph: focusState.graph,
                      )
                    : ListView.separated(
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
                            backgroundColor: isCurrent ? AppColors.primaryIndigoLight.withValues(alpha: 0.08) : context.cardSurface,
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
                                            : context.pressedSurface,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isCompleted ? '✓' : '${index + 1}',
                                      style: TextStyle(
                                        color: isCompleted || isCurrent ? Colors.white : context.textSecondary,
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
                                                      : context.textMuted,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                          Text(
                                            '${node.estimatedMinutes}m',
                                            style: TextStyle(fontSize: 10, color: context.textMuted),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        node.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textMain),
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
                  child: Text(
                    'Cerrar Mapa',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

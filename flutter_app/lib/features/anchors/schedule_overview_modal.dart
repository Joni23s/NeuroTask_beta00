import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/models/time_anchor.dart';
import '../../core/domain/services/anchor_schedule_fitter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/neuro_inset_container.dart';
import '../../core/widgets/neuro_modal_sheet.dart';
import '../focus/focus_controller.dart';
import 'anchors_controller.dart';
import 'anchors_manager_screen.dart';

class ScheduleOverviewModal extends ConsumerWidget {
  const ScheduleOverviewModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusState = ref.watch(focusProvider);
    final anchorsState = ref.watch(anchorsProvider);
    final isDark = context.isDarkMode;

    final tasks = focusState.executionQueue;
    final todayAnchors = anchorsState.anchorsForSelectedDay;

    // Ejecutar el algoritmo anti-solapamiento de forma determinista y reactiva
    final scheduleResult = AnchorScheduleFitter.fitTasks(
      tasks: tasks,
      anchors: todayAnchors,
    );

    return NeuroModalSheet(
      title: 'Tus tareas de hoy',
      subtitle: 'Verificá cómo tus horarios se adaptan a tus anclas fijas',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status bar informativa sobre viabilidad y horas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: scheduleResult.isOverloaded
                    ? AppColors.amberWarning.withValues(alpha: 0.12)
                    : (isDark ? Colors.white10 : AppColors.primaryIndigo.withValues(alpha: 0.06)),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: scheduleResult.isOverloaded
                      ? AppColors.amberWarning.withValues(alpha: 0.5)
                      : (isDark ? AppColors.brandGlowCyan.withValues(alpha: 0.3) : AppColors.primaryIndigo.withValues(alpha: 0.2)),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    scheduleResult.isOverloaded ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                    size: 18,
                    color: scheduleResult.isOverloaded
                        ? AppColors.amberDark
                        : (isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      scheduleResult.statusMessage,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: scheduleResult.isOverloaded
                            ? AppColors.amberDark
                            : (isDark ? AppColors.darkTextMain : AppColors.textMain),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Inset Container con la lista cronológica de tareas y anclas intermedias
            NeuroInsetContainer(
              height: 280,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              borderRadius: 24,
              child: tasks.isEmpty
                  ? Center(
                      child: Text(
                        'No hay tareas cargadas para agendar.',
                        style: TextStyle(color: context.textMuted, fontSize: 13),
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: scheduleResult.scheduledTasks.length,
                      separatorBuilder: (context, index) {
                        // Verificar si entre esta tarea y la siguiente hay un ancla fija
                        final currentTask = scheduleResult.scheduledTasks[index];
                        final nextTask = (index + 1 < scheduleResult.scheduledTasks.length)
                            ? scheduleResult.scheduledTasks[index + 1]
                            : null;

                        if (nextTask != null && currentTask.scheduledEndTime != null && nextTask.scheduledStartTime != null) {
                          final curEnd = TimeAnchor.parseTimeToMinutes(currentTask.scheduledEndTime!);
                          final nextStart = TimeAnchor.parseTimeToMinutes(nextTask.scheduledStartTime!);

                          // Buscar anclas que queden en este intervalo
                          final intermediateAnchors = todayAnchors.where((a) =>
                              a.startMinutes >= curEnd && a.endMinutes <= nextStart).toList();

                          if (intermediateAnchors.isNotEmpty) {
                            return Column(
                              children: intermediateAnchors.map((anchor) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.brandSteelBlue.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppColors.brandSteelBlue.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.anchor_rounded, size: 14, color: AppColors.brandSteelBlue),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${anchor.startTime} - ${anchor.endTime}: ${anchor.title}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.brandSteelBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        }

                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        final task = scheduleResult.scheduledTasks[index];
                        final isCurrentFocus = index == focusState.currentIndex;

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isCurrentFocus
                                ? (isDark ? Colors.white12 : Colors.white)
                                : context.cardSurface,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: context.subtleElevation,
                            border: Border.all(
                              color: isCurrentFocus
                                  ? (isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo)
                                  : context.borderLight,
                              width: isCurrentFocus ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Horario proyectado
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white10 : AppColors.primaryIndigo.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  task.scheduledStartTime ?? '${14 + index}:00',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Título de la tarea
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: context.textMain,
                                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${task.category} • ${task.estimatedMinutes} min',
                                      style: TextStyle(fontSize: 10.5, color: context.textMuted),
                                    ),
                                  ],
                                ),
                              ),

                              // Indicador circular de estado (Wireframe 3)
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: task.isCompleted
                                      ? AppColors.successEmerald
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: task.isCompleted
                                        ? AppColors.successEmerald
                                        : context.borderLight,
                                    width: 2,
                                  ),
                                ),
                                child: task.isCompleted
                                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),

            // Botones de Acción: "Reorganizar Tareas" + "Comenzar / Entendido"
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    button: true,
                    label: 'Gestionar o Reorganizar Anclas Fijas',
                    child: InkWell(
                      onTap: () {
                        HapticHelper.lightTap();
                        Navigator.pop(context); // Cierra modal
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AnchorsManagerScreen()),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: context.cardSurface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: context.subtleElevation,
                          border: Border.all(color: context.borderLight),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sync_rounded, size: 18, color: context.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              'Reorganizar',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: context.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeumorphicButton(
                    variant: NeumorphicButtonVariant.primary,
                    borderRadius: 16,
                    height: 50,
                    onPressed: () {
                      HapticHelper.lightTap();
                      Navigator.pop(context);
                    },
                    child: const Center(
                      child: Text(
                        'Comenzar',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

import 'dart:math' as math;
import '../models/task_node.dart';
import '../models/time_anchor.dart';

class ScheduleFitResult {
  final List<TaskNode> scheduledTasks;
  final List<TimeAnchor> activeAnchors;
  final int totalTaskMinutes;
  final int totalAvailableMinutes;
  final bool isOverloaded;
  final String statusMessage;

  const ScheduleFitResult({
    required this.scheduledTasks,
    required this.activeAnchors,
    required this.totalTaskMinutes,
    required this.totalAvailableMinutes,
    required this.isOverloaded,
    required this.statusMessage,
  });
}

class AnchorScheduleFitter {
  /// Algoritmo de ajuste temporal anti-solapamiento (Time-Blocking Adaptativo)
  ///
  /// Toma las tareas secuenciadas del Grafo DAG y las anclas horarias no negociables,
  /// ubicando cada tarea en ventanas libres y saltando automáticamente las anclas
  /// para evitar colisiones horarias.
  static ScheduleFitResult fitTasks({
    required List<TaskNode> tasks,
    required List<TimeAnchor> anchors,
    int? startMinutesOverride,
    int bufferMinutesBetweenTasks = 5,
    int dayLimitMinutes = 1410, // 23:30 hs como límite sereno del día
  }) {
    if (tasks.isEmpty) {
      return ScheduleFitResult(
        scheduledTasks: const [],
        activeAnchors: anchors.where((a) => a.isActive).toList(),
        totalTaskMinutes: 0,
        totalAvailableMinutes: 0,
        isOverloaded: false,
        statusMessage: 'No hay tareas en cola para agendar.',
      );
    }

    // 1. Filtrar y ordenar anclas activas cronológicamente
    final sortedAnchors = anchors.where((a) => a.isActive).toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

    // 2. Determinar hora inicial (por defecto hora actual o 09:00 si es de madrugada)
    int cursor;
    if (startMinutesOverride != null) {
      cursor = startMinutesOverride;
    } else {
      final now = DateTime.now();
      final currentMinutes = now.hour * 60 + now.minute;
      // Redondear a los próximos 5 minutos
      cursor = ((currentMinutes + 4) ~/ 5) * 5;
      if (cursor > dayLimitMinutes - 60) {
        cursor = 540; // 09:00 si ya es tarde en la noche
      }
    }

    final scheduledList = <TaskNode>[];
    int totalTaskMinutes = 0;

    for (final task in tasks) {
      final duration = task.estimatedMinutes > 0 ? task.estimatedMinutes : 15;
      totalTaskMinutes += duration;

      bool placed = false;
      int attempts = 0;

      while (!placed && attempts < 20) {
        attempts++;

        // A. Si el cursor cae dentro de un ancla activa, saltar al fin del ancla
        TimeAnchor? containingAnchor;
        for (final anchor in sortedAnchors) {
          if (cursor >= anchor.startMinutes && cursor < anchor.endMinutes) {
            containingAnchor = anchor;
            break;
          }
        }

        if (containingAnchor != null) {
          cursor = containingAnchor.endMinutes + bufferMinutesBetweenTasks;
          continue;
        }

        // B. Verificar si la tarea colisiona con el inicio de alguna próxima ancla
        final taskEnd = cursor + duration;
        TimeAnchor? collidingAnchor;
        for (final anchor in sortedAnchors) {
          if (cursor < anchor.startMinutes && taskEnd > anchor.startMinutes) {
            collidingAnchor = anchor;
            break;
          }
        }

        if (collidingAnchor != null) {
          // Salto anti-solapamiento: saltar al final del ancla
          cursor = collidingAnchor.endMinutes + bufferMinutesBetweenTasks;
        } else {
          // Cabe perfectamente en la ventana libre actual
          final startStr = TimeAnchor.minutesToTimeString(cursor);
          final endStr = TimeAnchor.minutesToTimeString(taskEnd);

          scheduledList.add(task.copyWith(
            scheduledStartTime: startStr,
            scheduledEndTime: endStr,
          ));

          cursor = taskEnd + bufferMinutesBetweenTasks;
          placed = true;
        }
      }

      // Si no pudo ser colocada de forma óptima
      if (!placed) {
        final startStr = TimeAnchor.minutesToTimeString(cursor);
        final endStr = TimeAnchor.minutesToTimeString(cursor + duration);
        scheduledList.add(task.copyWith(
          scheduledStartTime: startStr,
          scheduledEndTime: endStr,
        ));
        cursor += duration + bufferMinutesBetweenTasks;
      }
    }

    // 3. Diagnóstico de viabilidad cognitiva
    final lastTaskEnd = cursor;
    final isOverloaded = lastTaskEnd > dayLimitMinutes;

    String statusMessage;
    if (isOverloaded) {
      final exceededHours = ((lastTaskEnd - dayLimitMinutes) / 60).toStringAsFixed(1);
      statusMessage = '⚠️ Alerta de Sobrecarga: Las tareas se extienden $exceededHours h más allá de las 23:30. Te sugerimos posponer tareas secundarias.';
    } else {
      final durationStr = totalTaskMinutes >= 60
          ? '${totalTaskMinutes ~/ 60}h ${totalTaskMinutes % 60}m'
          : '${totalTaskMinutes}m';
      statusMessage = 'Tus tareas demandan $durationStr y encajan en tus ventanas libres sin solaparse.';
    }

    return ScheduleFitResult(
      scheduledTasks: scheduledList,
      activeAnchors: sortedAnchors,
      totalTaskMinutes: totalTaskMinutes,
      totalAvailableMinutes: math.max(0, dayLimitMinutes - (startMinutesOverride ?? cursor)),
      isOverloaded: isOverloaded,
      statusMessage: statusMessage,
    );
  }
}

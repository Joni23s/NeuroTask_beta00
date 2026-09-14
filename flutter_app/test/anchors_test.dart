import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neurotask/core/domain/models/task_node.dart';
import 'package:neurotask/core/domain/models/time_anchor.dart';
import 'package:neurotask/core/domain/services/anchor_schedule_fitter.dart';
import 'package:neurotask/model/dbhelper.dart';
import 'package:neurotask/util/date_time_formatter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('TimeAnchor Domain Model Tests', () {
    test('TimeAnchor JSON round-trip serialization', () {
      const anchor = TimeAnchor(
        id: 'anchor_facultad_test',
        title: 'Facultad DAM UNCuyo',
        startTime: '08:00',
        endTime: '12:00',
        daysOfWeek: [1, 3, 5],
        category: 'Facultad',
        isRecurring: true,
        isActive: true,
      );

      final json = anchor.toJson();
      final restored = TimeAnchor.fromJson(json);

      expect(restored.id, equals(anchor.id));
      expect(restored.title, equals(anchor.title));
      expect(restored.startTime, equals('08:00'));
      expect(restored.endTime, equals('12:00'));
      expect(restored.startMinutes, equals(480));
      expect(restored.endMinutes, equals(720));
      expect(restored.durationMinutes, equals(240));
      expect(restored.daysOfWeek, equals([1, 3, 5]));
      expect(restored.appliesToWeekday(1), isTrue); // Lunes
      expect(restored.appliesToWeekday(2), isFalse); // Martes
      expect(restored.isActive, isTrue);
    });

    test('TimeAnchor.withId named constructor behaves correctly', () {
      const anchor = TimeAnchor.withId(
        id: 'anchor_dam_exam',
        title: 'Examen Final DAM',
        startTime: '09:00',
        endTime: '11:30',
        category: 'Facultad',
      );
      expect(anchor.id, equals('anchor_dam_exam'));
      expect(anchor.title, equals('Examen Final DAM'));
      expect(anchor.durationMinutes, equals(150));
    });

    test('TaskNode.withId named constructor behaves correctly', () {
      const node = TaskNode.withId(
        id: 'node_dam_1',
        title: 'Entrega DAM',
        category: 'Facultad',
        subtext: 'Revisión final',
      );
      expect(node.id, equals('node_dam_1'));
      expect(node.title, equals('Entrega DAM'));
    });

    test('DateTimeFormatter utility formats days, durations and ranges in Spanish', () {
      expect(DateTimeFormatter.formatWeekday(1), equals('Lunes'));
      expect(DateTimeFormatter.formatWeekday(7), equals('Domingo'));
      expect(DateTimeFormatter.formatWeekdayShort(1), equals('Lun'));
      expect(DateTimeFormatter.formatWeekdayShort(5), equals('Vie'));
      expect(DateTimeFormatter.formatDuration(45), equals('45 min'));
      expect(DateTimeFormatter.formatDuration(60), equals('1 h'));
      expect(DateTimeFormatter.formatDuration(90), equals('1 h 30 min'));
      expect(DateTimeFormatter.formatTimeRangeWithDuration('08:00', '12:00', 240), equals('08:00 - 12:00 (4 h)'));
    });

    test('Helper parseTimeToMinutes and minutesToTimeString conversions', () {
      expect(TimeAnchor.parseTimeToMinutes('08:30'), equals(510));
      expect(TimeAnchor.parseTimeToMinutes('17:45'), equals(1065));
      expect(TimeAnchor.minutesToTimeString(510), equals('08:30'));
      expect(TimeAnchor.minutesToTimeString(1065), equals('17:45'));
    });
  });

  group('AnchorScheduleFitter Anti-Overlap Algorithm Tests', () {
    test('Tasks correctly jump over active anchors without any collision', () {
      // Setup identical to teammate wireframes:
      // Ancla 1: 08:00 a 12:00 Facultad
      // Ancla 2: 17:30 a 19:30 Gimnasio
      // Ancla 3: 22:00 a 23:30 Cena
      const anchors = [
        TimeAnchor(
          id: 'facultad',
          title: 'Facultad',
          startTime: '08:00',
          endTime: '12:00',
          isActive: true,
        ),
        TimeAnchor(
          id: 'gym',
          title: 'Gimnasio',
          startTime: '17:30',
          endTime: '19:30',
          isActive: true,
        ),
        TimeAnchor(
          id: 'cena',
          title: 'Cena',
          startTime: '22:00',
          endTime: '23:30',
          isActive: true,
        ),
      ];

      // Tareas a agendar desde las 14:00 (840 min)
      const tasks = [
        TaskNode(id: 't1', title: 'Hacer presentación', category: 'General', subtext: '', estimatedMinutes: 60),
        TaskNode(id: 't2', title: 'Estudiar', category: 'General', subtext: '', estimatedMinutes: 90),
        // Esta tarea iniciaría alrededor de las 16:35 y terminaría a las 18:05, colisionando con el Gym (17:30)!
        TaskNode(id: 't3', title: 'Lavar la ropa', category: 'General', subtext: '', estimatedMinutes: 90),
        TaskNode(id: 't4', title: 'Tender la ropa', category: 'General', subtext: '', estimatedMinutes: 30),
      ];

      final result = AnchorScheduleFitter.fitTasks(
        tasks: tasks,
        anchors: anchors,
        startMinutesOverride: 840, // 14:00
      );

      expect(result.scheduledTasks.length, equals(4));

      // Verificar que ninguna tarea se solapa con ninguna de las anclas
      for (final task in result.scheduledTasks) {
        expect(task.scheduledStartTime, isNotNull);
        expect(task.scheduledEndTime, isNotNull);

        final tStart = TimeAnchor.parseTimeToMinutes(task.scheduledStartTime!);
        final tEnd = TimeAnchor.parseTimeToMinutes(task.scheduledEndTime!);

        for (final anchor in anchors) {
          final aStart = anchor.startMinutes;
          final aEnd = anchor.endMinutes;

          // Condición de no solapamiento: o la tarea termina antes del ancla, o empieza después del ancla
          final noOverlap = (tEnd <= aStart) || (tStart >= aEnd);
          expect(
            noOverlap,
            isTrue,
            reason: 'Task ${task.title} [$tStart, $tEnd] se solapa con ancla ${anchor.title} [$aStart, $aEnd]',
          );
        }
      }

      // La tarea t3 tuvo que saltar para empezar DESPUÉS de las 19:30 (fin del Gym = 1170 min)
      final t3Start = TimeAnchor.parseTimeToMinutes(result.scheduledTasks[2].scheduledStartTime!);
      expect(t3Start, greaterThanOrEqualTo(TimeAnchor.parseTimeToMinutes('19:30')));
    });

    test('Overload detection triggers when tasks exceed day limit', () {
      const anchors = [
        TimeAnchor(id: 'a1', title: 'Trabajo', startTime: '09:00', endTime: '18:00'),
      ];

      // 8 tareas de 60 min cada una (8 horas de trabajo) empezando a las 19:00
      final tasks = List.generate(
        8,
        (i) => TaskNode(id: 'task_$i', title: 'Tarea $i', category: 'Heavy', subtext: '', estimatedMinutes: 60),
      );

      final result = AnchorScheduleFitter.fitTasks(
        tasks: tasks,
        anchors: anchors,
        startMinutesOverride: 1140, // 19:00
      );

      expect(result.isOverloaded, isTrue);
      expect(result.statusMessage, contains('Alerta de Sobrecarga'));
    });
  });

  group('DbHelper Singleton & CRUD Transactions (Unidad 3.1.1)', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('DbHelper enforces Singleton pattern (identical instances)', () {
      final db1 = DbHelper();
      final db2 = DbHelper();
      expect(identical(db1, db2), isTrue);
    });

    test('TimeAnchor toMap and fromObject bidirectional serialization', () {
      const original = TimeAnchor.withId(
        id: 'anchor_db_1',
        title: 'Tutoría DAM',
        startTime: '14:00',
        endTime: '15:30',
        category: 'Facultad',
        daysOfWeek: [2, 4],
        isRecurring: true,
        isActive: true,
      );

      final map = original.toMap();
      final reconstructed = TimeAnchor.fromObject(map);

      expect(reconstructed.id, equals(original.id));
      expect(reconstructed.title, equals(original.title));
      expect(reconstructed.startTime, equals('14:00'));
      expect(reconstructed.endTime, equals('15:30'));
      expect(reconstructed.daysOfWeek, equals([2, 4]));
    });

    test('TaskNode toMap and fromObject bidirectional serialization', () {
      const node = TaskNode.withId(
        id: 'node_db_1',
        title: 'Preparar informe SQLite',
        category: 'Backend',
        subtext: 'Paso 1',
        estimatedMinutes: 20,
      );

      final map = node.toMap();
      final reconstructed = TaskNode.fromObject(map);

      expect(reconstructed.id, equals(node.id));
      expect(reconstructed.title, equals(node.title));
      expect(reconstructed.estimatedMinutes, equals(20));
    });

    test('DbHelper CRUD lifecycle: insert, get, update, delete, deleteRows', () async {
      final db = DbHelper();
      await db.deleteRows(); // Empezar limpio

      // 1. Insert
      const anchor = TimeAnchor.withId(
        id: 'test_anchor_crud',
        title: 'Clase de SQLite',
        startTime: '10:00',
        endTime: '12:00',
      );
      final insertResult = await db.insertAnchor(anchor);
      expect(insertResult, equals(1));

      // 2. Read
      final rows = await db.getAnchors();
      expect(rows.any((r) => r['id'] == 'test_anchor_crud'), isTrue);

      final objects = await db.getAnchorObjects();
      expect(objects.any((a) => a.id == 'test_anchor_crud'), isTrue);

      // 3. Update
      final updated = anchor.copyWith(title: 'Clase de SQLite Avanzada');
      final updateResult = await db.updateAnchor(updated);
      expect(updateResult, equals(1));

      final rowsAfterUpdate = await db.getAnchors();
      final updatedRow = rowsAfterUpdate.firstWhere((r) => r['id'] == 'test_anchor_crud');
      expect(updatedRow['title'], equals('Clase de SQLite Avanzada'));

      // 4. Delete
      final deleteResult = await db.deleteAnchor('test_anchor_crud');
      expect(deleteResult, equals(1));

      final rowsAfterDelete = await db.getAnchors();
      expect(rowsAfterDelete.any((r) => r['id'] == 'test_anchor_crud'), isFalse);

      // 5. Delete rows / Truncate
      await db.insertAnchor(anchor);
      final deletedCount = await db.deleteRows();
      expect(deletedCount, greaterThanOrEqualTo(1));

      // 6. Reset to defaults
      final defaultCount = await db.resetToDefaults();
      expect(defaultCount, equals(3));
    });
  });
}

import 'dart:async';
import '../../core/domain/models/time_anchor.dart';
import '../../model/dbhelper.dart';

/// Repositorio de Anclas Horarias y Malla Temporal (Capa de Datos).
///
/// Encapsula el acceso a datos delegando la persistencia física en [DbHelper] (Patrón Singleton)
/// y proveyendo datos dinámicos tipados a la UI, eliminando los datos hardcodeados
/// en pantallas visuales (como _mockLunesItems en AnchorsManagerScreen).
/// Cumple con los estándares de la Unidad 3.1.1 de la cátedra DAM (Tema 1).
class AnchorRepository {
  final DbHelper _db = DbHelper();

  // Catálogo inicial ampliado de anclas horarias y actividades de la Malla Temporal
  // (antes hardcodeadas dentro del archivo anchors_manager_screen.dart)
  static final List<TimeAnchor> _defaultMallaActivities = [
    // Anclas académicas / fijas
    const TimeAnchor(
      id: 'anchor_facultad',
      title: 'Facultad DAM (UNCuyo)',
      startTime: '08:00',
      endTime: '12:00',
      daysOfWeek: [1, 2, 3, 4, 5],
      category: 'Facultad',
      isRecurring: true,
      isActive: true,
    ),
    const TimeAnchor(
      id: 'anchor_gym',
      title: 'Gimnasio / Deporte',
      startTime: '17:30',
      endTime: '19:30',
      daysOfWeek: [1, 3, 5],
      category: 'Gimnasio',
      isRecurring: true,
      isActive: true,
    ),
    const TimeAnchor(
      id: 'anchor_cena',
      title: 'Cena y Desconexión',
      startTime: '22:00',
      endTime: '23:30',
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      category: 'Cena',
      isRecurring: true,
      isActive: true,
    ),
    // Actividades demostrativas de la Malla (Lunes y Martes)
    const TimeAnchor(
      id: 'malla_rev_1',
      title: 'Revisión Proyecto',
      startTime: '09:00',
      endTime: '09:50',
      daysOfWeek: [1],
      category: 'Proyecto',
      isRecurring: true,
      isActive: true,
    ),
    const TimeAnchor(
      id: 'malla_call_1',
      title: 'Llamada Equipo',
      startTime: '10:00',
      endTime: '10:45',
      daysOfWeek: [1, 3],
      category: 'Reunión',
      isRecurring: true,
      isActive: true,
    ),
    const TimeAnchor(
      id: 'malla_call_2',
      title: 'Sincronización Sprint',
      startTime: '10:45',
      endTime: '11:30',
      daysOfWeek: [1],
      category: 'Reunión',
      isRecurring: true,
      isActive: true,
    ),
    const TimeAnchor(
      id: 'malla_rev_2',
      title: 'Code Review Flutter',
      startTime: '11:35',
      endTime: '12:20',
      daysOfWeek: [1, 4],
      category: 'Proyecto',
      isRecurring: true,
      isActive: true,
    ),
    const TimeAnchor(
      id: 'malla_sess_1',
      title: 'Sesión Foco Profundo',
      startTime: '12:10',
      endTime: '13:00',
      daysOfWeek: [1, 2, 4],
      category: 'Foco',
      isRecurring: true,
      isActive: true,
    ),
  ];

  /// Obtiene la lista completa de anclas horarias desde la persistencia local.
  Future<List<TimeAnchor>> getAllAnchors() async {
    final list = await _db.getAnchorObjects();
    if (list.isEmpty) {
      // Si la persistencia está vacía, sembramos los datos iniciales
      for (final item in _defaultMallaActivities) {
        await _db.insertAnchor(item);
      }
      return _defaultMallaActivities;
    }
    return list;
  }

  /// Retorna las anclas activas para un día de la semana específico (1 = Lunes ... 7 = Domingo)
  Future<List<TimeAnchor>> getAnchorsForWeekday(int weekday) async {
    final all = await getAllAnchors();
    return all.where((a) => a.appliesToWeekday(weekday)).toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
  }

  /// Inserta una nueva ancla en la persistencia local
  Future<int> insertAnchor(TimeAnchor anchor) async {
    return _db.insertAnchor(anchor);
  }

  /// Actualiza un ancla existente por su identificador
  Future<int> updateAnchor(TimeAnchor anchor) async {
    return _db.updateAnchor(anchor);
  }

  /// Elimina un ancla por su identificador
  Future<int> deleteAnchor(String id) async {
    return _db.deleteAnchor(id);
  }

  /// Conmuta el estado activo/inactivo de un ancla
  Future<int> toggleActive(String id) async {
    final all = await getAllAnchors();
    final anchor = all.firstWhere((a) => a.id == id, orElse: () => all.first);
    final updated = anchor.copyWith(isActive: !anchor.isActive);
    return _db.updateAnchor(updated);
  }

  /// Trunca la tabla local de persistencia (Tolerancia heurística a fallos)
  Future<int> deleteAll() async {
    return _db.deleteRows();
  }

  /// Restaura los presets predeterminados del sistema
  Future<List<TimeAnchor>> resetToDefaults() async {
    await _db.deleteRows();
    for (final item in _defaultMallaActivities) {
      await _db.insertAnchor(item);
    }
    return _defaultMallaActivities;
  }
}


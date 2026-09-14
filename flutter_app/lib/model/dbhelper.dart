import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/domain/models/time_anchor.dart';

/// Helper coordinador de persistencia local asíncrona para NeuroTask.
/// Implementa el Patrón de Diseño Singleton y transacciones CRUD no bloqueantes
/// según las especificaciones de la Unidad 3.1.1 de la cátedra DAM.
class DbHelper {
  static const String _tableAnchors = 'neurotask_anchors_table_v1';

  // 1. Instancia interna privada y estática única
  static final DbHelper _dbHelper = DbHelper._internal();

  // 2. Constructor privado para evitar instanciación externa directa
  DbHelper._internal();

  // 3. Factory constructor que retorna siempre la misma instancia única compartida
  factory DbHelper() {
    return _dbHelper;
  }

  /// CREATE: Inserta o agrega un ancla horaria en la persistencia local.
  /// Retorna un entero positivo (1) indicando éxito, sin bloquear el Event Loop.
  Future<int> insertAnchor(TimeAnchor anchor) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentList = await getAnchors();
      
      // Remover si ya existía con el mismo id para evitar duplicados
      currentList.removeWhere((item) => item['id'] == anchor.id);
      currentList.add(anchor.toMap());

      await prefs.setString(_tableAnchors, jsonEncode(currentList));
      return 1;
    } catch (_) {
      return 0;
    }
  }

  /// READ: Lee todos los registros y los retorna de forma asíncrona como una lista de mapas planos.
  /// Equivale a db.rawQuery("SELECT * FROM anchors") en SQLite.
  Future<List<Map<String, dynamic>>> getAnchors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_tableAnchors);
      if (raw == null || raw.trim().isEmpty) {
        // Si la tabla está vacía, sembramos los presets iniciales de forma transparente
        final defaults = TimeAnchor.initialPresets();
        final mappedDefaults = defaults.map((a) => a.toMap()).toList();
        await prefs.setString(_tableAnchors, jsonEncode(mappedDefaults));
        return mappedDefaults;
      }

      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } catch (_) {
      return TimeAnchor.initialPresets().map((a) => a.toMap()).toList();
    }
  }

  /// READ OBJECTS: Helper tipado que mapea las filas crudas a objetos Dart mediante fromObject().
  Future<List<TimeAnchor>> getAnchorObjects() async {
    final rows = await getAnchors();
    return rows.map((row) => TimeAnchor.fromObject(row)).toList();
  }

  /// UPDATE: Modifica un registro localizándolo por su identificador único.
  /// Retorna la cantidad de filas modificadas (1 si tuvo éxito, 0 si no se encontró).
  Future<int> updateAnchor(TimeAnchor anchor) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentList = await getAnchors();
      final index = currentList.indexWhere((item) => item['id'] == anchor.id);
      
      if (index == -1) return 0;
      
      currentList[index] = anchor.toMap();
      await prefs.setString(_tableAnchors, jsonEncode(currentList));
      return 1;
    } catch (_) {
      return 0;
    }
  }

  /// DELETE: Elimina un registro por su clave primaria / identificador.
  /// Retorna la cantidad de registros eliminados (1 si existía, 0 si no).
  Future<int> deleteAnchor(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentList = await getAnchors();
      final initialLength = currentList.length;
      currentList.removeWhere((item) => item['id'] == id);

      if (currentList.length == initialLength) return 0;

      await prefs.setString(_tableAnchors, jsonEncode(currentList));
      return 1;
    } catch (_) {
      return 0;
    }
  }

  /// DELETE ROWS / TRUNCATE: Método imperativo asíncrono para vaciar completamente la tabla local.
  /// Requerido por la cátedra para soporte de reseteo seguro y tolerancia heurística a fallos.
  Future<int> deleteRows() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentList = await getAnchors();
      final count = currentList.length;
      await prefs.remove(_tableAnchors);
      return count;
    } catch (_) {
      return 0;
    }
  }

  /// RESET: Restaura la tabla a los presets predeterminados de la vida universitaria.
  Future<int> resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final defaults = TimeAnchor.initialPresets();
      final mappedDefaults = defaults.map((a) => a.toMap()).toList();
      await prefs.setString(_tableAnchors, jsonEncode(mappedDefaults));
      return defaults.length;
    } catch (_) {
      return 0;
    }
  }
}

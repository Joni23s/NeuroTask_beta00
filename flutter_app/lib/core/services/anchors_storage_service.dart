import '../../model/dbhelper.dart';
import '../domain/models/time_anchor.dart';

class AnchorsStorageService {
  static final DbHelper _db = DbHelper();

  /// Carga las anclas guardadas localmente utilizando el Singleton DbHelper.
  static Future<List<TimeAnchor>> loadAnchors() async {
    return _db.getAnchorObjects();
  }

  /// Guarda la lista completa de anclas utilizando DbHelper.
  static Future<void> saveAnchors(List<TimeAnchor> anchors) async {
    await _db.deleteRows();
    for (final anchor in anchors) {
      await _db.insertAnchor(anchor);
    }
  }

  /// Restaura los presets predeterminados de la vida universitaria.
  static Future<List<TimeAnchor>> resetToDefaults() async {
    await _db.resetToDefaults();
    return _db.getAnchorObjects();
  }
}

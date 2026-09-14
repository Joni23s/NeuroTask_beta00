/// Utilidades generales de formateo de fechas y horarios para la aplicación móvil,
/// cumpliendo con el estándar arquitectónico de la cátedra (lib/util/).
class DateTimeFormatter {
  const DateTimeFormatter._();

  static const List<String> weekdaysSpanish = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  static const List<String> weekdaysShortSpanish = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];

  /// Devuelve el nombre del día en español (1 = Lunes, 7 = Domingo)
  static String formatWeekday(int weekday) {
    if (weekday < 1 || weekday > 7) return '';
    return weekdaysSpanish[weekday - 1];
  }

  /// Devuelve la abreviatura del día en español (1 = Lun, 7 = Dom)
  static String formatWeekdayShort(int weekday) {
    if (weekday < 1 || weekday > 7) return '';
    return weekdaysShortSpanish[weekday - 1];
  }

  /// Convierte minutos desde las 00:00 a formato militar/24h "HH:mm"
  static String formatMinutesTo24Hour(int totalMinutes) {
    final normalized = totalMinutes % 1440;
    final hours = normalized ~/ 60;
    final minutes = normalized % 60;
    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    return '$hStr:$mStr';
  }

  /// Formatea la duración en un texto legible y conciso ("45 min", "1 h 30 min", "2 h")
  static String formatDuration(int durationMinutes) {
    if (durationMinutes < 60) {
      return '$durationMinutes min';
    }
    final hours = durationMinutes ~/ 60;
    final remainingMinutes = durationMinutes % 60;
    if (remainingMinutes == 0) {
      return '$hours h';
    }
    return '$hours h $remainingMinutes min';
  }

  /// Formatea un rango horario con su duración (ej: "08:00 - 12:00 (4 h)")
  static String formatTimeRangeWithDuration(String startTime, String endTime, int durationMinutes) {
    return '$startTime - $endTime (${formatDuration(durationMinutes)})';
  }
}

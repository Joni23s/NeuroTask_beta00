class TimeAnchor {
  final String id;
  final String title;
  final String startTime; // "HH:mm" (ej. "08:00")
  final String endTime;   // "HH:mm" (ej. "12:00")
  final List<int> daysOfWeek; // 1 = Lunes ... 7 = Domingo. Vacío = todos los días
  final String category;  // "Facultad", "Gimnasio", "Cena", "Trabajo", "General"
  final bool isRecurring;
  final bool isActive;

  const TimeAnchor({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.daysOfWeek = const [],
    this.category = 'General',
    this.isRecurring = true,
    this.isActive = true,
  });

  /// Hora de inicio en minutos desde las 00:00 (0 a 1439)
  int get startMinutes => parseTimeToMinutes(startTime);

  /// Hora de fin en minutos desde las 00:00 (0 a 1439)
  int get endMinutes => parseTimeToMinutes(endTime);

  /// Duración total en minutos del ancla
  int get durationMinutes {
    final diff = endMinutes - startMinutes;
    return diff > 0 ? diff : (1440 - startMinutes + endMinutes);
  }

  /// Formato legible (ej: "08:00 - 12:00")
  String get formattedRange => '$startTime - $endTime';

  /// Determina si este ancla está activa para un día específico de la semana (1 = Lunes ... 7 = Domingo)
  bool appliesToWeekday(int weekday) {
    if (!isActive) return false;
    if (daysOfWeek.isEmpty) return true; // Aplica todos los días
    return daysOfWeek.contains(weekday);
  }

  TimeAnchor copyWith({
    String? id,
    String? title,
    String? startTime,
    String? endTime,
    List<int>? daysOfWeek,
    String? category,
    bool? isRecurring,
    bool? isActive,
  }) {
    return TimeAnchor(
      id: id ?? this.id,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      category: category ?? this.category,
      isRecurring: isRecurring ?? this.isRecurring,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startTime': startTime,
      'endTime': endTime,
      'daysOfWeek': daysOfWeek,
      'category': category,
      'isRecurring': isRecurring,
      'isActive': isActive,
    };
  }

  factory TimeAnchor.fromJson(Map<String, dynamic> json) {
    return TimeAnchor(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Ancla horaria',
      startTime: json['startTime'] as String? ?? '08:00',
      endTime: json['endTime'] as String? ?? '09:00',
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
      category: json['category'] as String? ?? 'General',
      isRecurring: json['isRecurring'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  static int parseTimeToMinutes(String time) {
    try {
      final parts = time.split(':');
      final hours = int.parse(parts[0].trim());
      final minutes = int.parse(parts[1].trim());
      return hours * 60 + minutes;
    } catch (_) {
      return 0;
    }
  }

  static String minutesToTimeString(int totalMinutes) {
    final normalized = totalMinutes % 1440;
    final hours = normalized ~/ 60;
    final minutes = normalized % 60;
    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    return '$hStr:$mStr';
  }

  /// Catálogo de anclas iniciales representativas para la vida académica/universitaria
  static List<TimeAnchor> initialPresets() {
    return const [
      TimeAnchor(
        id: 'anchor_facultad',
        title: 'Facultad DAM (UNCuyo)',
        startTime: '08:00',
        endTime: '12:00',
        daysOfWeek: [1, 2, 3, 4, 5],
        category: 'Facultad',
        isRecurring: true,
        isActive: true,
      ),
      TimeAnchor(
        id: 'anchor_gym',
        title: 'Gimnasio / Deporte',
        startTime: '17:30',
        endTime: '19:30',
        daysOfWeek: [1, 3, 5],
        category: 'Gimnasio',
        isRecurring: true,
        isActive: true,
      ),
      TimeAnchor(
        id: 'anchor_cena',
        title: 'Cena y Desconexión',
        startTime: '22:00',
        endTime: '23:30',
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
        category: 'Cena',
        isRecurring: true,
        isActive: true,
      ),
    ];
  }
}

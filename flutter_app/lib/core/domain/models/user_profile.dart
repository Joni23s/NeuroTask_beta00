/// Modelo de perfil de usuario de NeuroTask.
/// Entidad principal que representa al usuario autenticado con sus métricas
/// de productividad acumuladas, siguiendo el patrón de modelado tipado
/// de la Unidad 3.1.1 de la cátedra DAM.
class UserProfile {
  final String? id;
  final String name;
  final String email;
  final String avatarUrl;
  final DateTime createdAt;
  final int totalTasksCompleted;
  final int totalFocusMinutes;
  final int currentStreak; // Días consecutivos usando la app
  final int level;
  final String levelTitle;

  const UserProfile({
    this.id,
    required this.name,
    required this.email,
    this.avatarUrl = '',
    required this.createdAt,
    this.totalTasksCompleted = 0,
    this.totalFocusMinutes = 0,
    this.currentStreak = 0,
    this.level = 1,
    this.levelTitle = 'Aprendiz del Foco',
  });

  /// Constructor nombrado para instancias existentes leídas desde persistencia local,
  /// garantizando la integridad referencial del identificador único.
  const UserProfile.withId({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl = '',
    required this.createdAt,
    this.totalTasksCompleted = 0,
    this.totalFocusMinutes = 0,
    this.currentStreak = 0,
    this.level = 1,
    this.levelTitle = 'Aprendiz del Foco',
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
    int? totalTasksCompleted,
    int? totalFocusMinutes,
    int? currentStreak,
    int? level,
    String? levelTitle,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      totalTasksCompleted: totalTasksCompleted ?? this.totalTasksCompleted,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      currentStreak: currentStreak ?? this.currentStreak,
      level: level ?? this.level,
      levelTitle: levelTitle ?? this.levelTitle,
    );
  }

  /// Serialización relacional plana toMap() según la especificación de la cátedra (Unidad 3.1.1).
  /// Convierte la instancia tipada en un Map<String, dynamic> para persistencia local.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['email'] = email;
    map['avatarUrl'] = avatarUrl;
    map['createdAt'] = createdAt.toIso8601String();
    map['totalTasksCompleted'] = totalTasksCompleted;
    map['totalFocusMinutes'] = totalFocusMinutes;
    map['currentStreak'] = currentStreak;
    map['level'] = level;
    map['levelTitle'] = levelTitle;
    return map;
  }

  /// Deserialización fromObject(dynamic o) según la especificación de la cátedra (Unidad 3.1.1).
  /// Reconstruye un objeto tipado UserProfile desde un mapa genérico retornado por persistencia.
  factory UserProfile.fromObject(dynamic o) {
    if (o is Map<String, dynamic>) {
      return UserProfile.withId(
        id: o['id'] as String?,
        name: o['name'] as String? ?? 'Usuario NeuroTask',
        email: o['email'] as String? ?? '',
        avatarUrl: o['avatarUrl'] as String? ?? '',
        createdAt: o['createdAt'] != null
            ? DateTime.tryParse(o['createdAt'] as String) ?? DateTime.now()
            : DateTime.now(),
        totalTasksCompleted: (o['totalTasksCompleted'] as num?)?.toInt() ?? 0,
        totalFocusMinutes: (o['totalFocusMinutes'] as num?)?.toInt() ?? 0,
        currentStreak: (o['currentStreak'] as num?)?.toInt() ?? 0,
        level: (o['level'] as num?)?.toInt() ?? 1,
        levelTitle: o['levelTitle'] as String? ?? 'Aprendiz del Foco',
      );
    } else if (o is Map) {
      return UserProfile.fromObject(Map<String, dynamic>.from(o));
    }
    throw ArgumentError('El objeto a deserializar debe ser un Map');
  }

  /// Formato legible de horas de foco acumuladas (ej: "6.2 h")
  String get formattedFocusHours {
    final hours = totalFocusMinutes / 60.0;
    return '${hours.toStringAsFixed(1)} h';
  }
}


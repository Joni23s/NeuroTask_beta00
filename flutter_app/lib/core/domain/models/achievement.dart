enum AchievementCategory {
  foco,
  resiliencia,
  calma,
  exploracion,
  maestria,
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final AchievementCategory category;
  final DateTime? unlockedAt;
  final String rewardInsight;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.category,
    this.unlockedAt,
    required this.rewardInsight,
  });

  bool get isUnlocked => unlockedAt != null;

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? iconEmoji,
    AchievementCategory? category,
    DateTime? unlockedAt,
    String? rewardInsight,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      category: category ?? this.category,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rewardInsight: rewardInsight ?? this.rewardInsight,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconEmoji': iconEmoji,
      'category': category.name,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'rewardInsight': rewardInsight,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconEmoji: json['iconEmoji'] as String? ?? '🏆',
      category: AchievementCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => AchievementCategory.foco,
      ),
      unlockedAt: json['unlockedAt'] != null ? DateTime.tryParse(json['unlockedAt'] as String) : null,
      rewardInsight: json['rewardInsight'] as String? ?? '¡Gran hito alcanzado!',
    );
  }

  /// Initial catalog of the 10 core neuro-adaptive achievements
  static List<Achievement> initialCatalog() {
    return const [
      Achievement(
        id: 'first_brain_dump',
        title: 'Descompresión Inicial',
        description: 'Vaciá tu mente y estructurá tu primer volcado de ideas en un camino lógico.',
        iconEmoji: '🧠',
        category: AchievementCategory.exploracion,
        rewardInsight: 'Venciste la inercia mental: sacar las ideas de la cabeza es el 50% de la victoria.',
      ),
      Achievement(
        id: 'first_flow_completed',
        title: 'Paso a Paso',
        description: 'Completá una sesión de foco entera de inicio a fin al 100%.',
        iconEmoji: '🏆',
        category: AchievementCategory.foco,
        rewardInsight: 'Demostraste que aislando las tareas 1 a 1, la parálisis desaparece.',
      ),
      Achievement(
        id: 'hyperfocus_ray',
        title: 'Rayo de Hiperfoco',
        description: 'Terminá un flujo antes del tiempo estimado y ganá minutos de libertad.',
        iconEmoji: '⚡',
        category: AchievementCategory.foco,
        rewardInsight: '¡Modo hiperfoco activo! Rompiste la creencia de que la tarea era pesada.',
      ),
      Achievement(
        id: 'resilience_champion',
        title: 'Campeón de Resiliencia',
        description: 'Persistí y completá un flujo aunque requiera más tiempo de lo previsto.',
        iconEmoji: '🌱',
        category: AchievementCategory.resiliencia,
        rewardInsight: 'No abandonaste ante la fricción. La constancia serena vale el doble.',
      ),
      Achievement(
        id: 'rescue_master',
        title: 'Rescate Inteligente',
        description: 'Activá el modo rescate de micro-pasos o baja energía para destrabarte.',
        iconEmoji: '🛡️',
        category: AchievementCategory.resiliencia,
        rewardInsight: 'Pedir ayuda o bajar la exigencia a micro-pasos de 3m es una estrategia de genios.',
      ),
      Achievement(
        id: 'night_guardian',
        title: 'Guardián Nocturno',
        description: 'Completá una sesión utilizando el Modo Oscuro (Dark Soft Slate).',
        iconEmoji: '🌙',
        category: AchievementCategory.calma,
        rewardInsight: 'Protegiste tu energía visual con un entorno sereno y sin deslumbramiento.',
      ),
      Achievement(
        id: 'sensory_bubble',
        title: 'Burbuja Sensorial',
        description: 'Enfocate en tus tareas escuchando Ruido Marrón ambiental.',
        iconEmoji: '🌧️',
        category: AchievementCategory.calma,
        rewardInsight: 'El ruido marrón enmascara el caos auditivo externo y calma la inquietud interna.',
      ),
      Achievement(
        id: 'voice_thinker',
        title: 'Voz y Pensamiento',
        description: 'Realizá un volcado de ideas utilizando el dictado por voz.',
        iconEmoji: '🎙️',
        category: AchievementCategory.exploracion,
        rewardInsight: 'Fluidez sin teclado: hablar en voz alta desbloquea la función ejecutiva.',
      ),
      Achievement(
        id: 'trilogy_flow',
        title: 'Trilogía Serena',
        description: 'Conquistá 3 sesiones completas de tareas sin sobrecarga.',
        iconEmoji: '💎',
        category: AchievementCategory.maestria,
        rewardInsight: 'Construiste un hábito de foco sostenible y respetuoso con tu cerebro.',
      ),
      Achievement(
        id: 'neuro_master',
        title: 'Cerebro NeuroTask',
        description: 'Desbloqueá 5 o más logros cognitivos en la aplicación.',
        iconEmoji: '👑',
        category: AchievementCategory.maestria,
        rewardInsight: 'Sos un maestro de tu atención: dominás la descompresión y el flujo sereno.',
      ),
    ];
  }
}

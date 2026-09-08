enum EnergyLevel {
  low,
  medium,
  high,
}

class TaskNode {
  final String id;
  final String title;
  final String category;
  final String subtext;
  final int estimatedMinutes;
  final EnergyLevel energyLevel;
  final List<String> dependencies;
  final bool isCompleted;
  final bool isAtomicSubstep;
  final String? scheduledStartTime; // "HH:mm" (ej. "14:00")
  final String? scheduledEndTime;   // "HH:mm" (ej. "15:30")

  const TaskNode({
    required this.id,
    required this.title,
    required this.category,
    required this.subtext,
    this.estimatedMinutes = 15,
    this.energyLevel = EnergyLevel.medium,
    this.dependencies = const [],
    this.isCompleted = false,
    this.isAtomicSubstep = false,
    this.scheduledStartTime,
    this.scheduledEndTime,
  });

  TaskNode copyWith({
    String? id,
    String? title,
    String? category,
    String? subtext,
    int? estimatedMinutes,
    EnergyLevel? energyLevel,
    List<String>? dependencies,
    bool? isCompleted,
    bool? isAtomicSubstep,
    String? scheduledStartTime,
    String? scheduledEndTime,
  }) {
    return TaskNode(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      subtext: subtext ?? this.subtext,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      energyLevel: energyLevel ?? this.energyLevel,
      dependencies: dependencies ?? this.dependencies,
      isCompleted: isCompleted ?? this.isCompleted,
      isAtomicSubstep: isAtomicSubstep ?? this.isAtomicSubstep,
      scheduledStartTime: scheduledStartTime ?? this.scheduledStartTime,
      scheduledEndTime: scheduledEndTime ?? this.scheduledEndTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'subtext': subtext,
      'estimatedMinutes': estimatedMinutes,
      'energyLevel': energyLevel.index,
      'dependencies': dependencies,
      'isCompleted': isCompleted,
      'isAtomicSubstep': isAtomicSubstep,
      'scheduledStartTime': scheduledStartTime,
      'scheduledEndTime': scheduledEndTime,
    };
  }

  factory TaskNode.fromJson(Map<String, dynamic> json) {
    return TaskNode(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      subtext: json['subtext'] as String,
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt() ?? 15,
      energyLevel: EnergyLevel.values[(json['energyLevel'] as num?)?.toInt() ?? 1],
      dependencies: (json['dependencies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      isAtomicSubstep: json['isAtomicSubstep'] as bool? ?? false,
      scheduledStartTime: json['scheduledStartTime'] as String?,
      scheduledEndTime: json['scheduledEndTime'] as String?,
    );
  }
}

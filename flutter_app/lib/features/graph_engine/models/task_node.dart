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
    );
  }
}

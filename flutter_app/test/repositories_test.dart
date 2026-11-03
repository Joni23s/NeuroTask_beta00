import 'package:neurotask/core/domain/models/user_profile.dart';
import 'package:neurotask/data/repositories/task_repository.dart';
import 'package:neurotask/data/repositories/anchor_repository.dart';

void main() async {
  print('--- TEST 1: UserProfile Serialization & Named Constructors ---');
  final user = UserProfile.withId(
    id: 'test_user_01',
    name: 'Agustín Belardinelli',
    email: 'test@itu.uncuyo.edu.ar',
    createdAt: DateTime(2026, 3, 1),
    totalTasksCompleted: 24,
    totalFocusMinutes: 372,
    currentStreak: 5,
    level: 3,
    levelTitle: 'Maestro del Foco',
  );

  final map = user.toMap();
  assert(map['id'] == 'test_user_01', 'User ID must match in map');
  assert(map['name'] == 'Agustín Belardinelli', 'User name must match in map');
  assert(map['totalTasksCompleted'] == 24, 'Tasks completed must match in map');

  final restoredUser = UserProfile.fromObject(map);
  assert(restoredUser.id == user.id, 'Restored User ID must match');
  assert(restoredUser.formattedFocusHours == '6.2 h',
      'Formatted focus hours must be 6.2 h');
  print('✓ UserProfile toMap() and fromObject() OK');

  print('--- TEST 2: TaskRepository Data & Presets ---');
  final taskRepo = TaskRepository();
  final presets = await taskRepo.getBrainDumpPresets();
  assert(presets.containsKey('dam'), 'Presets must include dam');
  assert(presets.containsKey('flutter'), 'Presets must include flutter');
  print('✓ TaskRepository presets OK: ${presets.keys.toList()}');

  final initialGraph = await taskRepo.getInitialTaskGraph();
  assert(initialGraph.nodes.isNotEmpty, 'Initial task graph must not be empty');
  print(
      '✓ TaskRepository initial graph OK: ${initialGraph.nodes.length} nodes');

  print('--- TEST 3: AnchorRepository Activities & Days ---');
  final anchorRepo = AnchorRepository();
  final mondayAnchors = await anchorRepo.getAnchorsForWeekday(1); // Lunes
  assert(mondayAnchors.isNotEmpty, 'Monday anchors must not be empty');
  print(
      '✓ AnchorRepository Monday activities OK: ${mondayAnchors.length} activities');

  print('========================================');
  print('ALL REPOSITORY & DATA LAYER TESTS PASSED! 100%');
  print('========================================');
}

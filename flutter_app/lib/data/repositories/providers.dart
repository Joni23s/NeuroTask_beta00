import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/models/achievement.dart';
import '../../core/domain/models/user_profile.dart';
import 'achievement_repository.dart';
import 'anchor_repository.dart';
import 'task_repository.dart';
import 'user_repository.dart';

/// Inyección de dependencias para la Capa de Datos (Repositories) con Riverpod.
///
/// Permite que cualquier controlador o widget consuma los repositorios
/// desacoplados de la implementación física subyacente.

/// Proveedor del repositorio de tareas y grafos
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

/// Proveedor del repositorio de anclas horarias y malla temporal
final anchorRepositoryProvider = Provider<AnchorRepository>((ref) {
  return AnchorRepository();
});

/// Proveedor del repositorio de usuario y métricas
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

/// Proveedor del repositorio de logros cognitivos
final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return AchievementRepository();
});

/// Provider reactivo para consultar el perfil del usuario actual
final currentUserProfileProvider = FutureProvider<UserProfile>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getCurrentUser();
});

/// Provider reactivo para consultar los logros del usuario
final userAchievementsListProvider = FutureProvider<List<Achievement>>((ref) async {
  final repo = ref.watch(achievementRepositoryProvider);
  return repo.getAllAchievements();
});


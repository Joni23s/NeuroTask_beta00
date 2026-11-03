import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/domain/models/user_profile.dart';

/// Repositorio de Perfil de Usuario y Autenticación (Capa de Datos).
///
/// Centraliza la gestión de la entidad [UserProfile], eliminando las métricas
/// estáticas hardcodeadas en [ProfileScreen] y la lógica vacía en [LoginRegisterScreen].
/// Sigue las especificaciones de la Unidad 3.1.1 de la cátedra DAM (Tema 1).
class UserRepository {
  static const String _keyUserProfile = 'neurotask_user_profile_v1';
  static const String _keyIsLoggedIn = 'neurotask_is_logged_in_v1';

  // Datos iniciales de prueba (Mocks dinámicos representativos de un estudiante DAM)
  static final Map<String, dynamic> _defaultUserData = {
    'id': 'usr_itu_2026',
    'name': 'Agustín Belardinelli',
    'email': 'estudiante.dam@itu.uncuyo.edu.ar',
    'avatarUrl': '',
    'createdAt': DateTime(2026, 3, 1).toIso8601String(),
    'totalTasksCompleted': 24,
    'totalFocusMinutes': 372, // 6.2 horas de foco acumuladas
    'currentStreak': 5, // 5 días consecutivos
    'level': 3,
    'levelTitle': 'Maestro del Foco',
  };

  /// Obtiene el perfil de usuario actual de forma asíncrona.
  Future<UserProfile> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_keyUserProfile);
      if (raw != null && raw.isNotEmpty) {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        return UserProfile.fromObject(map);
      }
    } catch (_) {
      // Retornar fallback seguro ante fallos
    }
    return UserProfile.fromObject(_defaultUserData);
  }

  /// Guarda y actualiza el perfil en la persistencia local.
  Future<UserProfile> updateProfile(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserProfile, jsonEncode(profile.toMap()));
    } catch (_) {}
    return profile;
  }

  /// Incrementa métricas de productividad tras completar una tarea o sesión de foco.
  Future<UserProfile> recordTaskCompletion({int minutes = 15}) async {
    final current = await getCurrentUser();
    final updatedCompleted = current.totalTasksCompleted + 1;
    final updatedMinutes = current.totalFocusMinutes + minutes;

    // Cálculo dinámico de nivel según tareas completadas
    int newLevel = current.level;
    String newTitle = current.levelTitle;
    if (updatedCompleted >= 30) {
      newLevel = 4;
      newTitle = 'Arquitecto de Atención';
    } else if (updatedCompleted >= 20) {
      newLevel = 3;
      newTitle = 'Maestro del Foco';
    } else if (updatedCompleted >= 10) {
      newLevel = 2;
      newTitle = 'Practicante Resiliente';
    }

    final updated = current.copyWith(
      totalTasksCompleted: updatedCompleted,
      totalFocusMinutes: updatedMinutes,
      level: newLevel,
      levelTitle: newTitle,
    );

    await updateProfile(updated);
    return updated;
  }

  /// Autenticación simulada (login)
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (email.trim().isEmpty || password.trim().isEmpty) return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);

    // Actualizar el email en el perfil
    final current = await getCurrentUser();
    await updateProfile(current.copyWith(email: email.trim()));
    return true;
  }

  /// Registro simulado
  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      return false;
    }

    final newUser = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim(),
      createdAt: DateTime.now(),
      totalTasksCompleted: 0,
      totalFocusMinutes: 0,
      currentStreak: 1,
      level: 1,
      levelTitle: 'Aprendiz del Foco',
    );

    await updateProfile(newUser);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    return true;
  }

  /// Verifica si existe una sesión abierta
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? true; // Default true para prototipo ágil
  }

  /// Cierre de sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}


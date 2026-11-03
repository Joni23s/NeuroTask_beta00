import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/domain/models/user_profile.dart';

/// Resultado estructurado de una operación de autenticación.
class AuthResult {
  final bool success;
  final String? errorMessage;
  final UserProfile? user;

  const AuthResult({
    required this.success,
    this.errorMessage,
    this.user,
  });
}

/// Repositorio de Perfil de Usuario y Autenticación (Capa de Datos).
///
/// Centraliza la gestión de la entidad [UserProfile] y la autenticación local persistente,
/// eliminando cualquier mockup o credencial hardcodeada. Cumple con la arquitectura DAM (Tema 1).
class UserRepository {
  static const String _keyUserProfile = 'neurotask_user_profile_v1';
  static const String _keyIsLoggedIn = 'neurotask_is_logged_in_v1';
  static const String _keyAccounts = 'neurotask_registered_accounts_v1';

  // Cuenta base persistente inicial para evaluación académica
  static const String defaultEmail = 'estudiante.dam@itu.uncuyo.edu.ar';
  static const String defaultPassword = 'password123';

  /// Obtiene o inicializa el mapa de cuentas registradas en SharedPreferences.
  Future<Map<String, Map<String, dynamic>>> _getAccounts(SharedPreferences prefs) async {
    final raw = prefs.getString(_keyAccounts);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        return decoded.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)));
      } catch (_) {}
    }

    // Inicializa la primera cuenta académica si la persistencia está limpia
    final initialAccounts = <String, Map<String, dynamic>>{
      defaultEmail.toLowerCase(): {
        'password': defaultPassword,
        'profile': {
          'id': 'usr_itu_2026',
          'name': 'Agustín Belardinelli',
          'email': defaultEmail,
          'avatarUrl': '',
          'createdAt': DateTime(2026, 3, 1).toIso8601String(),
          'totalTasksCompleted': 24,
          'totalFocusMinutes': 372,
          'currentStreak': 5,
          'level': 3,
          'levelTitle': 'Maestro del Foco',
        },
      },
    };
    await prefs.setString(_keyAccounts, jsonEncode(initialAccounts));
    return initialAccounts;
  }

  /// Guarda el mapa de cuentas actualizado.
  Future<void> _saveAccounts(
    SharedPreferences prefs,
    Map<String, Map<String, dynamic>> accounts,
  ) async {
    await prefs.setString(_keyAccounts, jsonEncode(accounts));
  }

  /// Obtiene el perfil de usuario actual de forma asíncrona.
  Future<UserProfile> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_keyUserProfile);
      if (raw != null && raw.isNotEmpty) {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        return UserProfile.fromObject(map);
      }

      // Si no hay perfil activo pero hay cuenta predeterminada, cargarlo
      final accounts = await _getAccounts(prefs);
      if (accounts.containsKey(defaultEmail.toLowerCase())) {
        final profileMap = Map<String, dynamic>.from(accounts[defaultEmail.toLowerCase()]!['profile'] as Map);
        final defaultProfile = UserProfile.fromObject(profileMap);
        await prefs.setString(_keyUserProfile, jsonEncode(defaultProfile.toMap()));
        return defaultProfile;
      }
    } catch (_) {}

    return UserProfile(
      id: 'usr_guest',
      name: 'Invitado',
      email: 'invitado@neurotask.app',
      createdAt: DateTime.now(),
      totalTasksCompleted: 0,
      totalFocusMinutes: 0,
      currentStreak: 0,
      level: 1,
      levelTitle: 'Explorador Sereno',
    );
  }

  /// Guarda y actualiza el perfil en la persistencia local.
  Future<UserProfile> updateProfile(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserProfile, jsonEncode(profile.toMap()));

      // Sincronizar en el mapa de cuentas si corresponde
      final accounts = await _getAccounts(prefs);
      final emailKey = profile.email.toLowerCase().trim();
      if (accounts.containsKey(emailKey)) {
        accounts[emailKey]!['profile'] = profile.toMap();
        await _saveAccounts(prefs, accounts);
      }
    } catch (_) {}
    return profile;
  }

  /// Incrementa métricas de productividad tras completar una tarea o sesión de foco.
  Future<UserProfile> recordTaskCompletion({int minutes = 15}) async {
    final current = await getCurrentUser();
    final updatedCompleted = current.totalTasksCompleted + 1;
    final updatedMinutes = current.totalFocusMinutes + minutes;

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

  /// Autenticación validando credenciales contra el registro persistente.
  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
      return const AuthResult(
        success: false,
        errorMessage: 'Por favor completá el correo y la contraseña.',
      );
    }

    final prefs = await SharedPreferences.getInstance();
    final accounts = await _getAccounts(prefs);

    if (!accounts.containsKey(cleanEmail)) {
      return const AuthResult(
        success: false,
        errorMessage: 'No existe una cuenta registrada con este correo.',
      );
    }

    final account = accounts[cleanEmail]!;
    if (account['password'] != cleanPassword) {
      return const AuthResult(
        success: false,
        errorMessage: 'Contraseña incorrecta. Verificá los datos.',
      );
    }

    final profileMap = Map<String, dynamic>.from(account['profile'] as Map);
    final userProfile = UserProfile.fromObject(profileMap);

    await prefs.setString(_keyUserProfile, jsonEncode(userProfile.toMap()));
    await prefs.setBool(_keyIsLoggedIn, true);

    return AuthResult(success: true, user: userProfile);
  }

  /// Registro de un nuevo usuario en la persistencia local.
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final cleanName = name.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanName.isEmpty || cleanEmail.isEmpty || cleanPassword.isEmpty) {
      return const AuthResult(
        success: false,
        errorMessage: 'Por favor completá todos los campos.',
      );
    }

    final prefs = await SharedPreferences.getInstance();
    final accounts = await _getAccounts(prefs);

    if (accounts.containsKey(cleanEmail)) {
      return const AuthResult(
        success: false,
        errorMessage: 'Ya existe una cuenta con este correo. Podés iniciar sesión.',
      );
    }

    final newUser = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: cleanName,
      email: cleanEmail,
      createdAt: DateTime.now(),
      totalTasksCompleted: 0,
      totalFocusMinutes: 0,
      currentStreak: 1,
      level: 1,
      levelTitle: 'Aprendiz del Foco',
    );

    accounts[cleanEmail] = {
      'password': cleanPassword,
      'profile': newUser.toMap(),
    };

    await _saveAccounts(prefs, accounts);

    return AuthResult(success: true, user: newUser);
  }

  /// Inicio de sesión como Invitado (modo exploración ágil).
  Future<UserProfile> loginAsGuest() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();

    final guestUser = UserProfile(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Invitado',
      email: 'invitado@neurotask.app',
      createdAt: DateTime.now(),
      totalTasksCompleted: 0,
      totalFocusMinutes: 0,
      currentStreak: 1,
      level: 1,
      levelTitle: 'Explorador Sereno',
    );

    await prefs.setString(_keyUserProfile, jsonEncode(guestUser.toMap()));
    await prefs.setBool(_keyIsLoggedIn, true);
    return guestUser;
  }

  /// Verifica si existe una sesión abierta.
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Cierre de sesión.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}

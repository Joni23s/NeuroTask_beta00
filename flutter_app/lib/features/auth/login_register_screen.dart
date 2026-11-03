import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/neumorphic_card.dart';
import '../../core/widgets/neuro_inset_container.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/user_repository.dart';
import '../onboarding/welcome_screen.dart';

/// Pantalla de Login/Registro con estética neumórfica, validación activa y conexión al [UserRepository].
class LoginRegisterScreen extends ConsumerStatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  ConsumerState<LoginRegisterScreen> createState() =>
      _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends ConsumerState<LoginRegisterScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  String? _successMessage;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  /// Valida las entradas del usuario antes de proceder a la autenticación.
  bool _validateInputs() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (!_isLogin) {
      if (name.isEmpty) {
        setState(() => _errorMessage = 'Por favor ingresá tu nombre completo.');
        return false;
      }
      if (name.length < 2) {
        setState(() => _errorMessage = 'El nombre debe tener al menos 2 caracteres.');
        return false;
      }
    }

    if (email.isEmpty) {
      setState(() => _errorMessage = 'Por favor ingresá tu correo electrónico.');
      return false;
    }

    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _errorMessage = 'Ingresá un correo electrónico válido (ej: nombre@correo.com).');
      return false;
    }

    if (password.isEmpty) {
      setState(() => _errorMessage = 'Por favor ingresá tu contraseña.');
      return false;
    }

    if (password.length < 6) {
      setState(() => _errorMessage = 'La contraseña debe tener al menos 6 caracteres.');
      return false;
    }

    return true;
  }

  /// Maneja el flujo de Inicio de Sesión o Registro validado.
  Future<void> _onAuthenticate() async {
    HapticHelper.mediumImpact();
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    if (!_validateInputs()) {
      HapticHelper.lightTap();
      return;
    }

    setState(() => _isLoading = true);

    final userRepo = ref.read(userRepositoryProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (_isLogin) {
      final result = await userRepo.login(email, password);
      if (!result.success) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = result.errorMessage ?? 'Error al iniciar sesión.';
          });
          HapticHelper.lightTap();
        }
        return;
      }

      ref.invalidate(currentUserProfileProvider);

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    } else {
      final result = await userRepo.register(
        name: name,
        email: email,
        password: password,
      );
      if (!result.success) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = result.errorMessage ?? 'Error al registrar la cuenta.';
          });
          HapticHelper.lightTap();
        }
        return;
      }

      // Registro exitoso: cambiamos al tab Iniciar Sesión con las credenciales auto-completadas
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLogin = true;
          _errorMessage = null;
          _successMessage = '¡Bienvenido/a, $name! Tu cuenta fue creada con éxito. Presioná "Ingresar a NeuroTask" para comenzar.';
          _nameController.clear();
        });
        HapticHelper.mediumImpact();
      }
    }
  }

  /// Flujo independiente para ingresar como Invitado de evaluación.
  Future<void> _onGuestLogin() async {
    HapticHelper.mediumImpact();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final userRepo = ref.read(userRepositoryProvider);
    await userRepo.loginAsGuest();

    ref.invalidate(currentUserProfileProvider);

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Brand Icon
              const Center(
                child: NeumorphicCard(
                  padding: EdgeInsets.all(20),
                  borderRadius: 24,
                  child: Icon(
                    Icons.psychology_rounded,
                    size: 54,
                    color: AppColors.primaryIndigo,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Header
              Text(
                _isLogin ? '¡Hola de nuevo!' : 'Crear tu cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: context.textMainColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLogin
                    ? 'Ingresá para continuar tu camino de foco sereno.'
                    : 'Personalizá tu experiencia y cuidá tu atención.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: context.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 28),

              // Tab Switcher (Login / Register)
              NeumorphicCard(
                padding: const EdgeInsets.all(4),
                borderRadius: 16,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticHelper.lightTap();
                          setState(() {
                            _isLogin = true;
                            _errorMessage = null;
                            _successMessage = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isLogin
                                ? context.surfaceColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _isLogin
                                ? [
                                    BoxShadow(
                                      color: context.isDarkMode
                                          ? AppColors.darkShadowDark
                                              .withValues(alpha: 0.3)
                                          : AppColors.shadowDark
                                              .withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Text(
                            'Iniciar Sesión',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight:
                                  _isLogin ? FontWeight.bold : FontWeight.w500,
                              color: _isLogin
                                  ? AppColors.primaryIndigo
                                  : context.textSecondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticHelper.lightTap();
                          setState(() {
                            _isLogin = false;
                            _errorMessage = null;
                            _successMessage = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isLogin
                                ? context.surfaceColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: !_isLogin
                                ? [
                                    BoxShadow(
                                      color: context.isDarkMode
                                          ? AppColors.darkShadowDark
                                              .withValues(alpha: 0.3)
                                          : AppColors.shadowDark
                                              .withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Text(
                            'Registrarse',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight:
                                  !_isLogin ? FontWeight.bold : FontWeight.w500,
                              color: !_isLogin
                                  ? AppColors.primaryIndigo
                                  : context.textSecondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Banner de Éxito Visual
              if (_successMessage != null) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.successEmerald.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.successEmerald.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.successEmerald,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _successMessage!,
                          style: TextStyle(
                            color: context.isDarkMode
                                ? AppColors.successEmerald
                                : AppColors.successEmeraldDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Banner de Error Visual
              if (_errorMessage != null) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Color(0xFFEF4444),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Campo Nombre (Solo registro)
              if (!_isLogin) ...[
                Text(
                  'Nombre completo',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textMainColor,
                  ),
                ),
                const SizedBox(height: 8),
                NeuroInsetContainer(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  borderRadius: 14,
                  child: Center(
                    child: TextField(
                      controller: _nameController,
                      onChanged: (_) {
                        if (_errorMessage != null || _successMessage != null) {
                          setState(() {
                            _errorMessage = null;
                            _successMessage = null;
                          });
                        }
                      },
                      style:
                          TextStyle(color: context.textMainColor, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Tu nombre completo',
                        hintStyle: TextStyle(
                            color: context.textMutedColor, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Campo Email
              Text(
                'Correo Electrónico',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textMainColor,
                ),
              ),
              const SizedBox(height: 8),
              NeuroInsetContainer(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                borderRadius: 14,
                child: Center(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) {
                      if (_errorMessage != null || _successMessage != null) {
                        setState(() {
                          _errorMessage = null;
                          _successMessage = null;
                        });
                      }
                    },
                    style:
                        TextStyle(color: context.textMainColor, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'ejemplo@correo.com',
                      hintStyle: TextStyle(
                          color: context.textMutedColor, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Campo Contraseña
              Text(
                'Contraseña',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textMainColor,
                ),
              ),
              const SizedBox(height: 8),
              NeuroInsetContainer(
                height: 48,
                padding: const EdgeInsets.only(left: 16, right: 6),
                borderRadius: 14,
                child: Center(
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: (_) {
                      if (_errorMessage != null || _successMessage != null) {
                        setState(() {
                          _errorMessage = null;
                          _successMessage = null;
                        });
                      }
                    },
                    style:
                        TextStyle(color: context.textMainColor, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Mínimo 6 caracteres',
                      hintStyle: TextStyle(
                          color: context.textMutedColor, fontSize: 14),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: context.textMutedColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 28),

              // Botón Principal (Ingresar / Registrarse)
              SizedBox(
                height: 52,
                child: NeumorphicButton(
                  onPressed: _isLoading ? () {} : _onAuthenticate,
                  variant: NeumorphicButtonVariant.primary,
                  child: _isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Text(
                          _isLogin ? 'Ingresar a NeuroTask' : 'Crear mi Cuenta',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Separador "o bien"
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: context.textMutedColor.withValues(alpha: 0.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'o bien',
                      style: TextStyle(
                          fontSize: 12, color: context.textMutedColor),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: context.textMutedColor.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Botón de Invitado (Flujo Independiente)
              SizedBox(
                height: 50,
                child: NeumorphicButton(
                  onPressed: _isLoading ? () {} : _onGuestLogin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.face_5_outlined,
                          color: context.textMainColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Continuar como Invitado',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.textMainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

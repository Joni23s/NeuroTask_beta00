import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/neumorphic_card.dart';
import '../../core/widgets/neuro_inset_container.dart';
import '../../data/repositories/providers.dart';
import '../onboarding/welcome_screen.dart';

/// Pantalla de Login/Registro con estética neumórfica y conexión al [UserRepository].
class LoginRegisterScreen extends ConsumerStatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  ConsumerState<LoginRegisterScreen> createState() =>
      _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends ConsumerState<LoginRegisterScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
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

  Future<void> _onAuthenticate() async {
    HapticHelper.mediumImpact();
    setState(() => _isLoading = true);

    final userRepo = ref.read(userRepositoryProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (_isLogin) {
      final success = await userRepo.login(
        email.isNotEmpty ? email : 'estudiante.dam@itu.uncuyo.edu.ar',
        password.isNotEmpty ? password : 'demo',
      );
      if (!success && mounted) {
        setState(() => _isLoading = false);
        return;
      }
    } else {
      await userRepo.register(
        name.isNotEmpty ? name : 'Estudiante DAM',
        email.isNotEmpty ? email : 'estudiante@itu.uncuyo.edu.ar',
        password.isNotEmpty ? password : 'demo',
      );
    }

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
              const SizedBox(height: 20),
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
              const SizedBox(height: 32),

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
                          setState(() => _isLogin = true);
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
                          setState(() => _isLogin = false);
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

              const SizedBox(height: 24),

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
                      style:
                          TextStyle(color: context.textMainColor, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Tu nombre o apodo',
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                borderRadius: 14,
                child: Center(
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style:
                        TextStyle(color: context.textMainColor, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: TextStyle(
                          color: context.textMutedColor, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Botón Principal
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

              // Separador o acceso directo como invitado
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

              // Botón de Invitado
              SizedBox(
                height: 50,
                child: NeumorphicButton(
                  onPressed: _onAuthenticate,
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

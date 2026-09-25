import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/neumorphic_card.dart';
import '../../core/widgets/neuro_inset_container.dart';
import '../onboarding/welcome_screen.dart';

/// Pantalla estática de Login/Registro con estética neumórfica para el prototipo.
class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  bool _isLogin = true;
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

  void _onAuthenticate() {
    HapticHelper.mediumImpact();
    // Navega al flujo principal (WelcomeScreen / Home)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
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
              Center(
                child: NeumorphicCard(
                  padding: const EdgeInsets.all(20),
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
                    ? 'Ingresá para continuar despejando tu mente'
                    : 'Unite a NeuroTask y reducí la sobrecarga cognitiva',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: context.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 32),

              // Selector de pestaña (Login / Registro)
              NeuroInsetContainer(
                borderRadius: 16,
                padding: const EdgeInsets.all(4),
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
                            color: _isLogin ? context.surfaceColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _isLogin
                                ? [
                                    BoxShadow(
                                      color: context.isDarkMode
                                          ? AppColors.darkShadowDark.withOpacity(0.3)
                                          : AppColors.shadowDark.withOpacity(0.2),
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
                              fontWeight: _isLogin ? FontWeight.bold : FontWeight.w500,
                              color: _isLogin ? AppColors.primaryIndigo : context.textSecondaryColor,
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
                            color: !_isLogin ? context.surfaceColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: !_isLogin
                                ? [
                                    BoxShadow(
                                      color: context.isDarkMode
                                          ? AppColors.darkShadowDark.withOpacity(0.3)
                                          : AppColors.shadowDark.withOpacity(0.2),
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
                              fontWeight: !_isLogin ? FontWeight.bold : FontWeight.w500,
                              color: !_isLogin ? AppColors.primaryIndigo : context.textSecondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Formulario
              if (!_isLogin) ...[
                Text(
                  'Nombre completo',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textMainColor,
                  ),
                ),
                const SizedBox(height: 6),
                NeuroInsetContainer(
                  borderRadius: 14,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Tu nombre',
                      hintStyle: TextStyle(color: context.textMutedColor),
                      icon: Icon(Icons.person_outline_rounded, color: context.textSecondaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              Text(
                'Correo electrónico',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textMainColor,
                ),
              ),
              const SizedBox(height: 6),
              NeuroInsetContainer(
                borderRadius: 14,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'ejemplo@correo.com',
                    hintStyle: TextStyle(color: context.textMutedColor),
                    icon: Icon(Icons.email_outlined, color: context.textSecondaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Contraseña',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textMainColor,
                ),
              ),
              const SizedBox(height: 6),
              NeuroInsetContainer(
                borderRadius: 14,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '••••••••',
                    hintStyle: TextStyle(color: context.textMutedColor),
                    icon: Icon(Icons.lock_outline_rounded, color: context.textSecondaryColor),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Botón Principal
              SizedBox(
                height: 52,
                child: NeumorphicButton(
                  onPressed: _onAuthenticate,
                  backgroundColor: AppColors.primaryIndigo,
                  child: Text(
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
                  Expanded(child: Divider(color: context.textMutedColor.withOpacity(0.3))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'o bien',
                      style: TextStyle(fontSize: 12, color: context.textMutedColor),
                    ),
                  ),
                  Expanded(child: Divider(color: context.textMutedColor.withOpacity(0.3))),
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
                      Icon(Icons.face_5_outlined, color: context.textMainColor, size: 20),
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

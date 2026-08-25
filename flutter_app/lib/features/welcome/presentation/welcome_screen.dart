import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/neumorphic_theme.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../brain_dump/presentation/brain_dump_screen.dart';
import '../../focus_viewport/controllers/focus_controller.dart';
import '../../focus_viewport/presentation/single_task_screen.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _breatheController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.25, end: 0.65).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  void _onBrainTapped() {
    HapticHelper.success();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const BrainDumpScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  void _onResumeSession() {
    HapticHelper.success();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const SingleTaskScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final focusState = ref.watch(focusProvider);
    final hasActiveTask = focusState.hasActiveSession && focusState.currentTask != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top University & Subject Header + Theme Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: NeumorphicTheme.subtleElevation,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 3.5, backgroundColor: AppColors.primaryIndigo),
                        SizedBox(width: 8),
                        Text(
                          'DAM — ITU UNCuyo',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryIndigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const ThemeToggleButton(),
                ],
              ),

              // Central Hero Branding: Interactive Brain Logo
              Column(
                children: [
                  Semantics(
                    button: true,
                    label: 'Logotipo de NeuroTask: Tocar para iniciar volcado de ideas',
                    child: GestureDetector(
                      onTap: _onBrainTapped,
                      child: AnimatedBuilder(
                        animation: _breatheController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: 210,
                              height: 210,
                              decoration: BoxDecoration(
                                color: AppColors.cardSurface,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.brandGlowCyan.withValues(alpha: _glowAnimation.value),
                                    blurRadius: 36,
                                    spreadRadius: 6,
                                  ),
                                  const BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-8, -8),
                                    blurRadius: 20,
                                  ),
                                  const BoxShadow(
                                    color: AppColors.shadowDark,
                                    offset: Offset(8, 8),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(26.0),
                                child: Image.asset(
                                  'assets/images/logo.jpg',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.psychology_alt_rounded,
                                    size: 100,
                                    color: AppColors.brandDeepBlue,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Brand Typography
                  const Text(
                    'NEUROTASK',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: AppColors.brandDeepBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'MOTOR DE FOCO',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.5,
                      color: AppColors.brandSteelBlue,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Transformá el caos de ideas en un camino lógico y sereno.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),

              // Bottom Actions (Resume Session if available + Main Button)
              Column(
                children: [
                  if (hasActiveTask) ...[
                    Semantics(
                      button: true,
                      label: 'Reanudar sesión guardada en el paso ${focusState.currentStepNumber}',
                      child: InkWell(
                        onTap: _onResumeSession,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.successEmerald.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.successEmerald.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.play_circle_fill_rounded, color: AppColors.successEmerald, size: 18),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Reanudar paso ${focusState.currentStepNumber}: ${focusState.currentTask!.title}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.successEmeraldDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],

                  Semantics(
                    button: true,
                    label: 'Tocar para Descomprimir e iniciar nuevo volcado',
                    child: GestureDetector(
                      onTap: _onBrainTapped,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A89B4), AppColors.brandDeepBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brandDeepBlue.withValues(alpha: 0.35),
                              offset: const Offset(4, 6),
                              blurRadius: 16,
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-3, -3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.touch_app_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Tocar para Descomprimir',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tocá el cerebro o el botón para comenzar',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

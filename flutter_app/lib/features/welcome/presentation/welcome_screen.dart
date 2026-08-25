import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../achievements/presentation/achievements_vault_screen.dart';
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

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOutSine),
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.55).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  void _onBrainTapped() {
    HapticHelper.lightTap();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const BrainDumpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _onResumeSession() {
    HapticHelper.lightTap();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SingleTaskScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final focusState = ref.watch(focusProvider);
    final hasActiveTask = focusState.hasActiveSession && focusState.currentTask != null;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top University Badge + Trophy Vault & Theme Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: context.subtleElevation,
                      border: Border.all(color: context.borderLight),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 3.5,
                          backgroundColor: isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'DAM — ITU UNCuyo',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Semantics(
                        button: true,
                        label: 'Abrir Baúl de Logros Cognitivos',
                        child: InkWell(
                          onTap: () {
                            HapticHelper.lightTap();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AchievementsVaultScreen()),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: context.cardSurface,
                              shape: BoxShape.circle,
                              boxShadow: context.subtleElevation,
                              border: Border.all(color: context.borderLight),
                            ),
                            child: const Center(
                              child: Text('🏆', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const ThemeToggleButton(),
                    ],
                  ),
                ],
              ),

              // Central Hero Branding: Glowing Transparent Neural Brain Icon
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
                                color: context.cardSurface,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo)
                                        .withValues(alpha: _glowAnimation.value),
                                    blurRadius: 36,
                                    spreadRadius: 6,
                                  ),
                                  BoxShadow(
                                    color: isDark ? Colors.white10 : Colors.white,
                                    offset: const Offset(-8, -8),
                                    blurRadius: 20,
                                  ),
                                  BoxShadow(
                                    color: isDark ? AppColors.darkShadowDark : AppColors.shadowDark,
                                    offset: const Offset(8, 8),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: Image.asset(
                                    'assets/images/brain_logo_transparent.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.psychology_rounded,
                                      size: 108,
                                      color: AppColors.primaryIndigo,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Brand Typography
                  Text(
                    'NEUROTASK',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: isDark ? AppColors.brandGlowCyan : AppColors.brandDeepBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'MOTOR DE FOCO',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.brandSteelBlue,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Transformá el caos de ideas en un camino lógico y sereno.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),

              // Bottom Actions: Resume Session or Tap Hint Prompt
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
                          margin: const EdgeInsets.only(bottom: 14),
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
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.successEmerald : AppColors.successEmeraldDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Subtle Interactive Prompt Pill
                  InkWell(
                    onTap: _onBrainTapped,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: context.cardSurface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: context.subtleElevation,
                        border: Border.all(color: context.borderLight),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            size: 18,
                            color: isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tocá el cerebro para descomprimir tu mente',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextMain : AppColors.textMain,
                            ),
                          ),
                        ],
                      ),
                    ),
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

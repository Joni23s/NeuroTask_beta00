import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/neumorphic_theme.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../brain_dump/presentation/brain_dump_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
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

  void _onBrainTapped({bool startVoice = false}) {
    HapticHelper.success();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top University & Subject Header
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

              // Central Hero Branding: Interactive Brain Logo
              Column(
                children: [
                  GestureDetector(
                    onTap: () => _onBrainTapped(startVoice: false),
                    child: AnimatedBuilder(
                      animation: _breatheController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              color: AppColors.cardSurface,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryIndigoLight.withValues(alpha: _glowAnimation.value),
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
                              padding: const EdgeInsets.all(28.0),
                              child: Image.asset(
                                'assets/images/logo.jpg',
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.psychology_alt_rounded,
                                  size: 100,
                                  color: AppColors.primaryIndigo,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Brand Typography
                  const Text(
                    'NEUROTASK',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: Color(0xFF2B5B84),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'MOTOR DE FOCO',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.5,
                      color: Color(0xFF4A7D9D),
                    ),
                  ),
                  const SizedBox(height: 16),
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

              // Bottom Interactive Action
              Column(
                children: [
                  GestureDetector(
                    onTap: () => _onBrainTapped(startVoice: false),
                    child: Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4A89B4), Color(0xFF2B5B84)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2B5B84).withValues(alpha: 0.35),
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
                  const SizedBox(height: 12),
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

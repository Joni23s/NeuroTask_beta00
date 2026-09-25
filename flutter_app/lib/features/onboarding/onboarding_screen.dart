import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/neumorphic_card.dart';
import '../auth/login_register_screen.dart';

class OnboardingSlide {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}

/// Onboarding interactivo en 3 pasos para familiarizar al usuario con la filosofía NeuroTask.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'Volcá tus ideas libremente',
      description: 'Hacé un Brain Dump por texto o voz sin preocuparte por fechas, categorías o prioridades.',
      icon: Icons.mic_external_on_rounded,
      accentColor: AppColors.primaryIndigo,
    ),
    OnboardingSlide(
      title: 'El sistema descompone y ordena',
      description: 'NeuroTask convierte tu lista en micro-tareas de 15 min y genera una secuencia clara sin sobrecarga.',
      icon: Icons.account_tree_rounded,
      accentColor: AppColors.brandGlowCyan,
    ),
    OnboardingSlide(
      title: 'Una sola tarea a la vez',
      description: 'Enfocate exclusivamente en la micro-tarea actual. Si te trabás, el Rescate Cognitivo te ayuda.',
      icon: Icons.center_focus_strong_rounded,
      accentColor: AppColors.successEmerald,
    ),
  ];

  void _onNext() {
    HapticHelper.lightTap();
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    HapticHelper.mediumImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginRegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header con botón Saltar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.psychology_rounded, color: AppColors.primaryIndigo, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'NeuroTask',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.textMainColor,
                        ),
                      ),
                    ],
                  ),
                  if (_currentPage < _slides.length - 1)
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: Text(
                        'Saltar',
                        style: TextStyle(
                          color: context.textSecondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 48),
                ],
              ),
            ),

            // PageView de Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Card neumórfica para el icono principal
                        NeumorphicCard(
                          padding: const EdgeInsets.all(36),
                          borderRadius: 32,
                          child: Icon(
                            slide.icon,
                            size: 80,
                            color: slide.accentColor,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.textMainColor,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: context.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Footer con Dots e indicador de avance
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primaryIndigo
                              : context.textMutedColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Botón Siguiente / Comenzar
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: NeumorphicButton(
                      onPressed: _onNext,
                      backgroundColor: AppColors.primaryIndigo,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _slides.length - 1 ? 'Comenzar' : 'Siguiente',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentPage == _slides.length - 1
                                ? Icons.rocket_launch_rounded
                                : Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

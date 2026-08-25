import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/neumorphic_theme.dart';
import '../theme/theme_controller.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final isDark = themeState.isDarkMode;

    return Semantics(
      button: true,
      label: isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro calmante',
      child: InkWell(
        onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardSurface : AppColors.cardSurface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isDark ? NeumorphicTheme.darkSubtleElevation : NeumorphicTheme.subtleElevation,
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.8),
            ),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
                size: 18,
                color: isDark ? const Color(0xFFFBBF24) : AppColors.brandDeepBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

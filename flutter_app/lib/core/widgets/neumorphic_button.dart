import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/neumorphic_theme.dart';
import '../utils/haptic_helper.dart';

enum NeumorphicButtonVariant {
  primary,
  success,
  flat,
  pressed,
}

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final NeumorphicButtonVariant variant;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  const NeumorphicButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.variant = NeumorphicButtonVariant.flat,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.width,
    this.height,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;

    switch (widget.variant) {
      case NeumorphicButtonVariant.primary:
        decoration = BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryIndigoLight, AppColors.primaryIndigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: const [
            BoxShadow(
              color: AppColors.indigoGlow,
              offset: Offset(4, 4),
              blurRadius: 14,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-3, -3),
              blurRadius: 8,
            ),
          ],
        );
        break;
      case NeumorphicButtonVariant.success:
        decoration = BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.successEmerald, AppColors.successEmeraldDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: const [
            BoxShadow(
              color: AppColors.emeraldGlow,
              offset: Offset(4, 4),
              blurRadius: 14,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-3, -3),
              blurRadius: 8,
            ),
          ],
        );
        break;
      case NeumorphicButtonVariant.pressed:
        decoration = BoxDecoration(
          color: AppColors.pressedSurface,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: NeumorphicTheme.pressedElevation,
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        );
        break;
      case NeumorphicButtonVariant.flat:
        decoration = BoxDecoration(
          color: _isPressed ? AppColors.pressedSurface : AppColors.cardSurface,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _isPressed ? NeumorphicTheme.pressedElevation : NeumorphicTheme.subtleElevation,
          border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
        );
        break;
    }

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        HapticHelper.lightTap();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: decoration,
        child: Center(child: widget.child),
      ),
    );
  }
}

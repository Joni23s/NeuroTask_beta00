import 'package:flutter/material.dart';
import '../theme/theme_context.dart';

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Border? border;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
    this.borderRadius = 28.0,
    this.onTap,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.cardSurface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: context.softElevation,
        border: border ?? Border.all(color: context.borderLight, width: 1.2),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

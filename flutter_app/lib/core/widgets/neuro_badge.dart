import 'package:flutter/material.dart';
import '../theme/theme_context.dart';

/// Un badge neumórfico funcional tipo píldora para estados, categorías y chips interactivos.
class NeuroBadge extends StatelessWidget {
  final String label;
  final Color? dotColor;
  final Color? textColor;
  final Color? backgroundColor;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;
  final bool hasElevation;
  final Border? border;

  const NeuroBadge({
    super.key,
    required this.label,
    this.dotColor,
    this.textColor,
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    this.borderRadius = 16.0,
    this.fontSize = 11.0,
    this.fontWeight = FontWeight.bold,
    this.letterSpacing = 0.0,
    this.hasElevation = true,
    this.border,
  });

  /// Constructor semántico para badges de estado con punto circular luminoso.
  const NeuroBadge.status({
    super.key,
    required this.label,
    required Color this.dotColor,
    this.textColor,
    this.backgroundColor,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    this.borderRadius = 16.0,
    this.fontSize = 11.0,
    this.fontWeight = FontWeight.bold,
    this.letterSpacing = 0.0,
    this.hasElevation = true,
    this.border,
  })  : icon = null,
        iconColor = null;

  /// Constructor semántico para chips de ejemplo o botones de filtro interactivos.
  const NeuroBadge.chip({
    super.key,
    required this.label,
    this.onTap,
    this.textColor,
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.borderRadius = 10.0,
    this.fontSize = 11.0,
    this.fontWeight = FontWeight.w600,
    this.letterSpacing = 0.0,
    this.hasElevation = true,
    this.border,
  }) : dotColor = null;

  /// Constructor semántico para tags destacados o badges planos de alerta/micro-paso.
  const NeuroBadge.highlight({
    super.key,
    required this.label,
    required Color this.backgroundColor,
    required Color this.textColor,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    this.borderRadius = 8.0,
    this.fontSize = 10.0,
    this.fontWeight = FontWeight.bold,
    this.letterSpacing = 0.0,
    this.border,
  })  : dotColor = null,
        icon = null,
        iconColor = null,
        hasElevation = false;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? dotColor ?? context.textSecondary;
    final effectiveBg = backgroundColor ?? context.cardSurface;

    final badgeBody = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasElevation ? context.subtleElevation : null,
        border: border ?? (hasElevation ? Border.all(color: context.borderLight) : null),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            CircleAvatar(
              radius: 3.5,
              backgroundColor: dotColor,
            ),
            const SizedBox(width: 8),
          ] else if (icon != null) ...[
            Icon(
              icon,
              size: fontSize + 2,
              color: iconColor ?? effectiveTextColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: effectiveTextColor,
              letterSpacing: letterSpacing > 0 ? letterSpacing : null,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Semantics(
        button: true,
        label: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: badgeBody,
        ),
      );
    }

    return badgeBody;
  }
}

import 'package:flutter/material.dart';
import '../theme/theme_context.dart';

/// Contenedor neumórfico con relieve invertido/hundido (pressed surface),
/// ideal para áreas de texto, inputs, visores de código y slots de estado.
class NeuroInsetContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final BoxConstraints? constraints;
  final double? height;
  final double? width;
  final Border? border;
  final Color? backgroundColor;

  const NeuroInsetContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 24.0,
    this.constraints,
    this.height,
    this.width,
    this.border,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      constraints: constraints,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.pressedSurface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: context.pressedElevation,
        border: border ?? Border.all(color: context.borderLight),
      ),
      child: child,
    );
  }
}

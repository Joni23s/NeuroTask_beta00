import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/theme_context.dart';

class FlowIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const FlowIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: context.cardSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: context.subtleElevation,
        border: Border.all(color: context.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.successEmerald,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Paso $currentStep de $totalSteps',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: context.textMain,
            ),
          ),
        ],
      ),
    );
  }
}

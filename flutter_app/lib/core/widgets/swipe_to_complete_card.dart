import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/theme_context.dart';
import '../utils/haptic_helper.dart';

class SwipeToCompleteCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeCompleted;
  final VoidCallback? onPullRescue;

  const SwipeToCompleteCard({
    super.key,
    required this.child,
    required this.onSwipeCompleted,
    this.onPullRescue,
  });

  @override
  State<SwipeToCompleteCard> createState() => _SwipeToCompleteCardState();
}

class _SwipeToCompleteCardState extends State<SwipeToCompleteCard> with SingleTickerProviderStateMixin {
  double _dragOffset = 0.0;
  double _verticalDragOffset = 0.0;
  final double _triggerThreshold = 140.0;
  final double _verticalTriggerThreshold = 70.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (details.delta.dx > 0 || _dragOffset > 0) {
      setState(() {
        _dragOffset += details.delta.dx * 0.85;
        if (_dragOffset < 0) _dragOffset = 0;
      });
      if (_dragOffset > _triggerThreshold * 0.5) {
        HapticHelper.lightTap();
      }
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragOffset >= _triggerThreshold) {
      HapticHelper.success();
      widget.onSwipeCompleted();
    }
    setState(() {
      _dragOffset = 0.0;
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (widget.onPullRescue != null && details.delta.dy > 0) {
      setState(() {
        _verticalDragOffset += details.delta.dy * 0.7;
      });
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_verticalDragOffset >= _verticalTriggerThreshold && widget.onPullRescue != null) {
      HapticHelper.warning();
      widget.onPullRescue!();
    }
    setState(() {
      _verticalDragOffset = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_dragOffset / _triggerThreshold).clamp(0.0, 1.0);

    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Swipe Reveal Surface
          if (_dragOffset > 10)
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.successEmerald.withValues(alpha: 0.15 + (progress * 0.6)),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: AppColors.successEmerald.withValues(alpha: 0.4 + (progress * 0.6)),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.successEmerald,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.emeraldGlow,
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      progress >= 0.95 ? '¡Soltá para completar!' : 'Deslizá para completar...',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: progress >= 0.95 ? AppColors.successEmeraldDark : context.textMain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Main Foreground Neumorphic Card
          AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            transform: Matrix4.translationValues(_dragOffset, _verticalDragOffset * 0.4, 0.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.cardSurface,
                borderRadius: BorderRadius.circular(32),
                boxShadow: context.softElevation,
                border: Border.all(
                  color: context.borderLight,
                  width: 1.2,
                ),
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

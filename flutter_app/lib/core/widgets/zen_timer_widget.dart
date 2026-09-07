import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/focus/focus_controller.dart';
import '../theme/app_colors.dart';
import '../theme/theme_context.dart';

class ZenTimerWidget extends ConsumerStatefulWidget {
  final int initialMinutes;

  const ZenTimerWidget({
    super.key,
    this.initialMinutes = 15,
  });

  @override
  ConsumerState<ZenTimerWidget> createState() => _ZenTimerWidgetState();
}

class _ZenTimerWidgetState extends ConsumerState<ZenTimerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _ticker;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
        final focusState = ref.read(focusProvider);
        if (focusState.sessionStartTime != null) {
          final realTotalSeconds = DateTime.now().difference(focusState.sessionStartTime!).inSeconds;
          ref.read(focusProvider.notifier).updateElapsedSeconds(realTotalSeconds);
        } else {
          ref.read(focusProvider.notifier).updateElapsedSeconds(_secondsElapsed);
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ticker?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final mins = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final secs = (_secondsElapsed % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 14 + (_pulseController.value * 4),
                  height: 14 + (_pulseController.value * 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryIndigoLight.withValues(alpha: 0.2 + (_pulseController.value * 0.2)),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryIndigo,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              'Tiempo de Flujo: ${widget.initialMinutes} min',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.textSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              _formattedTime,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
                color: context.isDarkMode ? AppColors.brandGlowCyan : AppColors.primaryIndigo,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '| Sin apuros',
              style: TextStyle(
                fontSize: 11,
                color: context.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

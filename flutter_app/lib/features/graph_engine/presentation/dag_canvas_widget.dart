import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_context.dart';
import '../models/task_node.dart';

class DagCanvasWidget extends StatefulWidget {
  final List<TaskNode> nodes;
  final int currentIndex;

  const DagCanvasWidget({
    super.key,
    required this.nodes,
    required this.currentIndex,
  });

  @override
  State<DagCanvasWidget> createState() => _DagCanvasWidgetState();
}

class _DagCanvasWidgetState extends State<DagCanvasWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return CustomPaint(
          size: Size(double.infinity, (widget.nodes.length * 64.0) + 20),
          painter: _DagGraphPainter(
            nodes: widget.nodes,
            currentIndex: widget.currentIndex,
            pulseValue: _pulseController.value,
            isDarkMode: isDark,
          ),
        );
      },
    );
  }
}

class _DagGraphPainter extends CustomPainter {
  final List<TaskNode> nodes;
  final int currentIndex;
  final double pulseValue;
  final bool isDarkMode;

  _DagGraphPainter({
    required this.nodes,
    required this.currentIndex,
    required this.pulseValue,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    const double startX = 32.0;
    const double nodeRadius = 16.0;
    const double verticalSpacing = 64.0;
    const double startY = 24.0;

    // Draw connecting Bézier paths
    for (int i = 0; i < nodes.length - 1; i++) {
      final double y1 = startY + (i * verticalSpacing);
      final double y2 = startY + ((i + 1) * verticalSpacing);

      final isCompletedEdge = i < currentIndex;
      final isActiveEdge = i == currentIndex - 1;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      if (isCompletedEdge) {
        paint.color = AppColors.successEmerald;
      } else if (isActiveEdge) {
        paint.shader = const LinearGradient(
          colors: [AppColors.successEmerald, AppColors.brandGlowCyan],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTRB(startX, y1, startX, y2));
      } else {
        paint.color = (isDarkMode ? AppColors.darkTextMuted : AppColors.textMuted).withValues(alpha: 0.35);
      }

      final path = Path();
      path.moveTo(startX, y1 + nodeRadius);
      path.cubicTo(
        startX, y1 + (verticalSpacing * 0.5),
        startX, y1 + (verticalSpacing * 0.5),
        startX, y2 - nodeRadius,
      );

      canvas.drawPath(path, paint);
    }

    // Draw Nodes
    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final double y = startY + (i * verticalSpacing);
      final isCompleted = node.isCompleted || i < currentIndex;
      final isCurrent = i == currentIndex;

      final center = Offset(startX, y);

      if (isCurrent) {
        // Glowing animated pulse ring
        final glowPaint = Paint()
          ..color = AppColors.brandGlowCyan.withValues(alpha: 0.3 + (pulseValue * 0.3))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, nodeRadius + 6 + (pulseValue * 4), glowPaint);

        // Active node body
        final nodePaint = Paint()
          ..color = AppColors.primaryIndigo
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, nodeRadius, nodePaint);

        final borderPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;
        canvas.drawCircle(center, nodeRadius, borderPaint);

        // Number text
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${i + 1}',
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(center.dx - (textPainter.width / 2), center.dy - (textPainter.height / 2)));
      } else if (isCompleted) {
        // Completed node body
        final nodePaint = Paint()
          ..color = AppColors.successEmerald
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, nodeRadius, nodePaint);

        // Checkmark text
        final textPainter = TextPainter(
          text: const TextSpan(
            text: '✓',
            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(center.dx - (textPainter.width / 2), center.dy - (textPainter.height / 2)));
      } else {
        // Future uncompleted node body
        final nodePaint = Paint()
          ..color = isDarkMode ? AppColors.darkPressedSurface : AppColors.pressedSurface
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, nodeRadius, nodePaint);

        final borderPaint = Paint()
          ..color = (isDarkMode ? AppColors.darkTextMuted : AppColors.textMuted).withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawCircle(center, nodeRadius, borderPaint);

        // Number text
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${i + 1}',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(center.dx - (textPainter.width / 2), center.dy - (textPainter.height / 2)));
      }

      // Draw Title and Subtext to the right of node
      final textSpan = TextSpan(
        children: [
          TextSpan(
            text: '${node.category.toUpperCase()} • ${node.estimatedMinutes}m\n',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isCompleted
                  ? AppColors.successEmerald
                  : isCurrent
                      ? (isDarkMode ? AppColors.brandGlowCyan : AppColors.primaryIndigo)
                      : (isDarkMode ? AppColors.darkTextMuted : AppColors.textMuted),
              letterSpacing: 0.8,
            ),
          ),
          TextSpan(
            text: node.title.length > 34 ? '${node.title.substring(0, 34)}...' : node.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
              color: isCurrent
                  ? (isDarkMode ? AppColors.darkTextMain : AppColors.textMain)
                  : (isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary),
            ),
          ),
        ],
      );

      final labelPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        maxLines: 2,
      )..layout(maxWidth: size.width - 70);

      labelPainter.paint(canvas, Offset(startX + 24, center.dy - (labelPainter.height / 2)));
    }
  }

  @override
  bool shouldRepaint(covariant _DagGraphPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
        oldDelegate.currentIndex != currentIndex ||
        oldDelegate.nodes != nodes ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}

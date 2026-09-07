import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/domain/models/task_graph.dart';
import '../../../core/domain/models/task_node.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_context.dart';

class DagCanvasWidget extends StatefulWidget {
  final List<TaskNode> nodes;
  final int currentIndex;
  final TaskGraph? graph;

  const DagCanvasWidget({
    super.key,
    required this.nodes,
    required this.currentIndex,
    this.graph,
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
    final totalNodes = widget.nodes.length;
    final double canvasHeight = math.max(340.0, 80.0 + (totalNodes * 90.0));
    const double canvasWidth = 360.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          color: context.cardSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: context.borderLight),
        ),
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(40),
          minScale: 0.75,
          maxScale: 2.2,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(canvasWidth, canvasHeight),
                painter: _TreeDagPainter(
                  nodes: widget.nodes,
                  edges: widget.graph?.edges ?? _inferTreeEdges(widget.nodes),
                  currentIndex: widget.currentIndex,
                  pulseValue: _pulseController.value,
                  isDarkMode: isDark,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<TaskEdge> _inferTreeEdges(List<TaskNode> nodes) {
    final List<TaskEdge> edges = [];
    if (nodes.length <= 1) return edges;

    if (nodes.length == 2) {
      edges.add(TaskEdge(fromId: nodes[0].id, toId: nodes[1].id));
    } else if (nodes.length == 3) {
      edges.add(TaskEdge(fromId: nodes[0].id, toId: nodes[1].id));
      edges.add(TaskEdge(fromId: nodes[0].id, toId: nodes[2].id));
    } else {
      edges.add(TaskEdge(fromId: nodes[0].id, toId: nodes[1].id));
      edges.add(TaskEdge(fromId: nodes[0].id, toId: nodes[2].id));
      for (int i = 3; i < nodes.length; i++) {
        final parentIndex = (i % 2 == 1) ? 1 : 2;
        edges.add(TaskEdge(fromId: nodes[parentIndex].id, toId: nodes[i].id));
      }
    }
    return edges;
  }
}

class _NodePosition {
  final Offset center;
  final TaskNode node;
  final int index;

  _NodePosition({required this.center, required this.node, required this.index});
}

class _TreeDagPainter extends CustomPainter {
  final List<TaskNode> nodes;
  final List<TaskEdge> edges;
  final int currentIndex;
  final double pulseValue;
  final bool isDarkMode;

  _TreeDagPainter({
    required this.nodes,
    required this.edges,
    required this.currentIndex,
    required this.pulseValue,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    final double centerX = size.width / 2;
    const double cardWidth = 150.0;
    const double cardHeight = 62.0;

    // Calculate 2D Tree Positions
    final Map<String, _NodePosition> positions = {};

    if (nodes.length == 1) {
      positions[nodes[0].id] = _NodePosition(
        center: Offset(centerX, 80),
        node: nodes[0],
        index: 0,
      );
    } else if (nodes.length == 2) {
      positions[nodes[0].id] = _NodePosition(
        center: Offset(centerX, 70),
        node: nodes[0],
        index: 0,
      );
      positions[nodes[1].id] = _NodePosition(
        center: Offset(centerX, 190),
        node: nodes[1],
        index: 1,
      );
    } else {
      // Root Node at top center
      positions[nodes[0].id] = _NodePosition(
        center: Offset(centerX, 65),
        node: nodes[0],
        index: 0,
      );

      // Level 1: Branch Left & Branch Right
      const double leftX = 90.0;
      const double rightX = 270.0;

      positions[nodes[1].id] = _NodePosition(
        center: const Offset(leftX, 175),
        node: nodes[1],
        index: 1,
      );

      positions[nodes[2].id] = _NodePosition(
        center: const Offset(rightX, 175),
        node: nodes[2],
        index: 2,
      );

      // Subsequent levels
      for (int i = 3; i < nodes.length; i++) {
        final isLeft = (i % 2 == 1);
        final level = (i - 1) ~/ 2;
        final double y = 175.0 + (level * 105.0);
        final double x = isLeft ? leftX : rightX;

        positions[nodes[i].id] = _NodePosition(
          center: Offset(x, y),
          node: nodes[i],
          index: i,
        );
      }
    }

    // 1. Draw Connecting Bézier Curves with directional arrows
    for (final edge in edges) {
      final fromPos = positions[edge.fromId];
      final toPos = positions[edge.toId];
      if (fromPos == null || toPos == null) continue;

      final start = Offset(fromPos.center.dx, fromPos.center.dy + (cardHeight / 2));
      final end = Offset(toPos.center.dx, toPos.center.dy - (cardHeight / 2));

      final isEdgeCompleted = fromPos.index < currentIndex && toPos.index <= currentIndex;
      final isEdgeActive = fromPos.index < currentIndex && toPos.index == currentIndex;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isEdgeActive ? 3.0 : 2.2
        ..strokeCap = StrokeCap.round;

      if (isEdgeCompleted) {
        paint.color = AppColors.successEmerald;
      } else if (isEdgeActive) {
        paint.shader = LinearGradient(
          colors: [AppColors.successEmerald, isDarkMode ? AppColors.brandGlowCyan : AppColors.primaryIndigo],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromPoints(start, end));
      } else {
        paint.color = (isDarkMode ? AppColors.darkTextMuted : AppColors.textMuted).withValues(alpha: 0.35);
      }

      final path = Path();
      path.moveTo(start.dx, start.dy);
      final double midY = (start.dy + end.dy) / 2;
      path.cubicTo(
        start.dx, midY,
        end.dx, midY,
        end.dx, end.dy,
      );

      canvas.drawPath(path, paint);

      // Draw directional arrow head
      final arrowPaint = Paint()
        ..color = paint.color
        ..style = PaintingStyle.fill;

      final arrowPath = Path();
      arrowPath.moveTo(end.dx, end.dy);
      arrowPath.lineTo(end.dx - 4.5, end.dy - 7);
      arrowPath.lineTo(end.dx + 4.5, end.dy - 7);
      arrowPath.close();
      canvas.drawPath(arrowPath, arrowPaint);
    }

    // 2. Draw 2D Tree Node Cards / Capsules
    for (final entry in positions.entries) {
      final pos = entry.value;
      final node = pos.node;
      final index = pos.index;
      final isCompleted = node.isCompleted || index < currentIndex;
      final isCurrent = index == currentIndex;

      final rect = Rect.fromCenter(center: pos.center, width: cardWidth, height: cardHeight);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));

      // Active Node Glowing Animated Ring
      if (isCurrent) {
        final glowPaint = Paint()
          ..color = (isDarkMode ? AppColors.brandGlowCyan : AppColors.primaryIndigo).withValues(alpha: 0.25 + (pulseValue * 0.25))
          ..style = PaintingStyle.fill;
        canvas.drawRRect(RRect.fromRectAndRadius(rect.inflate(4 + (pulseValue * 3)), const Radius.circular(19)), glowPaint);
      }

      // Card Background
      final bgPaint = Paint()
        ..color = isCompleted
            ? AppColors.successEmerald.withValues(alpha: isDarkMode ? 0.22 : 0.12)
            : isCurrent
                ? (isDarkMode ? AppColors.darkPressedSurface : Colors.white)
                : (isDarkMode ? AppColors.darkCardSurface : const Color(0xFFF0F4F8))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, bgPaint);

      // Card Border
      final borderPaint = Paint()
        ..color = isCompleted
            ? AppColors.successEmerald
            : isCurrent
                ? (isDarkMode ? AppColors.brandGlowCyan : AppColors.primaryIndigo)
                : (isDarkMode ? AppColors.darkShadowLight : AppColors.borderLight)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isCurrent ? 2.0 : 1.2;
      canvas.drawRRect(rrect, borderPaint);

      // Left Status Circle (✓ or # or ▶)
      final circleCenter = Offset(rect.left + 18, rect.center.dy);
      final circlePaint = Paint()
        ..color = isCompleted
            ? AppColors.successEmerald
            : isCurrent
                ? AppColors.primaryIndigo
                : (isDarkMode ? AppColors.darkPressedSurface : const Color(0xFFE2E8F0))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(circleCenter, 11, circlePaint);

      final iconPainter = TextPainter(
        text: TextSpan(
          text: isCompleted ? '✓' : isCurrent ? '▶' : '${index + 1}',
          style: TextStyle(
            color: isCompleted || isCurrent ? Colors.white : (isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary),
            fontSize: isCompleted ? 11 : isCurrent ? 9 : 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      iconPainter.paint(canvas, Offset(circleCenter.dx - (iconPainter.width / 2), circleCenter.dy - (iconPainter.height / 2)));

      // Right Text Area: Category & Title & Minutes
      final textSpan = TextSpan(
        children: [
          TextSpan(
            text: '${node.category.toUpperCase()} • ${node.estimatedMinutes}m\n',
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.bold,
              color: isCompleted
                  ? AppColors.successEmerald
                  : isCurrent
                      ? (isDarkMode ? AppColors.brandGlowCyan : AppColors.primaryIndigo)
                      : (isDarkMode ? AppColors.darkTextMuted : AppColors.textMuted),
              letterSpacing: 0.5,
            ),
          ),
          TextSpan(
            text: node.title.length > 22 ? '${node.title.substring(0, 22)}...' : node.title,
            style: TextStyle(
              fontSize: 10.5,
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
      )..layout(maxWidth: cardWidth - 42);

      labelPainter.paint(canvas, Offset(rect.left + 36, rect.center.dy - (labelPainter.height / 2)));
    }
  }

  @override
  bool shouldRepaint(covariant _TreeDagPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
        oldDelegate.currentIndex != currentIndex ||
        oldDelegate.nodes != nodes ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}

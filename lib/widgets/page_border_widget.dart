import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Wraps [child] with a decorative page border based on [borderStyle].
///
/// Available styles:
///   'none'   — pass-through, no border applied
///   'single' — single solid border with an 8 px inset margin
///   'double' — two nested solid borders
///   'dashed' — dashed border painted with [CustomPainter]
///   'shadow' — drop shadow only (no hard line)
class PageBorderWidget extends StatelessWidget {
  final String borderStyle;
  final Color borderColor;
  final Widget child;

  const PageBorderWidget({
    super.key,
    required this.borderStyle,
    required this.child,
    this.borderColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    switch (borderStyle) {
      case 'single':
        return Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
          ),
          child: child,
        );

      case 'double':
        return Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2.5),
          ),
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1),
            ),
            child: child,
          ),
        );

      case 'dashed':
        return Stack(
          children: [
            child,
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _DashedBorderPainter(color: borderColor),
                ),
              ),
            ),
          ],
        );

      case 'shadow':
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.35),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: child,
        );

      default: // 'none'
        return child;
    }
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashLen = 8.0;
    const gapLen = 5.0;
    const margin = 12.0;

    final rect = Rect.fromLTRB(margin, margin, size.width - margin, size.height - margin);
    _drawDashedRect(canvas, paint, rect, dashLen, gapLen);

    // Second inner border
    final inner = rect.deflate(6);
    final paint2 = Paint()
      ..color = color.withOpacity(0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    _drawDashedRect(canvas, paint2, inner, 5, 4);
  }

  void _drawDashedRect(Canvas canvas, Paint paint, Rect r, double dash, double gap) {
    _drawDashedLine(canvas, paint, r.topLeft, r.topRight, dash, gap);
    _drawDashedLine(canvas, paint, r.topRight, r.bottomRight, dash, gap);
    _drawDashedLine(canvas, paint, r.bottomRight, r.bottomLeft, dash, gap);
    _drawDashedLine(canvas, paint, r.bottomLeft, r.topLeft, dash, gap);
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end, double dash, double gap) {
    final total = (end - start).distance;
    final dir = (end - start) / total;
    double d = 0;
    bool drawing = true;
    while (d < total) {
      final segLen = drawing ? dash : gap;
      final next = math.min(d + segLen, total);
      if (drawing) {
        canvas.drawLine(start + dir * d, start + dir * next, paint);
      }
      d = next;
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}

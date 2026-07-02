import 'package:flutter/material.dart';

/// The CoverGen brand logo — a stylised document with a sparkle accent.
/// Used in the app bar, splash screen, and anywhere a small logo is needed.
class CoverGenLogo extends StatelessWidget {
  final double size;
  final Color? color;
  const CoverGenLogo({super.key, this.size = 32, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return CustomPaint(
      size: Size(size, size),
      painter: _LogoPainter(color: c),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color color;
  const _LogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Document body ────────────────────────────────────────────────────────
    final docPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final docPath = Path()
      ..moveTo(w * 0.12, h * 0.08)
      ..lineTo(w * 0.68, h * 0.08)
      ..lineTo(w * 0.92, h * 0.30)
      ..lineTo(w * 0.92, h * 0.94)
      ..quadraticBezierTo(w * 0.92, h, w * 0.84, h)
      ..lineTo(w * 0.16, h)
      ..quadraticBezierTo(w * 0.08, h, w * 0.08, h * 0.94)
      ..lineTo(w * 0.08, h * 0.14)
      ..quadraticBezierTo(w * 0.08, h * 0.08, w * 0.12, h * 0.08)
      ..close();
    canvas.drawPath(docPath, docPaint);

    // ── Folded corner ────────────────────────────────────────────────────────
    final foldPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final foldPath = Path()
      ..moveTo(w * 0.68, h * 0.08)
      ..lineTo(w * 0.68, h * 0.30)
      ..lineTo(w * 0.92, h * 0.30)
      ..close();
    canvas.drawPath(foldPath, foldPaint);

    // ── Lines on the document (content hint) ─────────────────────────────────
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    for (int i = 0; i < 3; i++) {
      final top = h * (0.48 + i * 0.13);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.18, top, w * (i == 2 ? 0.38 : 0.54), h * 0.045),
          const Radius.circular(2),
        ),
        linePaint,
      );
    }

    // ── Sparkle / star (top-right, accent) ───────────────────────────────────
    final starPaint = Paint()
      ..color = Colors.amber.shade300
      ..style = PaintingStyle.fill;

    final cx = w * 0.82;
    final cy = h * 0.14;
    final r = w * 0.11;

    // 4-pointed star
    final starPath = Path();
    for (int i = 0; i < 8; i++) {
      final angle = i * 3.14159265 / 4;
      final radius = i.isEven ? r : r * 0.4;
      final px = cx + radius * _cos(angle - 3.14159265 / 8);
      final py = cy + radius * _sin(angle - 3.14159265 / 8);
      i == 0 ? starPath.moveTo(px, py) : starPath.lineTo(px, py);
    }
    starPath.close();
    canvas.drawPath(starPath, starPaint);
  }

  double _cos(double a) => _cosLookup(a);
  double _sin(double a) => _sinLookup(a);

  // Simple trig helpers to avoid dart:math import issues
  double _cosLookup(double a) {
    // Use series approximation: cos(a) ≈ 1 - a²/2 + a⁴/24 for small |a|
    // For general use just use the identity via sin
    return _sinLookup(a + 1.5707963268);
  }

  double _sinLookup(double a) {
    // Reduce to [-pi, pi]
    while (a > 3.14159265) {
      a -= 6.2831853;
    }
    while (a < -3.14159265) {
      a += 6.2831853;
    }
    // Bhaskara approximation
    const b = 3.14159265;
    if (a < 0) return -_sinPos(-a);
    return _sinPos(a);
  }

  double _sinPos(double x) {
    const b = 3.14159265;
    return (4 * x * (b - x)) / (5 * b * b - 4 * x * (b - x));
  }

  @override
  bool shouldRepaint(_LogoPainter old) => old.color != color;
}

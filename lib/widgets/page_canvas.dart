import 'package:flutter/material.dart';

/// Wraps a fixed-size A4 page (794x1123 @96dpi) around [child].
/// If the content is naturally taller than the page (long text, wrapped
/// lines, extra fields, etc.), it is scaled down to fit instead of
/// overflowing (no more yellow/black debug overflow bars, no clipped
/// content on export). Content that already fits renders at 100%.
class PageCanvas extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget child;

  const PageCanvas({
    super.key,
    this.width = 794,
    this.height = 1123,
    this.color = Colors.white,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: color,
      alignment: Alignment.topCenter,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: width,
          child: child,
        ),
      ),
    );
  }
}

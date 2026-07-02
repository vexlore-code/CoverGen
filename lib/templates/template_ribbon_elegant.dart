import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';

class TemplateRibbonElegant extends StatelessWidget {
  final CoverPageData data;
  const TemplateRibbonElegant({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final accent = data.themeColor;
    String or(String s, String fb) => s.isEmpty ? fb : s;

    TextStyle serif(double sz, {FontWeight fw = FontWeight.normal, Color? color, FontStyle fs = FontStyle.normal}) =>
        GoogleFonts.playfairDisplay(fontSize: sz, fontWeight: fw, color: color ?? const Color(0xFF1A1A2E), fontStyle: fs);

    TextStyle sans(double sz, {Color? color, FontWeight fw = FontWeight.normal, double ls = 0}) =>
        GoogleFonts.lato(fontSize: sz, color: color ?? const Color(0xFF333344), fontWeight: fw, letterSpacing: ls);

    return Material(
      color: Colors.white,
      child: SizedBox(
        width: 794,
        height: 1123,
        child: Stack(
          children: [
            // Ribbon painter (top-right + bottom-left triangles)
            Positioned.fill(
              child: CustomPaint(painter: _RibbonPainter(color: accent)),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.fromLTRB(56, 70, 56, 40),
              child: Column(
                children: [
                  // Logo
                  Transform.translate(
                    offset: data.getOffset('logo'),
                    child: LogoWidget(data: data, height: data.logoSize, fallbackColor: accent),
                  ),

                  const SizedBox(height: 16),

                  // University name
                  if (data.universityName.isNotEmpty) ...[
                    Text(data.universityName,
                        style: serif(20, fw: FontWeight.w700), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                  ],

                  if (data.departmentName.isNotEmpty)
                    Text(data.departmentName,
                        style: serif(13, fs: FontStyle.italic, color: accent), textAlign: TextAlign.center),

                  const SizedBox(height: 24),

                  // Decorative divider
                  Row(children: [
                    Expanded(child: Container(height: 3, color: accent)),
                    Container(width: 12, height: 12, margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: accent)),
                    Expanded(child: Container(height: 1, color: accent)),
                    Container(width: 8, height: 8, margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: accent.withValues(alpha: 0.4))),
                    Expanded(child: Container(height: 3, color: accent)),
                  ]),

                  const SizedBox(height: 28),

                  // Assignment title box
                  Transform.translate(
                    offset: data.getOffset('title'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      decoration: BoxDecoration(
                        border: Border.all(color: accent, width: 1.5),
                        color: accent.withValues(alpha: 0.04),
                      ),
                      child: Column(
                        children: [
                          Text(or(data.assignmentType, 'Assignment').toUpperCase(),
                              style: sans(10, fw: FontWeight.w700, color: accent, ls: 2.5)),
                          const SizedBox(height: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: SizedBox(
                              width: 650,
                              child: Text(or(data.assignmentTitle, 'Assignment Title'),
                                  style: serif(22, fw: FontWeight.w700), textAlign: TextAlign.center),
                            ),
                          ),
                          if (data.courseTitle.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text('${data.courseTitle}  |  ${data.courseCode}',
                                style: sans(12, color: Colors.grey.shade600)),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Info blocks
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Transform.translate(
                          offset: data.getOffset('info_left'),
                          child: _InfoBlock(
                            accent: accent,
                            title: 'Submitted By',
                            items: data.isGroupSubmission
                                ? data.groupMembers.where((m) => m.name.isNotEmpty)
                                    .map((m) => '${m.name}  ${m.id}').toList()
                                : [
                                    if (data.studentName.isNotEmpty) data.studentName,
                                    if (data.studentId.isNotEmpty) data.studentId,
                                    if (data.section.isNotEmpty) 'Section: ${data.section}',
                                    if (data.batch.isNotEmpty) 'Batch: ${data.batch}',
                                  ],
                          ),
                        ),
                      ),
                      if (data.instructorInfoEnabled) ...[
                        Container(width: 1, height: 120, color: accent.withValues(alpha: 0.3), margin: const EdgeInsets.symmetric(horizontal: 16)),
                        Expanded(
                          child: Transform.translate(
                            offset: data.getOffset('info_right'),
                            child: _InfoBlock(
                              accent: accent,
                              title: 'Submitted To',
                              items: [
                                if (data.teacherName.isNotEmpty) data.teacherName,
                                if (data.teacherDesignation.isNotEmpty) data.teacherDesignation,
                                if (data.teacherDepartment.isNotEmpty) data.teacherDepartment,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const Spacer(),

                  // Bottom divider + date
                  Row(children: [
                    Expanded(child: Container(height: 1, color: accent.withValues(alpha: 0.3))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Transform.translate(
                        offset: data.getOffset('date'),
                        child: Text(or(data.submissionDate, '__________'),
                            style: sans(12, color: Colors.grey.shade600)),
                      ),
                    ),
                    Expanded(child: Container(height: 1, color: accent.withValues(alpha: 0.3))),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final Color accent;
  final String title;
  final List<String> items;
  const _InfoBlock({required this.accent, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w800, color: accent, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(item, style: GoogleFonts.lato(fontSize: 12, color: const Color(0xFF333344), height: 1.5)),
            )),
        if (items.isEmpty)
          Text('___________', style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade400)),
      ],
    );
  }
}

class _RibbonPainter extends CustomPainter {
  final Color color;
  _RibbonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;
    const s = 90.0; // ribbon size

    // Top-right ribbon
    final tr = Path()
      ..moveTo(w - s, 0)
      ..lineTo(w, 0)
      ..lineTo(w, s)
      ..close();
    canvas.drawPath(tr, paint);

    // Bottom-left ribbon
    final bl = Path()
      ..moveTo(0, h - s)
      ..lineTo(0, h)
      ..lineTo(s, h)
      ..close();
    canvas.drawPath(bl, Paint()..color = color.withValues(alpha: 0.5)..style = PaintingStyle.fill);

    // Top-right inner lighter triangle
    final trInner = Path()
      ..moveTo(w - 50, 0)
      ..lineTo(w, 0)
      ..lineTo(w, 50)
      ..close();
    canvas.drawPath(trInner, Paint()..color = color.withValues(alpha: 0.3)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_RibbonPainter old) => old.color != color;
}

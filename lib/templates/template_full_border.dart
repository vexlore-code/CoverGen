import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';

class TemplateFullBorder extends StatelessWidget {
  final CoverPageData data;
  const TemplateFullBorder({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final accent = data.themeColor;
    String or(String s, String fb) => s.isEmpty ? fb : s;

    TextStyle serif(double sz, {FontWeight fw = FontWeight.normal, Color? color, FontStyle fs = FontStyle.normal}) =>
        GoogleFonts.libreBaskerville(fontSize: sz, fontWeight: fw, color: color ?? const Color(0xFF1A1A2E), fontStyle: fs);

    TextStyle sans(double sz, {Color? color, FontWeight fw = FontWeight.normal, double ls = 0}) =>
        GoogleFonts.lato(fontSize: sz, color: color ?? const Color(0xFF333344), fontWeight: fw, letterSpacing: ls);

    return Material(
      color: Colors.white,
      child: SizedBox(
        width: 794,
        height: 1123,
        child: Stack(
          children: [
            // Ornate border
            Positioned.fill(
              child: CustomPaint(painter: _OrnateBorderPainter(color: accent)),
            ),

            // Inner content with padding from border
            Padding(
              padding: const EdgeInsets.all(44),
              child: Column(
                children: [
                  Transform.translate(
                    offset: data.getOffset('logo'),
                    child: LogoWidget(data: data, height: data.logoSize, fallbackColor: accent),
                  ),

                  const SizedBox(height: 14),

                  if (data.universityName.isNotEmpty)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(data.universityName,
                          style: serif(20, fw: FontWeight.w700), textAlign: TextAlign.center),
                    ),

                  const SizedBox(height: 16),

                  // Triple divider
                  _TripleDivider(color: accent),

                  const SizedBox(height: 12),

                  if (data.departmentName.isNotEmpty)
                    Text(data.departmentName,
                        style: serif(13, fs: FontStyle.italic, color: Colors.grey.shade600),
                        textAlign: TextAlign.center),

                  const SizedBox(height: 24),

                  Transform.translate(
                    offset: data.getOffset('title'),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(border: Border.all(color: accent, width: 1.5)),
                          child: Column(
                            children: [
                              Text(or(data.assignmentType, 'Assignment').toUpperCase(),
                                  style: sans(9, color: accent, fw: FontWeight.w700, ls: 2.5)),
                              const SizedBox(height: 6),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: SizedBox(
                                  width: 660,
                                  child: Text(or(data.assignmentTitle, 'Assignment Title'),
                                      style: serif(22, fw: FontWeight.w700), textAlign: TextAlign.center),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (data.courseTitle.isNotEmpty)
                          Text('${data.courseTitle}  |  ${data.courseCode}',
                              style: sans(12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  _TripleDivider(color: accent, thin: true),
                  const SizedBox(height: 20),

                  // Info blocks — with vertical rule in center
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Transform.translate(
                            offset: data.getOffset('info_left'),
                            child: _CertInfoBlock(
                              accent: accent,
                              title: 'Submitted By',
                              items: data.isGroupSubmission
                                  ? data.groupMembers.where((m) => m.name.isNotEmpty)
                                      .map((m) => '${m.name}\n${m.id}').toList()
                                  : [
                                      if (data.studentName.isNotEmpty) data.studentName,
                                      if (data.studentId.isNotEmpty) 'ID: ${data.studentId}',
                                      if (data.section.isNotEmpty) 'Section: ${data.section}',
                                      if (data.batch.isNotEmpty) 'Batch: ${data.batch}',
                                    ],
                            ),
                          ),
                        ),
                        if (data.instructorInfoEnabled) ...[
                          Container(width: 1, color: accent.withValues(alpha: 0.3),
                              margin: const EdgeInsets.symmetric(horizontal: 16)),
                          Expanded(
                            child: Transform.translate(
                              offset: data.getOffset('info_right'),
                              child: _CertInfoBlock(
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
                  ),

                  const Spacer(),

                  _TripleDivider(color: accent, thin: true),
                  const SizedBox(height: 12),
                  Transform.translate(
                    offset: data.getOffset('date'),
                    child: Text(or(data.submissionDate, 'Date of Submission'),
                        style: sans(12, color: Colors.grey.shade500)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CertInfoBlock extends StatelessWidget {
  final Color accent;
  final String title;
  final List<String> items;
  const _CertInfoBlock({required this.accent, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w800, color: accent, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(item, style: GoogleFonts.libreBaskerville(fontSize: 12, color: const Color(0xFF2D3748), height: 1.6)),
            )),
        if (items.isEmpty)
          Text('___________', style: GoogleFonts.libreBaskerville(fontSize: 12, color: Colors.grey.shade400)),
      ],
    );
  }
}

class _TripleDivider extends StatelessWidget {
  final Color color;
  final bool thin;
  const _TripleDivider({required this.color, this.thin = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 0.8, color: color.withValues(alpha: 0.5)),
        SizedBox(height: thin ? 3 : 4),
        Container(height: thin ? 1.5 : 3, color: color),
        SizedBox(height: thin ? 3 : 4),
        Container(height: 0.8, color: color.withValues(alpha: 0.5)),
      ],
    );
  }
}

class _OrnateBorderPainter extends CustomPainter {
  final Color color;
  _OrnateBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final outerPaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.5;
    final innerPaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1;
    final cornerFill = Paint()..color = color..style = PaintingStyle.fill;
    final tickPaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1;

    const margin = 12.0;
    const innerMargin = 22.0;
    const cornerSize = 10.0;

    final outerRect = Rect.fromLTRB(margin, margin, size.width - margin, size.height - margin);
    final innerRect = Rect.fromLTRB(innerMargin, innerMargin, size.width - innerMargin, size.height - innerMargin);

    // Draw outer border
    canvas.drawRect(outerRect, outerPaint);
    // Draw inner border
    canvas.drawRect(innerRect, innerPaint);

    // Corner squares
    for (final c in [outerRect.topLeft, outerRect.topRight, outerRect.bottomLeft, outerRect.bottomRight]) {
      canvas.drawRect(
        Rect.fromCenter(center: c, width: cornerSize, height: cornerSize),
        cornerFill,
      );
    }

    // Tick marks along borders at intervals
    const interval = 60.0;
    const tickLen = 5.0;

    // Top and bottom ticks
    for (double x = outerRect.left + interval; x < outerRect.right - 10; x += interval) {
      // Top
      canvas.drawLine(Offset(x, outerRect.top), Offset(x, outerRect.top + tickLen), tickPaint);
      canvas.drawLine(Offset(x, innerRect.top), Offset(x, innerRect.top - tickLen), tickPaint);
      // Bottom
      canvas.drawLine(Offset(x, outerRect.bottom), Offset(x, outerRect.bottom - tickLen), tickPaint);
      canvas.drawLine(Offset(x, innerRect.bottom), Offset(x, innerRect.bottom + tickLen), tickPaint);
    }

    // Left and right ticks
    for (double y = outerRect.top + interval; y < outerRect.bottom - 10; y += interval) {
      // Left
      canvas.drawLine(Offset(outerRect.left, y), Offset(outerRect.left + tickLen, y), tickPaint);
      canvas.drawLine(Offset(innerRect.left, y), Offset(innerRect.left - tickLen, y), tickPaint);
      // Right
      canvas.drawLine(Offset(outerRect.right, y), Offset(outerRect.right - tickLen, y), tickPaint);
      canvas.drawLine(Offset(innerRect.right, y), Offset(innerRect.right + tickLen, y), tickPaint);
    }

    // Small diamond at midpoints of each side
    final diamonds = [
      Offset(size.width / 2, margin),
      Offset(size.width / 2, size.height - margin),
      Offset(margin, size.height / 2),
      Offset(size.width - margin, size.height / 2),
    ];
    for (final d in diamonds) {
      final dp = Path()
        ..moveTo(d.dx, d.dy - 6)
        ..lineTo(d.dx + 5, d.dy)
        ..lineTo(d.dx, d.dy + 6)
        ..lineTo(d.dx - 5, d.dy)
        ..close();
      canvas.drawPath(dp, cornerFill);
    }
  }

  @override
  bool shouldRepaint(_OrnateBorderPainter old) => old.color != color;
}

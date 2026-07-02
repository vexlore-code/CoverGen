import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';

class TemplateNeonDark extends StatelessWidget {
  final CoverPageData data;
  const TemplateNeonDark({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final accent = data.themeColor;
    final glow = accent.withValues(alpha: 0.7);
    const bg = Color(0xFF0A1628);
    const cardBg = Color(0xFF111F35);

    String or(String s, String fallback) => s.isEmpty ? fallback : s;

    TextStyle t(double sz, {FontWeight fw = FontWeight.normal, Color? color, double ls = 0}) =>
        GoogleFonts.inter(fontSize: sz, fontWeight: fw, color: color ?? Colors.white, letterSpacing: ls);

    return Material(
      color: bg,
      child: SizedBox(
        width: 794,
        height: 1123,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _GridPainter(color: const Color(0xFF1E3A5F))),
            ),
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [accent.withValues(alpha: 0.18), Colors.transparent]),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [accent.withValues(alpha: 0.12), Colors.transparent]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 52),
              child: Column(
                children: [
                  Transform.translate(
                    offset: data.getOffset('logo'),
                    child: Container(
                      width: data.logoSize + 28,
                      height: data.logoSize + 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: glow, blurRadius: 30, spreadRadius: 6),
                          BoxShadow(color: glow.withValues(alpha: 0.3), blurRadius: 60, spreadRadius: 12),
                        ],
                        border: Border.all(color: accent, width: 2),
                        color: bg,
                      ),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: LogoWidget(data: data, height: data.logoSize, fallbackColor: accent),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (data.universityName.isNotEmpty)
                    Text(data.universityName.toUpperCase(),
                        style: t(13, fw: FontWeight.w700, color: accent, ls: 2.5),
                        textAlign: TextAlign.center),
                  if (data.departmentName.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(data.departmentName, style: t(11, color: Colors.white60), textAlign: TextAlign.center),
                  ],
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.transparent, accent, accent, Colors.transparent]),
                      boxShadow: [BoxShadow(color: glow, blurRadius: 8)],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Transform.translate(
                    offset: data.getOffset('title'),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: accent, width: 1.5),
                            borderRadius: BorderRadius.circular(30),
                            color: accent.withValues(alpha: 0.1),
                            boxShadow: [BoxShadow(color: glow, blurRadius: 8)],
                          ),
                          child: Text(or(data.assignmentType, 'Assignment').toUpperCase(),
                              style: t(11, fw: FontWeight.w700, color: accent, ls: 2)),
                        ),
                        const SizedBox(height: 16),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: 698,
                            child: Text(or(data.assignmentTitle, 'Assignment Title'),
                                style: t(26, fw: FontWeight.w800), textAlign: TextAlign.center),
                          ),
                        ),
                        if (data.courseTitle.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('${data.courseTitle}  •  ${data.courseCode}',
                              style: t(12, color: Colors.white60), textAlign: TextAlign.center),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Transform.translate(
                          offset: data.getOffset('info_left'),
                          child: _NeonCard(
                            accent: accent,
                            cardBg: cardBg,
                            title: 'SUBMITTED BY',
                            items: data.isGroupSubmission
                                ? data.groupMembers.where((m) => m.name.isNotEmpty).map((m) => '${m.name}\n${m.id}').toList()
                                : [
                                    if (data.studentName.isNotEmpty) data.studentName,
                                    if (data.studentId.isNotEmpty) 'ID: ${data.studentId}',
                                    if (data.section.isNotEmpty) 'Section: ${data.section}',
                                    if (data.batch.isNotEmpty) 'Batch: ${data.batch}',
                                  ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (data.instructorInfoEnabled)
                        Expanded(
                          child: Transform.translate(
                            offset: data.getOffset('info_right'),
                            child: _NeonCard(
                              accent: accent,
                              cardBg: cardBg,
                              title: 'SUBMITTED TO',
                              items: [
                                if (data.teacherName.isNotEmpty) data.teacherName,
                                if (data.teacherDesignation.isNotEmpty) data.teacherDesignation,
                                if (data.teacherDepartment.isNotEmpty) data.teacherDepartment,
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Container(height: 1, color: Colors.white12),
                  const SizedBox(height: 12),
                  Transform.translate(
                    offset: data.getOffset('date'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 12, color: accent),
                        const SizedBox(width: 6),
                        Text('Submission Date: ${or(data.submissionDate, '__________')}',
                            style: t(11, color: Colors.white54)),
                      ],
                    ),
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

class _NeonCard extends StatelessWidget {
  final Color accent, cardBg;
  final String title;
  final List<String> items;
  const _NeonCard({required this.accent, required this.cardBg, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.4), width: 1),
        boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.1), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: accent, letterSpacing: 2)),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(item, style: GoogleFonts.inter(fontSize: 11, color: Colors.white70, height: 1.5)),
              )),
          if (items.isEmpty)
            Text('___________', style: GoogleFonts.inter(fontSize: 11, color: Colors.white30)),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..strokeWidth = 0.5;
    const step = 40.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';

class TemplateGeometric extends StatelessWidget {
  final CoverPageData data;
  const TemplateGeometric({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final accent = data.themeColor;
    String or(String s, String fb) => s.isEmpty ? fb : s;

    // University initials watermark
    final initials = data.universityName.isNotEmpty
        ? data.universityName.split(' ').where((w) => w.isNotEmpty).map((w) => w[0]).take(3).join()
        : 'MU';

    return Material(
      color: Colors.white,
      child: SizedBox(
        width: 794,
        height: 1123,
        child: Stack(
          children: [
            // Geometric background shapes
            Positioned.fill(
              child: CustomPaint(painter: _GeometricPainter(color: accent)),
            ),

            // Large initials watermark
            Positioned(
              left: -20,
              top: 250,
              child: Text(
                initials,
                style: GoogleFonts.robotoSlab(
                  fontSize: 220,
                  fontWeight: FontWeight.w900,
                  color: accent.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 60, 50, 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top-right logo area
                  Transform.translate(
                    offset: data.getOffset('logo'),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: data.logoSize + 24,
                        height: data.logoSize + 24,
                        decoration: BoxDecoration(
                          border: Border.all(color: accent, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: LogoWidget(data: data, height: data.logoSize, fallbackColor: accent),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Assignment type chip
                  Transform.translate(
                    offset: data.getOffset('title'),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            or(data.assignmentType, 'Assignment').toUpperCase(),
                            style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w700,
                                color: Colors.white, letterSpacing: 2),
                          ),
                        ),
                        const SizedBox(height: 14),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: 694,
                            child: Text(
                              or(data.assignmentTitle, 'Assignment Title'),
                              style: GoogleFonts.robotoSlab(
                                  fontSize: 28, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A2E)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(height: 2, width: 60, color: accent),
                        const SizedBox(height: 14),
                        if (data.courseTitle.isNotEmpty)
                          Text('${data.courseTitle}  |  ${data.courseCode}',
                              style: GoogleFonts.lato(fontSize: 13, color: Colors.grey.shade600),
                              textAlign: TextAlign.center),
                        if (data.universityName.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(data.universityName,
                              style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade500),
                              textAlign: TextAlign.center),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Info cards
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Transform.translate(
                          offset: data.getOffset('info_left'),
                          child: _GeoCard(
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
                      const SizedBox(width: 16),
                      if (data.instructorInfoEnabled)
                        Expanded(
                          child: Transform.translate(
                            offset: data.getOffset('info_right'),
                            child: _GeoCard(
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
                  ),

                  const Spacer(),

                  Transform.translate(
                    offset: data.getOffset('date'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 30, height: 1, color: accent),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(or(data.submissionDate, 'Date of Submission'),
                              style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade500)),
                        ),
                        Container(width: 30, height: 1, color: accent),
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

class _GeoCard extends StatelessWidget {
  final Color accent;
  final String title;
  final List<String> items;
  const _GeoCard({required this.accent, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
        color: accent.withValues(alpha: 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 4, height: 14, color: accent, margin: const EdgeInsets.only(right: 6)),
            Text(title,
                style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w800, color: accent, letterSpacing: 1.5)),
          ]),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(item, style: GoogleFonts.lato(fontSize: 12, color: const Color(0xFF2D3748), height: 1.5)),
              )),
          if (items.isEmpty)
            Text('___________', style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

class _GeometricPainter extends CustomPainter {
  final Color color;
  _GeometricPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()..color = color.withValues(alpha: 0.08)..style = PaintingStyle.fill;
    final strokePaint = Paint()..color = color.withValues(alpha: 0.25)..style = PaintingStyle.stroke..strokeWidth = 1.5;

    // Large filled circle top-left
    canvas.drawCircle(const Offset(-30, -30), 120, fillPaint);

    // Outlined circle bottom-right
    canvas.drawCircle(Offset(size.width + 40, size.height + 30), 90, strokePaint);

    // Three diagonal lines bottom-left corner
    final linePaint = Paint()..color = color.withValues(alpha: 0.15)..strokeWidth = 2..style = PaintingStyle.stroke;
    for (int i = 0; i < 3; i++) {
      final offset = i * 18.0;
      canvas.drawLine(Offset(0, size.height - 80 - offset), Offset(80 + offset, size.height), linePaint);
    }

    // Small accent square top-right
    canvas.drawRect(Rect.fromLTWH(size.width - 30, 0, 30, 30), Paint()..color = color.withValues(alpha: 0.15)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_GeometricPainter old) => old.color != color;
}

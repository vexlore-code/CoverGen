import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';

class TemplateMagazine extends StatelessWidget {
  final CoverPageData data;
  const TemplateMagazine({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final accent = data.themeColor;
    const headerFrac = 0.38;
    const pageW = 794.0;
    const pageH = 1123.0;
    const headerH = pageH * headerFrac;

    String or(String s, String fb) => s.isEmpty ? fb : s;

    TextStyle sans(double sz, {Color? color, FontWeight fw = FontWeight.normal, double ls = 0}) =>
        GoogleFonts.lato(fontSize: sz, color: color, fontWeight: fw, letterSpacing: ls);

    return Material(
      color: Colors.white,
      child: SizedBox(
        width: pageW,
        height: pageH,
        child: Stack(
          children: [
            // ── Colored header block ─────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: headerH,
              child: Stack(
                children: [
                  Container(color: accent),
                  // Subtle dot pattern on header
                  Positioned.fill(
                    child: CustomPaint(painter: _DotPatternPainter()),
                  ),
                ],
              ),
            ),

            // ── Thick color bar at fold ─────────────────────────────────────
            Positioned(
              top: headerH,
              left: 0,
              right: 0,
              child: Container(height: 6, color: accent),
            ),

            // ── Content ─────────────────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: headerH,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 32, 40, 20),
                child: Column(
                  children: [
                    Transform.translate(
                      offset: data.getOffset('logo'),
                      child: Container(
                        width: data.logoSize + 24,
                        height: data.logoSize + 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)],
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: LogoWidget(data: data, height: data.logoSize, fallbackColor: accent),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (data.universityName.isNotEmpty) ...[
                      Text(data.universityName,
                          style: sans(17, color: Colors.white, fw: FontWeight.w800),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                    ],
                    if (data.departmentName.isNotEmpty)
                      Text(data.departmentName,
                          style: sans(12, color: Colors.white70), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),

            // ── Body content below header ────────────────────────────────────
            Positioned(
              top: headerH + 6,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(44, 28, 44, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: data.getOffset('title'),
                      child: Column(
                        children: [
                          Text(
                            or(data.assignmentType, 'Assignment').toUpperCase(),
                            style: sans(10, color: accent, fw: FontWeight.w800, ls: 3),
                          ),
                          const SizedBox(height: 10),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: SizedBox(
                              width: 706,
                              child: Text(
                                or(data.assignmentTitle, 'Assignment Title'),
                                style: GoogleFonts.playfairDisplay(
                                    fontSize: 30, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A2E)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(height: 1, width: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 10),
                          if (data.courseTitle.isNotEmpty)
                            Text('${data.courseTitle}  ·  ${data.courseCode}',
                                style: sans(13, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    Container(height: 1, color: Colors.grey.shade200),
                    const SizedBox(height: 22),

                    // Info row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Transform.translate(
                            offset: data.getOffset('info_left'),
                            child: _MagInfoCol(
                              accent: accent,
                              title: 'Submitted By',
                              items: data.isGroupSubmission
                                  ? data.groupMembers.where((m) => m.name.isNotEmpty)
                                      .map((m) => '${m.name}  ${m.id}').toList()
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
                          Container(width: 1, height: 110, color: Colors.grey.shade200,
                              margin: const EdgeInsets.symmetric(horizontal: 20)),
                          Expanded(
                            child: Transform.translate(
                              offset: data.getOffset('info_right'),
                              child: _MagInfoCol(
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

                    Transform.translate(
                      offset: data.getOffset('date'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: accent.withValues(alpha: 0.2)),
                        ),
                        child: Text(or(data.submissionDate, 'Date of Submission'),
                            style: sans(12, color: accent, fw: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MagInfoCol extends StatelessWidget {
  final Color accent;
  final String title;
  final List<String> items;
  const _MagInfoCol({required this.accent, required this.title, required this.items});

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
              child: Text(item, style: GoogleFonts.lato(fontSize: 12, color: const Color(0xFF2D3748), height: 1.5)),
            )),
        if (items.isEmpty)
          Text('___________', style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade400)),
      ],
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withValues(alpha: 0.08)..style = PaintingStyle.fill;
    const sp = 20.0;
    for (double x = 0; x <= size.width; x += sp) {
      for (double y = 0; y <= size.height; y += sp) {
        canvas.drawCircle(Offset(x, y), 1.5, p);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPatternPainter old) => false;
}

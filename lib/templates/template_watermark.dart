import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';

class TemplateWatermark extends StatelessWidget {
  final CoverPageData data;
  const TemplateWatermark({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final accent = data.themeColor;
    String or(String s, String fb) => s.isEmpty ? fb : s;

    TextStyle serif(double sz, {FontWeight fw = FontWeight.normal, Color? color}) =>
        GoogleFonts.ebGaramond(fontSize: sz, fontWeight: fw, color: color ?? const Color(0xFF1A1A2E));

    TextStyle sans(double sz, {Color? color, FontWeight fw = FontWeight.normal, double ls = 0}) =>
        GoogleFonts.lato(fontSize: sz, color: color ?? const Color(0xFF333344), fontWeight: fw, letterSpacing: ls);

    final watermarkText = data.universityName.isNotEmpty ? data.universityName : 'UNIVERSITY';

    return Material(
      color: Colors.white,
      child: SizedBox(
        width: 794,
        height: 1123,
        child: Stack(
          children: [
            // ── Watermark layer ────────────────────────────────────────────
            Center(
              child: Transform.rotate(
                angle: -0.4,
                child: Text(
                  watermarkText,
                  style: GoogleFonts.ebGaramond(
                    fontSize: 110,
                    fontWeight: FontWeight.w900,
                    color: accent.withValues(alpha: 0.04),
                    letterSpacing: -2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ),

            // ── Double border ──────────────────────────────────────────────
            Positioned(
              top: 8, left: 8, right: 8, bottom: 8,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: accent, width: 2),
                ),
              ),
            ),
            Positioned(
              top: 16, left: 16, right: 16, bottom: 16,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: accent.withValues(alpha: 0.4), width: 0.8),
                ),
              ),
            ),

            // ── Main content ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(52, 52, 52, 44),
              child: Column(
                children: [
                  Transform.translate(
                    offset: data.getOffset('logo'),
                    child: LogoWidget(data: data, height: data.logoSize, fallbackColor: accent),
                  ),

                  const SizedBox(height: 16),

                  if (data.universityName.isNotEmpty) ...[
                    Text(data.universityName, style: serif(20, fw: FontWeight.w700),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                  ],

                  if (data.departmentName.isNotEmpty)
                    Text(data.departmentName,
                        style: serif(13, color: accent).copyWith(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center),

                  const SizedBox(height: 22),
                  _ThreeLine(color: accent),
                  const SizedBox(height: 28),

                  Transform.translate(
                    offset: data.getOffset('title'),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(border: Border.all(color: accent.withValues(alpha: 0.5))),
                          child: Column(
                            children: [
                              Text(or(data.assignmentType, 'Assignment').toUpperCase(),
                                  style: sans(9, color: accent, fw: FontWeight.w700, ls: 2.5)),
                              const SizedBox(height: 8),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: SizedBox(
                                  width: 650,
                                  child: Text(or(data.assignmentTitle, 'Assignment Title'),
                                      style: serif(24, fw: FontWeight.w700), textAlign: TextAlign.center),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (data.courseTitle.isNotEmpty)
                          Text('${data.courseTitle}  —  ${data.courseCode}',
                              style: sans(13, color: Colors.grey.shade600)),
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
                          child: _WmInfoBlock(
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
                        Container(width: 1, height: 110, color: accent.withValues(alpha: 0.2),
                            margin: const EdgeInsets.symmetric(horizontal: 20)),
                        Expanded(
                          child: Transform.translate(
                            offset: data.getOffset('info_right'),
                            child: _WmInfoBlock(
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

                  _ThreeLine(color: accent),
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

class _ThreeLine extends StatelessWidget {
  final Color color;
  const _ThreeLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 0.8, color: color.withValues(alpha: 0.5)),
        const SizedBox(height: 4),
        Container(height: 2.5, color: color),
        const SizedBox(height: 4),
        Container(height: 0.8, color: color.withValues(alpha: 0.5)),
      ],
    );
  }
}

class _WmInfoBlock extends StatelessWidget {
  final Color accent;
  final String title;
  final List<String> items;
  const _WmInfoBlock({required this.accent, required this.title, required this.items});

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
              child: Text(item, style: GoogleFonts.ebGaramond(fontSize: 13, color: const Color(0xFF2D3748), height: 1.5)),
            )),
        if (items.isEmpty)
          Text('___________', style: GoogleFonts.ebGaramond(fontSize: 13, color: Colors.grey.shade400)),
      ],
    );
  }
}

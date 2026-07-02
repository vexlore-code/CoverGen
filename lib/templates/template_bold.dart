import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';
import '../widgets/page_canvas.dart';

/// Bold Banner — big color banner top and bottom, high contrast, eye-catching.
class TemplateBold extends StatelessWidget {
  final CoverPageData data;
  const TemplateBold({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF8B1E3F); // crimson
    const dark = Color(0xFF1A1A2E);
    return PageCanvas(
      color: Colors.white,
      child: SizedBox(
        width: 794,
        height: 1123,
        child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [dark, primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(36),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (data.logoImage != null || data.useBundledMuLogo)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: LogoWidget(data: data, height: 80, fallbackColor: Colors.white),
                    ),
                  )
                else
                  const Icon(Icons.school, size: 70, color: Colors.white),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.universityName.isEmpty ? 'University Name' : data.universityName,
                        style: GoogleFonts.montserrat(
                            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.departmentName.isEmpty ? 'Department Name' : data.departmentName,
                        style: GoogleFonts.montserrat(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.assignmentType.toUpperCase(),
                    style: GoogleFonts.montserrat(
                        fontSize: 13, letterSpacing: 3, color: primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.assignmentTitle.isEmpty ? 'Title of the Assignment' : data.assignmentTitle,
                    style: GoogleFonts.montserrat(
                        fontSize: 28, fontWeight: FontWeight.bold, color: dark, height: 1.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${data.courseTitle.isEmpty ? 'Course Title' : data.courseTitle}'
                    '${data.courseCode.isNotEmpty ? "  |  ${data.courseCode}" : ""}',
                    style: GoogleFonts.montserrat(fontSize: 15, color: Colors.black54),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: _Card(
                          title: 'Submitted By',
                          color: primary,
                          lines: [
                            data.studentName.isEmpty ? 'Student Name' : data.studentName,
                            'ID: ${data.studentId.isEmpty ? '---' : data.studentId}',
                            if (data.section.isNotEmpty) 'Section: ${data.section}',
                            if (data.semester.isNotEmpty) 'Semester: ${data.semester}',
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _Card(
                          title: 'Submitted To',
                          color: dark,
                          lines: [
                            data.teacherName.isEmpty ? 'Teacher Name' : data.teacherName,
                            if (data.teacherDesignation.isNotEmpty) data.teacherDesignation,
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (data.submissionDate.isNotEmpty)
                    Text('Date of Submission: ${data.submissionDate}',
                        style: GoogleFonts.montserrat(fontSize: 12, color: Colors.black45)),
                ],
              ),
            ),
          ),
          Container(height: 14, color: primary),
        ],
      ),
      ),
    ),
  );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Color color;
  final List<String> lines;
  const _Card({required this.title, required this.color, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.montserrat(
                  fontSize: 11, letterSpacing: 1.5, color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...lines.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(l, style: GoogleFonts.montserrat(fontSize: 13, color: Colors.black87)),
              )),
        ],
      ),
    );
  }
}

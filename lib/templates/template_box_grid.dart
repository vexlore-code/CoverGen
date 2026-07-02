import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';
import '../widgets/page_canvas.dart';

/// Box Grid — info organized into soft bordered cards (not a data table),
/// with a clean two-column grid layout. Good for a contemporary look.
class TemplateBoxGrid extends StatelessWidget {
  final CoverPageData data;
  const TemplateBoxGrid({super.key, required this.data});

  static const accent = Color(0xFF7C3AED); // violet

  @override
  Widget build(BuildContext context) {
    return PageCanvas(
      color: const Color(0xFFFAFAFC),
      child: SizedBox(
        width: 794,
        height: 1123,
        child: Container(
      padding: const EdgeInsets.all(44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LogoWidget(data: data, height: 60, fallbackColor: accent),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.universityName.isEmpty ? 'University Name' : data.universityName,
                        style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(data.departmentName.isEmpty ? 'Department Name' : data.departmentName,
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.assignmentType.toUpperCase(),
                    style: GoogleFonts.inter(fontSize: 11, letterSpacing: 2, color: accent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(data.assignmentTitle.isEmpty ? 'Title of the Assignment' : data.assignmentTitle,
                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  '${data.courseTitle.isEmpty ? 'Course Title' : data.courseTitle}'
                  '${data.courseCode.isNotEmpty ? "  ·  ${data.courseCode}" : ""}',
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Card(
                  title: 'Student',
                  rows: {
                    'Name': data.studentName,
                    'ID': data.studentId,
                    'Section': data.section,
                    'Semester': data.semester,
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _Card(
                  title: 'Instructor',
                  rows: {
                    'Name': data.teacherName,
                    'Designation': data.teacherDesignation,
                    'Department': data.teacherDepartment,
                  },
                ),
              ),
            ],
          ),
          const Spacer(),
          if (data.submissionDate.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Date of Submission: ${data.submissionDate}',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.black87)),
            ),
        ],
      ),
      ),
    ),
  );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Map<String, String> rows;
  const _Card({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: TemplateBoxGrid.accent)),
          const SizedBox(height: 10),
          ...rows.entries.where((e) => e.value.isNotEmpty).map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${e.key}: ',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54),
                        ),
                        TextSpan(
                          text: e.value,
                          style: GoogleFonts.inter(fontSize: 12.5, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

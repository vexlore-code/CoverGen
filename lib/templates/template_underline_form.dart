import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';
import '../widgets/page_canvas.dart';

/// Underline Fill-in — the familiar "handwritten form" look: labels with
/// dotted/underlined blanks filled by the value, double border frame.
class TemplateUnderlineForm extends StatelessWidget {
  final CoverPageData data;
  const TemplateUnderlineForm({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final label = GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87);

    return PageCanvas(
      color: Colors.white,
      child: SizedBox(
        width: 794,
        height: 1123,
        child: Container(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2.5)),
        margin: const EdgeInsets.all(6),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
          padding: const EdgeInsets.fromLTRB(50, 44, 50, 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LogoWidget(data: data, height: 85, fallbackColor: Colors.black87),
              const SizedBox(height: 8),
              Text(
                data.universityName.isEmpty ? 'University Name' : data.universityName,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                data.departmentName.isEmpty ? 'Department Name' : data.departmentName,
                style: GoogleFonts.notoSans(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 36),
              Text(data.assignmentType.toUpperCase(),
                  style: GoogleFonts.notoSans(fontSize: 13, letterSpacing: 3, color: Colors.black45)),
              const SizedBox(height: 40),
              _UnderlineField(label, 'Course Title', data.courseTitle),
              _UnderlineField(label, 'Course Code', data.courseCode),
              _UnderlineField(label, 'Topic / Title', data.assignmentTitle),
              const SizedBox(height: 24),
              _UnderlineField(label, 'Student Name', data.studentName),
              _UnderlineField(label, 'Student ID', data.studentId),
              _UnderlineField(label, 'Section', data.section),
              _UnderlineField(label, 'Semester', data.semester),
              const SizedBox(height: 24),
              _UnderlineField(label, 'Instructor Name', data.teacherName),
              _UnderlineField(label, 'Designation', data.teacherDesignation),
              const Spacer(),
              _UnderlineField(label, 'Date of Submission', data.submissionDate),
            ],
          ),
        ),
      ),
      ),
    ),
  );
  }
}

class _UnderlineField extends StatelessWidget {
  final TextStyle labelStyle;
  final String label;
  final String value;
  const _UnderlineField(this.labelStyle, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: 150, child: Text('$label:', style: labelStyle)),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black45, width: 1)),
              ),
              child: Text(
                value.isEmpty ? ' ' : value,
                style: GoogleFonts.notoSans(fontSize: 14, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

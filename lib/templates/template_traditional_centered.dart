import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';
import '../widgets/page_canvas.dart';

/// Traditional Centered — the classic "everything centered, plain text,
/// no borders/tables" cover page most students grew up submitting.
class TemplateTraditionalCentered extends StatelessWidget {
  final CoverPageData data;
  const TemplateTraditionalCentered({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final normal = GoogleFonts.tinos(fontSize: 15, color: Colors.black87);
    final bold = GoogleFonts.tinos(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87);

    return PageCanvas(
      color: Colors.white,
      child: SizedBox(
        width: 794,
        height: 1123,
        child: Container(
      padding: const EdgeInsets.fromLTRB(80, 70, 80, 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LogoWidget(data: data, height: 100, fallbackColor: Colors.black87),
          const SizedBox(height: 14),
          Text(
            data.universityName.isEmpty ? 'University Name' : data.universityName,
            textAlign: TextAlign.center,
            style: GoogleFonts.tinos(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            data.departmentName.isEmpty ? 'Department Name' : data.departmentName,
            style: GoogleFonts.tinos(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 70),
          Text(
            data.assignmentTitle.isEmpty ? 'Title of the Assignment' : data.assignmentTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.tinos(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Course: ${data.courseTitle.isEmpty ? '________' : data.courseTitle}'
            '${data.courseCode.isNotEmpty ? "  |  ${data.courseCode}" : ""}',
            style: normal,
          ),
          const SizedBox(height: 60),
          Text('Submitted by', style: bold),
          const SizedBox(height: 6),
          Text(data.studentName.isEmpty ? 'Student Name' : data.studentName, style: normal),
          Text('ID: ${data.studentId.isEmpty ? '---' : data.studentId}'
              '${data.section.isNotEmpty ? "   Section: ${data.section}" : ""}', style: normal),
          if (data.semester.isNotEmpty) Text('Semester: ${data.semester}', style: normal),
          const SizedBox(height: 40),
          Text('Submitted to', style: bold),
          const SizedBox(height: 6),
          Text(data.teacherName.isEmpty ? 'Teacher Name' : data.teacherName, style: normal),
          if (data.teacherDesignation.isNotEmpty) Text(data.teacherDesignation, style: normal),
          const Spacer(),
          Text(
            data.submissionDate.isEmpty ? 'Date of Submission' : 'Date of Submission: ${data.submissionDate}',
            style: normal,
          ),
        ],
      ),
      ),
    ),
  );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';
import '../widgets/page_canvas.dart';

/// Minimal Elegant — lots of white space, thin rule lines, top-left logo.
class TemplateMinimal extends StatelessWidget {
  final CoverPageData data;
  const TemplateMinimal({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return PageCanvas(
      color: Colors.white,
      child: SizedBox(
        width: 794,
        height: 1123,
        child: Container(
      padding: const EdgeInsets.fromLTRB(60, 60, 60, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LogoWidget(data: data, height: 50, fallbackColor: Colors.grey.shade700),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.universityName.isEmpty ? 'University Name' : data.universityName,
                      style: GoogleFonts.workSans(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      data.departmentName.isEmpty ? 'Department Name' : data.departmentName,
                      style: GoogleFonts.workSans(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 1, width: double.infinity),
          Container(height: 1, color: Colors.black12, margin: const EdgeInsets.only(top: 16)),
          const Spacer(flex: 3),
          Text(
            data.assignmentType.toUpperCase(),
            style: GoogleFonts.workSans(fontSize: 13, letterSpacing: 4, color: Colors.black45),
          ),
          const SizedBox(height: 16),
          Text(
            data.assignmentTitle.isEmpty ? 'Title of the\nAssignment' : data.assignmentTitle,
            style: GoogleFonts.workSans(
                fontSize: 40, fontWeight: FontWeight.bold, height: 1.2, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Text(
            '${data.courseTitle.isEmpty ? 'Course Title' : data.courseTitle}'
            '${data.courseCode.isNotEmpty ? " · ${data.courseCode}" : ""}',
            style: GoogleFonts.workSans(fontSize: 16, color: Colors.black54),
          ),
          const Spacer(flex: 4),
          Container(height: 1, color: Colors.black12, margin: const EdgeInsets.only(bottom: 24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STUDENT',
                      style: GoogleFonts.workSans(
                          fontSize: 10, letterSpacing: 2, color: Colors.black38)),
                  const SizedBox(height: 6),
                  Text(data.studentName.isEmpty ? 'Student Name' : data.studentName,
                      style: GoogleFonts.workSans(fontSize: 14, fontWeight: FontWeight.w600)),
                  Text('ID: ${data.studentId.isEmpty ? '---' : data.studentId}'
                      '${data.section.isNotEmpty ? "  ·  Sec: ${data.section}" : ""}',
                      style: GoogleFonts.workSans(fontSize: 12, color: Colors.black54)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('INSTRUCTOR',
                      style: GoogleFonts.workSans(
                          fontSize: 10, letterSpacing: 2, color: Colors.black38)),
                  const SizedBox(height: 6),
                  Text(data.teacherName.isEmpty ? 'Teacher Name' : data.teacherName,
                      style: GoogleFonts.workSans(fontSize: 14, fontWeight: FontWeight.w600)),
                  if (data.submissionDate.isNotEmpty)
                    Text(data.submissionDate,
                        style: GoogleFonts.workSans(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ],
          ),
        ],
      ),
      ),
    ),
  );
  }
}

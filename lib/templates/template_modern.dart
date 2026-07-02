import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';
import '../widgets/page_canvas.dart';

/// Modern Sidebar — colored left sidebar with accent block, right side content.
class TemplateModern extends StatelessWidget {
  final CoverPageData data;
  const TemplateModern({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF1E3A5F); // deep navy accent
    return PageCanvas(
      child: SizedBox(
        width: 794,
        height: 1123,
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 220,
            color: accent,
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.logoImage != null || data.useBundledMuLogo)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 70,
                      width: 70,
                      child: LogoWidget(data: data, height: 70, fallbackColor: Colors.white),
                    ),
                  )
                else
                  const Icon(Icons.school, size: 60, color: Colors.white),
                const SizedBox(height: 40),
                Text('SUBMITTED BY',
                    style: GoogleFonts.poppins(
                        fontSize: 11, letterSpacing: 2, color: Colors.white60)),
                const SizedBox(height: 8),
                Text(data.studentName.isEmpty ? 'Student Name' : data.studentName,
                    style: GoogleFonts.poppins(
                        fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
                Text('ID: ${data.studentId.isEmpty ? '---' : data.studentId}',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
                if (data.section.isNotEmpty)
                  Text('Section: ${data.section}',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 32),
                Text('SUBMITTED TO',
                    style: GoogleFonts.poppins(
                        fontSize: 11, letterSpacing: 2, color: Colors.white60)),
                const SizedBox(height: 8),
                Text(data.teacherName.isEmpty ? 'Teacher Name' : data.teacherName,
                    style: GoogleFonts.poppins(
                        fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
                if (data.teacherDesignation.isNotEmpty)
                  Text(data.teacherDesignation,
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
                const Spacer(),
                Text(data.submissionDate.isEmpty ? '' : data.submissionDate,
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.universityName.isEmpty ? 'University Name' : data.universityName,
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w600, color: accent),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.departmentName.isEmpty ? 'Department Name' : data.departmentName,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 60),
                  Container(height: 6, width: 60, color: accent),
                  const SizedBox(height: 20),
                  Text(
                    data.assignmentType.toUpperCase(),
                    style: GoogleFonts.poppins(
                        fontSize: 13, letterSpacing: 3, color: Colors.black45),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.assignmentTitle.isEmpty ? 'Title of the Assignment Goes Here' : data.assignmentTitle,
                    style: GoogleFonts.poppins(
                        fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.3),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Course: ${data.courseTitle.isEmpty ? '________________' : data.courseTitle}'
                    '${data.courseCode.isNotEmpty ? "  (${data.courseCode})" : ""}',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                  ),
                  if (data.semester.isNotEmpty)
                    Text('Semester: ${data.semester}',
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
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

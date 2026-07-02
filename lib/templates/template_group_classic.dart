import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';
import '../widgets/page_canvas.dart';
import '../widgets/group_members_table.dart';

/// Group Table Classic — formal bordered page, group members shown in a
/// table (SL / Name / ID) instead of a single student block.
class TemplateGroupClassic extends StatelessWidget {
  final CoverPageData data;
  const TemplateGroupClassic({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return PageCanvas(
      color: Colors.white,
      child: SizedBox(
        width: 794,
        height: 1123,
        child: Container(
      padding: const EdgeInsets.all(36),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black87, width: 1.5)),
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoWidget(data: data, height: 90, fallbackColor: Colors.blueGrey.shade700),
            const SizedBox(height: 12),
            Text(
              data.universityName.isEmpty ? 'UNIVERSITY NAME' : data.universityName.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.merriweather(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              data.departmentName.isEmpty ? 'Department Name' : data.departmentName,
              style: GoogleFonts.merriweather(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            Text(
              data.assignmentType.toUpperCase(),
              style: GoogleFonts.merriweather(fontSize: 13, letterSpacing: 3, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              data.assignmentTitle.isEmpty ? 'Title of the Report' : data.assignmentTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.merriweather(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              '${data.courseTitle.isEmpty ? 'Course Title' : data.courseTitle}'
              '${data.courseCode.isNotEmpty ? "  (${data.courseCode})" : ""}',
              style: GoogleFonts.merriweather(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 34),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Submitted By (Group Members)',
                  style: GoogleFonts.merriweather(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            GroupMembersTable(data: data, accent: const Color(0xFF34495E)),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Submitted To',
                      style: GoogleFonts.merriweather(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(data.teacherName.isEmpty ? 'Teacher Name' : data.teacherName,
                      style: GoogleFonts.merriweather(fontSize: 13)),
                  if (data.teacherDesignation.isNotEmpty)
                    Text(data.teacherDesignation, style: GoogleFonts.merriweather(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
            const Spacer(),
            Text(
              data.submissionDate.isEmpty ? 'Date of Submission' : 'Date of Submission: ${data.submissionDate}',
              style: GoogleFonts.merriweather(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
      ),
    ),
  );
  }
}

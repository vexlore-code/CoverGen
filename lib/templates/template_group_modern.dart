import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';
import '../widgets/page_canvas.dart';
import '../widgets/group_members_table.dart';

/// Group Table Modern — colored top banner + group members table with a
/// teal accent. Good for project/term-paper group submissions.
class TemplateGroupModern extends StatelessWidget {
  final CoverPageData data;
  const TemplateGroupModern({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF0F766E); // teal
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
            color: accent,
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                LogoWidget(data: data, height: 70, fallbackColor: Colors.white),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.universityName.isEmpty ? 'University Name' : data.universityName,
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        data.departmentName.isEmpty ? 'Department Name' : data.departmentName,
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.assignmentType.toUpperCase(),
                      style: GoogleFonts.poppins(fontSize: 12, letterSpacing: 3, color: accent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    data.assignmentTitle.isEmpty ? 'Group Project Title' : data.assignmentTitle,
                    style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${data.courseTitle.isEmpty ? 'Course Title' : data.courseTitle}'
                    '${data.courseCode.isNotEmpty ? "  |  ${data.courseCode}" : ""}',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 34),
                  Text('Group Members', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: accent)),
                  const SizedBox(height: 10),
                  GroupMembersTable(data: data, accent: accent),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SUBMITTED TO', style: GoogleFonts.poppins(fontSize: 10, letterSpacing: 2, color: Colors.black45)),
                          const SizedBox(height: 4),
                          Text(data.teacherName.isEmpty ? 'Teacher Name' : data.teacherName,
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                          if (data.teacherDesignation.isNotEmpty)
                            Text(data.teacherDesignation, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54)),
                        ],
                      ),
                      if (data.submissionDate.isNotEmpty)
                        Text(data.submissionDate, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(height: 10, color: accent),
        ],
      ),
      ),
    ),
  );
  }
}

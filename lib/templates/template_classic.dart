import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';
import '../widgets/page_canvas.dart';

/// Classic Formal — centered text, thin borders, traditional academic look.
class TemplateClassic extends StatelessWidget {
  final CoverPageData data;
  const TemplateClassic({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return PageCanvas(
      child: Padding(
      padding: const EdgeInsets.all(40),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              LogoWidget(data: data, height: 100, fallbackColor: Colors.blueGrey.shade700),
              const SizedBox(height: 16),
              Text(
                data.universityName.isEmpty ? 'UNIVERSITY NAME' : data.universityName.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.merriweather(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.departmentName.isEmpty ? 'Department Name' : data.departmentName,
                textAlign: TextAlign.center,
                style: GoogleFonts.merriweather(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                ),
                child: Column(
                  children: [
                    Text(
                      data.assignmentType.toUpperCase(),
                      style: GoogleFonts.merriweather(
                          fontSize: 14, letterSpacing: 3, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data.assignmentTitle.isEmpty ? 'Title of the Assignment' : data.assignmentTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.merriweather(
                          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _InfoBlock(
                      title: 'Submitted By',
                      lines: [
                        'Name: ${data.studentName.isEmpty ? '________________' : data.studentName}',
                        'ID: ${data.studentId.isEmpty ? '________________' : data.studentId}',
                        if (data.section.isNotEmpty) 'Section: ${data.section}',
                        if (data.semester.isNotEmpty) 'Semester: ${data.semester}',
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _InfoBlock(
                      title: 'Submitted To',
                      lines: [
                        'Name: ${data.teacherName.isEmpty ? '________________' : data.teacherName}',
                        if (data.teacherDesignation.isNotEmpty) data.teacherDesignation,
                        'Course: ${data.courseTitle.isEmpty ? '________________' : data.courseTitle}',
                        if (data.courseCode.isNotEmpty) 'Code: ${data.courseCode}',
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Text(
                data.submissionDate.isEmpty ? 'Date of Submission' : 'Date of Submission: ${data.submissionDate}',
                style: GoogleFonts.merriweather(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final List<String> lines;
  const _InfoBlock({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.merriweather(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        ...lines.map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(l, style: GoogleFonts.merriweather(fontSize: 13, color: Colors.black87)),
            )),
      ],
    );
  }
}

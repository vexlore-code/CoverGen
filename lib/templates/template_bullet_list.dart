import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';
import '../widgets/logo_widget.dart';
import '../widgets/page_canvas.dart';

/// Bullet List (MU Style) — matches the common Metropolitan University
/// lab-report cover format: centered logo on top, then plain bold-label
/// bullet lists for Instructor Information / Student Information, a Topic
/// block, and a Date line. No borders, no tables — just clean text.
class TemplateBulletList extends StatelessWidget {
  final CoverPageData data;
  const TemplateBulletList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.notoSans(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87);
    final valueStyle = GoogleFonts.notoSans(fontSize: 15, color: Colors.black87);
    final headingStyle = GoogleFonts.notoSans(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87);

    return PageCanvas(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(70, 60, 70, 60),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: LogoWidget(data: data, height: 110)),
          const SizedBox(height: 4),
          if (data.universityName.isNotEmpty)
            Center(
              child: Text(data.universityName,
                  style: GoogleFonts.notoSans(fontSize: 14, color: Colors.black54)),
            ),
          const SizedBox(height: 44),

          Text('Instructor Information', style: headingStyle),
          const SizedBox(height: 12),
          _Bullet(labelStyle, valueStyle, 'Name:', data.teacherName),
          _Bullet(labelStyle, valueStyle, 'Designation:', data.teacherDesignation),
          _Bullet(labelStyle, valueStyle, 'Department:', data.teacherDepartment),
          _Bullet(labelStyle, valueStyle, 'Institution:',
              data.universityName.isEmpty ? 'Metropolitan University' : data.universityName),

          const SizedBox(height: 40),
          Text('Student Information', style: headingStyle),
          const SizedBox(height: 12),
          _Bullet(labelStyle, valueStyle, 'Name:', data.studentName),
          _Bullet(labelStyle, valueStyle, 'ID:', data.studentId),
          _Bullet(labelStyle, valueStyle, 'Section:', data.section),
          _Bullet(labelStyle, valueStyle, 'Subject:', data.courseTitle),
          _Bullet(labelStyle, valueStyle, 'Course Code:', data.courseCode),
          _Bullet(labelStyle, valueStyle, 'Department:', data.departmentName),
          _Bullet(labelStyle, valueStyle, 'Batch:', data.batch),

          const SizedBox(height: 40),
          Text('Topic', style: headingStyle),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '${data.assignmentType}: ', style: labelStyle),
                TextSpan(
                    text: data.assignmentTitle.isEmpty ? 'Title of the report' : data.assignmentTitle,
                    style: valueStyle),
              ],
            ),
          ),

          const SizedBox(height: 40),
          Text(
            'Date Of Submission: ${data.submissionDate.isEmpty ? '__________' : data.submissionDate}',
            style: labelStyle,
          ),
        ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final String label;
  final String value;
  const _Bullet(this.labelStyle, this.valueStyle, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty && label == 'Batch:') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: labelStyle),
          Text(label, style: labelStyle),
          const SizedBox(width: 6),
          Expanded(child: Text(value.isEmpty ? '....' : value, style: valueStyle)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cover_page_data.dart';

/// A bordered table listing group members' name + ID — used by group-style
/// templates. `accent` tints the header row.
class GroupMembersTable extends StatelessWidget {
  final CoverPageData data;
  final Color accent;
  final Color headerTextColor;
  const GroupMembersTable({
    super.key,
    required this.data,
    this.accent = const Color(0xFF1E3A5F),
    this.headerTextColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final members = data.groupMembers;
    return Table(
      border: TableBorder.all(color: Colors.black26, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(0.6),
        1: FlexColumnWidth(2.4),
        2: FlexColumnWidth(1.4),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: accent),
          children: [
            _cell('SL', bold: true, color: headerTextColor),
            _cell('Name', bold: true, color: headerTextColor),
            _cell('ID', bold: true, color: headerTextColor),
          ],
        ),
        for (int i = 0; i < members.length; i++)
          TableRow(
            children: [
              _cell('${i + 1}'),
              _cell(members[i].name.isEmpty ? '-' : members[i].name),
              _cell(members[i].id.isEmpty ? '-' : members[i].id),
            ],
          ),
      ],
    );
  }

  Widget _cell(String text, {bool bold = false, Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Text(
        text,
        style: GoogleFonts.notoSans(
          fontSize: 12.5,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ),
    );
  }
}

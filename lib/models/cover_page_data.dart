import 'dart:io';
import 'package:flutter/material.dart';

/// Represents one row in a group-members table.
class GroupMember {
  String name;
  String id;
  GroupMember({this.name = '', this.id = ''});
}

/// Holds every field a user can fill in for a cover page.
/// Not every template uses every field — templates pick what they need.
class CoverPageData {
  // ── Institution ──────────────────────────────────────────────────────────
  String universityName;
  String departmentName;
  bool showInstitutionDetails; // whether institution name/dept fields are shown in form

  // ── Assignment ───────────────────────────────────────────────────────────
  String courseTitle;
  String courseCode;
  String assignmentTitle;
  String assignmentType; // 'Assignment', 'Lab Report', 'Term Paper', etc.

  // ── Student ───────────────────────────────────────────────────────────────
  String studentName;
  String studentId;
  String section;
  String semester;
  String batch;

  // ── Instructor ────────────────────────────────────────────────────────────
  String teacherName;
  String teacherDesignation;
  String teacherDepartment;
  bool instructorInfoEnabled; // whether the instructor section is shown

  // ── Date ──────────────────────────────────────────────────────────────────
  String submissionDate;

  // ── Logo ──────────────────────────────────────────────────────────────────
  File? logoImage;           // user-uploaded logo file
  bool useBundledMuLogo;     // use the bundled MU logo asset

  // ── Template / Design ─────────────────────────────────────────────────────
  int templateIndex;
  String fontFamily;         // e.g. 'Merriweather', 'Playfair Display', …
  double fontSize;           // base font size for cover content
  double logoSize;           // height of the logo widget in the cover
  int themeColorValue;       // ARGB int — use themeColor getter for Color object
  String borderStyle;        // 'none' | 'single' | 'double' | 'dashed' | 'shadow'
  String pageFormat;         // 'A4' | 'Letter' | 'A3'

  // ── Group ─────────────────────────────────────────────────────────────────
  bool isGroupSubmission;
  List<GroupMember> groupMembers;

  // ── Drag-and-drop element offsets ─────────────────────────────────────────
  final Map<String, Offset> _offsets;

  CoverPageData({
    this.universityName = '',
    this.departmentName = '',
    this.showInstitutionDetails = false,
    this.courseTitle = '',
    this.courseCode = '',
    this.assignmentTitle = '',
    this.assignmentType = 'Assignment',
    this.studentName = '',
    this.studentId = '',
    this.section = '',
    this.semester = '',
    this.batch = '',
    this.teacherName = '',
    this.teacherDesignation = '',
    this.teacherDepartment = '',
    this.instructorInfoEnabled = true,
    this.submissionDate = '',
    this.logoImage,
    this.useBundledMuLogo = false,
    this.templateIndex = 0,
    this.fontFamily = 'Merriweather',
    this.fontSize = 14.0,
    this.logoSize = 80.0,
    this.themeColorValue = 0xFF1E3A5F,
    this.borderStyle = 'none',
    this.pageFormat = 'A4',
    this.isGroupSubmission = false,
    List<GroupMember>? groupMembers,
    Map<String, Offset>? offsets,
  })  : groupMembers = groupMembers ?? [GroupMember(), GroupMember()],
        _offsets = offsets ?? {};

  // ── Convenience getters ───────────────────────────────────────────────────
  Color get themeColor => Color(themeColorValue);

  /// Returns the stored pixel offset for a named draggable element.
  Offset getOffset(String key) => _offsets[key] ?? Offset.zero;

  /// Page dimensions in logical pixels (A4 at 96dpi as baseline).
  Size get pageDimensions {
    switch (pageFormat) {
      case 'Letter':
        return const Size(816, 1056);
      case 'A3':
        return const Size(1123, 1587);
      default: // A4
        return const Size(794, 1123);
    }
  }

  Map<String, Offset> get offsets => _offsets;

  CoverPageData copyWith({
    String? universityName,
    String? departmentName,
    bool? showInstitutionDetails,
    String? courseTitle,
    String? courseCode,
    String? assignmentTitle,
    String? assignmentType,
    String? studentName,
    String? studentId,
    String? section,
    String? semester,
    String? batch,
    String? teacherName,
    String? teacherDesignation,
    String? teacherDepartment,
    bool? instructorInfoEnabled,
    String? submissionDate,
    File? logoImage,
    bool? useBundledMuLogo,
    int? templateIndex,
    String? fontFamily,
    double? fontSize,
    double? logoSize,
    int? themeColorValue,
    String? borderStyle,
    String? pageFormat,
    bool? isGroupSubmission,
    List<GroupMember>? groupMembers,
    Map<String, Offset>? offsets,
  }) {
    return CoverPageData(
      universityName: universityName ?? this.universityName,
      departmentName: departmentName ?? this.departmentName,
      showInstitutionDetails: showInstitutionDetails ?? this.showInstitutionDetails,
      courseTitle: courseTitle ?? this.courseTitle,
      courseCode: courseCode ?? this.courseCode,
      assignmentTitle: assignmentTitle ?? this.assignmentTitle,
      assignmentType: assignmentType ?? this.assignmentType,
      studentName: studentName ?? this.studentName,
      studentId: studentId ?? this.studentId,
      section: section ?? this.section,
      semester: semester ?? this.semester,
      batch: batch ?? this.batch,
      teacherName: teacherName ?? this.teacherName,
      teacherDesignation: teacherDesignation ?? this.teacherDesignation,
      teacherDepartment: teacherDepartment ?? this.teacherDepartment,
      instructorInfoEnabled: instructorInfoEnabled ?? this.instructorInfoEnabled,
      submissionDate: submissionDate ?? this.submissionDate,
      logoImage: logoImage ?? this.logoImage,
      useBundledMuLogo: useBundledMuLogo ?? this.useBundledMuLogo,
      templateIndex: templateIndex ?? this.templateIndex,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      logoSize: logoSize ?? this.logoSize,
      themeColorValue: themeColorValue ?? this.themeColorValue,
      borderStyle: borderStyle ?? this.borderStyle,
      pageFormat: pageFormat ?? this.pageFormat,
      isGroupSubmission: isGroupSubmission ?? this.isGroupSubmission,
      groupMembers: groupMembers ?? this.groupMembers,
      offsets: offsets ?? Map.from(_offsets),
    );
  }
}

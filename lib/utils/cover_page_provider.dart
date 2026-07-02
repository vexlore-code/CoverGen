import 'dart:io';
import 'package:flutter/material.dart';
import '../models/cover_page_data.dart';

class CoverPageProvider extends ChangeNotifier {
  CoverPageData data = CoverPageData();

  // ── Core content update ──────────────────────────────────────────────────
  void update({
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
  }) {
    data = data.copyWith(
      universityName: universityName,
      departmentName: departmentName,
      showInstitutionDetails: showInstitutionDetails,
      courseTitle: courseTitle,
      courseCode: courseCode,
      assignmentTitle: assignmentTitle,
      assignmentType: assignmentType,
      studentName: studentName,
      studentId: studentId,
      section: section,
      semester: semester,
      batch: batch,
      teacherName: teacherName,
      teacherDesignation: teacherDesignation,
      teacherDepartment: teacherDepartment,
      instructorInfoEnabled: instructorInfoEnabled,
      submissionDate: submissionDate,
    );
    notifyListeners();
  }

  // ── Logo ─────────────────────────────────────────────────────────────────
  void setLogo(File? file) {
    data = data.copyWith(logoImage: file, useBundledMuLogo: false);
    notifyListeners();
  }

  void useBundledMuLogo() {
    data = data.copyWith(useBundledMuLogo: true, logoImage: null);
    notifyListeners();
  }

  void clearLogo() {
    data = data.copyWith(logoImage: null, useBundledMuLogo: false);
    notifyListeners();
  }

  // ── Template ─────────────────────────────────────────────────────────────
  void setTemplate(int index) {
    data = data.copyWith(templateIndex: index);
    notifyListeners();
  }

  // ── Design settings ───────────────────────────────────────────────────────
  void setFontFamily(String family) {
    data = data.copyWith(fontFamily: family);
    notifyListeners();
  }

  void setFontSize(double size) {
    data = data.copyWith(fontSize: size);
    notifyListeners();
  }

  void setLogoSize(double size) {
    data = data.copyWith(logoSize: size);
    notifyListeners();
  }

  void setThemeColor(Color color) {
    data = data.copyWith(themeColorValue: color.value);
    notifyListeners();
  }

  void setBorderStyle(String style) {
    data = data.copyWith(borderStyle: style);
    notifyListeners();
  }

  void setPageFormat(String format) {
    data = data.copyWith(pageFormat: format);
    notifyListeners();
  }

  // ── Instructor toggle ─────────────────────────────────────────────────────
  void setInstructorEnabled(bool enabled) {
    data = data.copyWith(instructorInfoEnabled: enabled);
    notifyListeners();
  }

  // ── Institution visibility ────────────────────────────────────────────────
  void setShowInstitutionDetails(bool show) {
    data = data.copyWith(showInstitutionDetails: show);
    notifyListeners();
  }

  // ── Group ─────────────────────────────────────────────────────────────────
  void setGroupSubmission(bool value) {
    data = data.copyWith(isGroupSubmission: value);
    notifyListeners();
  }

  void addGroupMember() {
    data.groupMembers.add(GroupMember());
    notifyListeners();
  }

  void removeGroupMember(int index) {
    if (data.groupMembers.length > 1) {
      data.groupMembers.removeAt(index);
      notifyListeners();
    }
  }

  void updateGroupMember(int index, {String? name, String? id}) {
    if (index < data.groupMembers.length) {
      if (name != null) data.groupMembers[index].name = name;
      if (id != null) data.groupMembers[index].id = id;
      notifyListeners();
    }
  }

  // ── Drag & drop offsets ───────────────────────────────────────────────────
  void setElementOffset(String key, Offset offset) {
    final newOffsets = Map<String, Offset>.from(data.offsets);
    newOffsets[key] = offset;
    data = data.copyWith(offsets: newOffsets);
    notifyListeners();
  }

  void resetElementOffsets() {
    data = data.copyWith(offsets: {});
    notifyListeners();
  }

  // ── Reset all ────────────────────────────────────────────────────────────
  void reset() {
    data = CoverPageData();
    notifyListeners();
  }
}

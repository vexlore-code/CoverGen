import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../data/app_constants.dart';
import '../data/course_data.dart';
import '../data/faculty_data.dart';
import '../models/cover_page_data.dart';
import '../templates/template_registry.dart';
import '../utils/cover_page_provider.dart';
import '../widgets/covergen_logo.dart';
import 'design_settings_screen.dart';
import 'preview_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> with SingleTickerProviderStateMixin {
  // Text controllers
  late final TextEditingController _uniCtrl;
  late final TextEditingController _courseTitleCtrl;
  late final TextEditingController _courseCodeCtrl;
  late final TextEditingController _assignTitleCtrl;
  late final TextEditingController _studentNameCtrl;
  late final TextEditingController _studentIdCtrl;
  late final TextEditingController _teacherNameCtrl;
  late final TextEditingController _teacherUniCtrl;
  late final TextEditingController _dateCtrl;

  // Dropdown-backed selections
  String? _deptValue;
  String? _studentDeptValue;
  String? _teacherDeptValue;
  String? _sectionValue;
  String? _batchValue;
  String? _designationValue;
  String? _courseSubjectValue;
  String _assignmentType = 'Assignment';

  // Section visibility state
  bool _instructorExpanded = true;
  bool _institutionExpanded = false;

  static const _assignTypes = [
    'Assignment', 'Lab Report', 'Term Paper', 'Project Report',
    'Case Study', 'Presentation', 'Quiz', 'Mid Exam', 'Final Exam',
  ];

  bool get _isMuDetected {
    final d = context.read<CoverPageProvider>().data;
    return d.useBundledMuLogo ||
        _uniCtrl.text.toLowerCase().contains('metropolitan');
  }

  @override
  void initState() {
    super.initState();
    final d = context.read<CoverPageProvider>().data;
    _uniCtrl = TextEditingController(
        text: d.universityName.isEmpty ? 'Metropolitan University' : d.universityName);
    _courseTitleCtrl = TextEditingController(text: d.courseTitle);
    _courseCodeCtrl = TextEditingController(text: d.courseCode);
    _assignTitleCtrl = TextEditingController(text: d.assignmentTitle);
    _studentNameCtrl = TextEditingController(text: d.studentName);
    _studentIdCtrl = TextEditingController(text: d.studentId);
    _teacherNameCtrl = TextEditingController(text: d.teacherName);
    _teacherUniCtrl = TextEditingController(
        text: d.teacherDepartment.isEmpty && d.universityName.isNotEmpty
            ? d.universityName
            : (d.universityName.isEmpty ? 'Metropolitan University' : d.universityName));
    _dateCtrl = TextEditingController(text: d.submissionDate);
    _assignmentType = d.assignmentType.isEmpty ? 'Assignment' : d.assignmentType;
    _deptValue = deptList.contains(d.departmentName) ? d.departmentName : null;
    _studentDeptValue = deptList.contains(d.departmentName) ? d.departmentName : null;
    _teacherDeptValue = deptList.contains(d.teacherDepartment) ? d.teacherDepartment : null;
    _sectionValue = sectionList.contains(d.section) ? d.section : null;
    _batchValue = batchList.contains(d.batch) ? d.batch : null;
    _designationValue =
        designationList.contains(d.teacherDesignation) ? d.teacherDesignation : null;
    _courseSubjectValue = courseMap.containsKey(d.courseTitle) ? d.courseTitle : null;
    _instructorExpanded = d.instructorInfoEnabled;
    _institutionExpanded = d.showInstitutionDetails;
  }

  @override
  void dispose() {
    for (final c in [
      _uniCtrl, _courseTitleCtrl, _courseCodeCtrl, _assignTitleCtrl,
      _studentNameCtrl, _studentIdCtrl, _teacherNameCtrl, _teacherUniCtrl, _dateCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _saveAndPreview() {
    final p = context.read<CoverPageProvider>();
    final isMU = _isMuDetected;
    p.update(
      universityName: isMU ? 'Metropolitan University' : (_institutionExpanded ? _uniCtrl.text : ''),
      departmentName: isMU ? '' : (_institutionExpanded ? (_deptValue ?? '') : ''),
      showInstitutionDetails: isMU ? false : _institutionExpanded,
      courseTitle: _courseSubjectValue ?? _courseTitleCtrl.text,
      courseCode: _courseCodeCtrl.text,
      assignmentTitle: _assignTitleCtrl.text,
      assignmentType: _assignmentType,
      studentName: _studentNameCtrl.text,
      studentId: _studentIdCtrl.text,
      section: _sectionValue ?? '',
      semester: '',
      batch: _batchValue ?? '',
      teacherName: _teacherNameCtrl.text,
      teacherDesignation: _designationValue ?? '',
      teacherDepartment: _teacherDeptValue ?? '',
      instructorInfoEnabled: true,
      submissionDate: _dateCtrl.text,
    );
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PreviewScreen()));
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (picked != null) {
      context.read<CoverPageProvider>().setLogo(File(picked.path));
      setState(() {});
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _dateCtrl.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _applyMuPresets() {
    context.read<CoverPageProvider>().useBundledMuLogo();
    setState(() {
      _uniCtrl.text = 'Metropolitan University';
      _institutionExpanded = true;
    });
  }

  void _openDesignSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DesignSettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CoverPageProvider>();
    final data = provider.data;
    final template = kTemplates[data.templateIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CoverGenLogo(size: 22, color: Colors.white),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                template.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Design settings button
          IconButton(
            icon: const Icon(Icons.palette_outlined, color: Colors.white),
            tooltip: 'Design Settings',
            onPressed: _openDesignSettings,
          ),
        ],
      ),

      // Floating "Design Settings" pill at bottom
      floatingActionButton: _DesignFAB(onTap: _openDesignSettings),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [


              // ── Logo Section ──────────────────────────────────────────────
              _SectionCard(
                icon: Icons.image_outlined,
                title: 'Logo',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _LogoPicker(data: data, onTap: _pickLogo)),
                        const SizedBox(width: 12),
                        Expanded(child: _MuLogoPicker(data: data)),
                      ],
                    ),
                    if (!_isMuDetected) ...[
                      const SizedBox(height: 10),
                      // Institution Details toggle
                      _ExpandToggle(
                        label: 'Add Institution Name & Department',
                        expanded: _institutionExpanded,
                        onToggle: (v) {
                          setState(() => _institutionExpanded = v);
                          provider.setShowInstitutionDetails(v);
                        },
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOut,
                        child: _institutionExpanded
                            ? Column(
                                children: [
                                  const SizedBox(height: 12),
                                  _field(_uniCtrl, 'University Name', Icons.school_outlined),
                                  _dropdown('Department', deptList, _deptValue,
                                      (v) => setState(() => _deptValue = v)),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),

              _SectionCard(
                icon: Icons.person_outlined,
                title: 'Instructor Information',
                child: Column(
                  children: [
                    _AutocompleteField(
                      label: 'Teacher Name',
                      icon: Icons.person_outline,
                      controller: _teacherNameCtrl,
                      suggestions: facultyList,
                      onChanged: (v) => setState(() => _teacherNameCtrl.text = v),
                    ),
                    const SizedBox(height: 12),
                    _dropdown('Designation', designationList, _designationValue,
                        (v) => setState(() => _designationValue = v)),
                    _dropdown('Instructor Department', deptList, _teacherDeptValue,
                        (v) => setState(() => _teacherDeptValue = v)),
                    _field(_teacherUniCtrl, 'Instructor University / Institution', Icons.school_outlined),
                  ],
                ),
              ),

              // ── Assignment & Course ────────────────────────────────────────
              _SectionCard(
                icon: Icons.assignment_outlined,
                title: 'Assignment & Course',
                child: Column(
                  children: [
                    _dropdown('Assignment Type', _assignTypes, _assignmentType,
                        (v) => setState(() => _assignmentType = v ?? _assignmentType),
                        isNullable: false),
                    _field(_assignTitleCtrl, 'Assignment / Report Title', Icons.title),
                    _CourseDropdown(
                      value: _courseSubjectValue,
                      onChanged: (v) {
                        setState(() {
                          _courseSubjectValue = v;
                          if (v != null && courseMap.containsKey(v)) {
                            _courseCodeCtrl.text = courseMap[v]!;
                          }
                        });
                      },
                    ),
                    _field(_courseCodeCtrl, 'Course Code', Icons.tag),
                    if (_courseSubjectValue == null)
                      _field(_courseTitleCtrl, 'Custom Course Title', Icons.edit_outlined),
                  ],
                ),
              ),

              // ── Student Information ───────────────────────────────────────
              _SectionCard(
                icon: template.usesGroupTable ? Icons.group_outlined : Icons.school_outlined,
                title: template.usesGroupTable ? 'Group Members' : 'Student Information',
                child: Column(
                  children: [
                    if (template.usesGroupTable)
                      _GroupMembersEditor(members: data.groupMembers)
                    else ...[
                      _field(_studentNameCtrl, 'Student Name', Icons.person_outline),
                      _field(_studentIdCtrl, 'Student ID', Icons.badge_outlined),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: _dropdown('Section', sectionList, _sectionValue,
                              (v) => setState(() => _sectionValue = v)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _dropdown('Batch', batchList, _batchValue,
                              (v) => setState(() => _batchValue = v)),
                        ),
                      ],
                    ),
                    _dropdown('Student Department', deptList, _studentDeptValue,
                        (v) => setState(() => _studentDeptValue = v)),
                  ],
                ),
              ),

              // ── Submission Date ────────────────────────────────────────────
              _SectionCard(
                icon: Icons.calendar_today_outlined,
                title: 'Submission Date',
                child: GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Date of Submission',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Preview button ─────────────────────────────────────────────
              _PreviewButton(onTap: _saveAndPreview),
            ],
          ),
        ),
      ),
    );
  }

  // ── Small helper builders ───────────────────────────────────────────────────

  Widget _field(TextEditingController ctrl, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged, {
    bool isNullable = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// ─── Section card wrapper ────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? headerTrailing;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.headerTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1628).withOpacity(0.04),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: const Border(
                bottom: BorderSide(color: Color(0xFFEEF0F4), width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFF1E3A5F)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2840),
                  ),
                ),
                const Spacer(),
                if (headerTrailing != null) headerTrailing!,
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ─── Logo pickers ─────────────────────────────────────────────────────────────

class _LogoPicker extends StatelessWidget {
  final CoverPageData data;
  final VoidCallback onTap;
  const _LogoPicker({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final selected = data.logoImage != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 88,
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.grey.shade50,
          border: Border.all(
            color: selected ? Colors.blue.shade400 : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: selected
            ? ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.file(data.logoImage!, fit: BoxFit.contain),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, size: 26, color: Colors.grey.shade500),
                  const SizedBox(height: 4),
                  Text('Upload Logo', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
      ),
    );
  }
}

class _MuLogoPicker extends StatelessWidget {
  final CoverPageData data;
  const _MuLogoPicker({required this.data});

  @override
  Widget build(BuildContext context) {
    final selected = data.useBundledMuLogo;
    return GestureDetector(
      onTap: () => context.read<CoverPageProvider>().useBundledMuLogo(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 88,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.grey.shade50,
          border: Border.all(
            color: selected ? Colors.blue.shade400 : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logos/mu_logo.png', height: 46, fit: BoxFit.contain),
            const SizedBox(height: 4),
            Text(
              selected ? '✓ MU Logo' : 'Use MU Logo',
              style: TextStyle(
                fontSize: 11,
                color: selected ? Colors.blue.shade700 : Colors.grey.shade600,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── MU Suggestion Banner ─────────────────────────────────────────────────────

class _MuBanner extends StatelessWidget {
  final VoidCallback onApply;
  const _MuBanner({required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3CD), Color(0xFFFFF8E7)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade400, width: 1.5),
      ),
      child: Row(
        children: [
          Image.asset('assets/logos/mu_logo.png', height: 36, fit: BoxFit.contain),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎓 Metropolitan University detected!',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF7A5C00)),
                ),
                const Text(
                  'Tap to apply MU logo & presets automatically.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9B7300)),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onApply,
            style: TextButton.styleFrom(
              foregroundColor: Colors.amber.shade800,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─── Expand toggle ────────────────────────────────────────────────────────────

class _ExpandToggle extends StatelessWidget {
  final String label;
  final bool expanded;
  final ValueChanged<bool> onToggle;
  const _ExpandToggle({required this.label, required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onToggle(!expanded),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          children: [
            AnimatedRotation(
              turns: expanded ? 0.25 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.arrow_right, size: 20, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}

// ─── Toggle chip ──────────────────────────────────────────────────────────────

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ToggleChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1E3A5F) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? const Color(0xFF1E3A5F) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (active) ...[
              const Icon(Icons.check, size: 13, color: Colors.white),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Autocomplete field ───────────────────────────────────────────────────────

class _AutocompleteField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final List<String> suggestions;
  final ValueChanged<String> onChanged;

  const _AutocompleteField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.suggestions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (v) => v.text.isEmpty
          ? const Iterable<String>.empty()
          : suggestions.where((e) => e.toLowerCase().contains(v.text.toLowerCase())),
      onSelected: onChanged,
      fieldViewBuilder: (ctx, ctrl, node, onSub) {
        if (ctrl.text.isEmpty && controller.text.isNotEmpty) {
          ctrl.text = controller.text;
        }
        return TextFormField(
          controller: ctrl,
          focusNode: node,
          onEditingComplete: onSub,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, size: 20),
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (v) => controller.text = v,
        );
      },
    );
  }
}

// ─── Course dropdown ──────────────────────────────────────────────────────────

class _CourseDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  const _CourseDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: value,
        decoration: const InputDecoration(
          labelText: 'Subject / Course',
          prefixIcon: Icon(Icons.book_outlined, size: 20),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        items: courseMap.keys
            .map((k) => DropdownMenuItem(value: k, child: Text(k, overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// ─── Group members editor ─────────────────────────────────────────────────────

class _GroupMembersEditor extends StatelessWidget {
  final List<GroupMember> members;
  const _GroupMembersEditor({required this.members});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CoverPageProvider>();
    return Column(
      children: [
        for (int i = 0; i < members.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 26,
                  child: Text('${i + 1}.', style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: members[i].name,
                    decoration: const InputDecoration(
                        labelText: 'Name', border: OutlineInputBorder(), isDense: true,
                        filled: true, fillColor: Colors.white),
                    onChanged: (v) => provider.updateGroupMember(i, name: v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: members[i].id,
                    decoration: const InputDecoration(
                        labelText: 'ID', border: OutlineInputBorder(), isDense: true,
                        filled: true, fillColor: Colors.white),
                    onChanged: (v) => provider.updateGroupMember(i, id: v),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                  onPressed: members.length > 1 ? () => provider.removeGroupMember(i) : null,
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => provider.addGroupMember(),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Member'),
          ),
        ),
      ],
    );
  }
}

// ─── Design FAB ───────────────────────────────────────────────────────────────

class _DesignFAB extends StatelessWidget {
  final VoidCallback onTap;
  const _DesignFAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: const Color(0xFF1E3A5F),
      icon: const Icon(Icons.palette_outlined, color: Colors.white, size: 18),
      label: const Text('Design Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }
}

// ─── Preview button ───────────────────────────────────────────────────────────

class _PreviewButton extends StatefulWidget {
  final VoidCallback onTap;
  const _PreviewButton({required this.onTap});

  @override
  State<_PreviewButton> createState() => _PreviewButtonState();
}

class _PreviewButtonState extends State<_PreviewButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A5F), Color(0xFF2A5298)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E3A5F).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.visibility_outlined, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(
                'Preview Cover Page',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

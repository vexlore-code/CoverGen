import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../models/cover_page_data.dart';
import '../templates/template_registry.dart';
import '../utils/cover_page_provider.dart';
import '../widgets/covergen_logo.dart';
import 'form_screen.dart';

class TemplateSelectScreen extends StatefulWidget {
  const TemplateSelectScreen({super.key});

  @override
  State<TemplateSelectScreen> createState() => _TemplateSelectScreenState();
}

class _TemplateSelectScreenState extends State<TemplateSelectScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  static const _categories = ['All', 'Solo', 'Group', 'Decorative'];

  static final CoverPageData _placeholder = CoverPageData(
    universityName: 'Metropolitan University',
    departmentName: 'CSE Department',
    assignmentTitle: 'Assignment Title',
    courseTitle: 'Algorithm Design',
    courseCode: 'CSE 231',
    assignmentType: 'Assignment',
    studentName: 'Student Name',
    studentId: '230-115-123',
    teacherName: 'Md. Mahfujul Hasan',
    teacherDesignation: 'Lecturer',
    submissionDate: '01/07/2026',
    groupMembers: [
      GroupMember(name: 'Member One', id: '230-115-001'),
      GroupMember(name: 'Member Two', id: '230-115-002'),
    ],
  );

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _categories.length, vsync: this);
    _tabs.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  List<int> _filteredIndices(String category) {
    if (category == 'All') return List.generate(kTemplates.length, (i) => i);
    if (category == 'Group') {
      return [
        for (int i = 0; i < kTemplates.length; i++)
          if (kTemplates[i].usesGroupTable) i,
      ];
    }
    if (category == 'Decorative') {
      return [
        for (int i = 0; i < kTemplates.length; i++)
          if (kTemplates[i].isDecorative) i,
      ];
    }
    // Solo
    return [
      for (int i = 0; i < kTemplates.length; i++)
        if (!kTemplates[i].usesGroupTable) i,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cat = _categories[_tabs.index];
    final indices = _filteredIndices(cat);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CoverGenLogo(size: 26, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'CoverGen',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            color: const Color(0xFF0A1628),
            child: TabBar(
              controller: _tabs,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              indicatorColor: Colors.amber.shade400,
              indicatorWeight: 3,
              tabs: _categories
                  .map((c) => Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(c, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            final w = constraints.maxWidth;
            final cols = w >= 900 ? 4 : (w >= 600 ? 3 : 2);
            final itemWidth = (w - 32 - (cols - 1) * 16) / cols;
            final itemHeight = (itemWidth / (794 / 1123)) + 110;
            final aspectRatio = itemWidth / itemHeight;

            return AnimationLimiter(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => AnimationConfiguration.staggeredGrid(
                          position: i,
                          duration: const Duration(milliseconds: 375),
                          columnCount: cols,
                          child: ScaleAnimation(
                            scale: 0.88,
                            child: FadeInAnimation(
                              child: _TemplateCard(
                                index: indices[i],
                                tpl: kTemplates[indices[i]],
                                placeholder: _placeholder,
                              ),
                            ),
                          ),
                        ),
                        childCount: indices.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 16,
                        childAspectRatio: aspectRatio,
                      ),
                    ),
                  ),

                  // ── Scrollable footer ────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _AppFooter(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}



// ─────────────────────────────────────────────────────────────────────────────

class _AppFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      child: Text(
        'CoverGen v1.0  ·  Developed by Md. Jubayer Hasan Munna  ·  \u00a9 ${DateTime.now().year}',
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 9,
          color: Colors.grey.shade500,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _TemplateCard extends StatefulWidget {

  final int index;
  final TemplateInfo tpl;
  final CoverPageData placeholder;
  const _TemplateCard({
    required this.index,
    required this.tpl,
    required this.placeholder,
  });

  @override
  State<_TemplateCard> createState() => _TemplateCardState();
}

class _TemplateCardState extends State<_TemplateCard> {
  bool _hovered = false;

  void _select(BuildContext context) {
    final provider = context.read<CoverPageProvider>();
    provider.setTemplate(widget.index);
    provider.setGroupSubmission(widget.tpl.usesGroupTable);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _hovered ? 0.12 : 0.06),
                blurRadius: _hovered ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Preview thumbnail ───────────────────────────────────────────
                Expanded(
                  child: GestureDetector(
                    onTap: () => _select(context),
                    child: Container(
                      color: const Color(0xFFF0F2F5), // subtle background for the preview area
                      child: Stack(
                        children: [
                          // Template live preview
                          Positioned.fill(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                width: 794,
                                height: 1123,
                                child: IgnorePointer(
                                  child: widget.tpl.builder(widget.placeholder),
                                ),
                              ),
                            ),
                          ),
                          // Hover overlay
                          AnimatedOpacity(
                            opacity: _hovered ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.25),
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Use This',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: Color(0xFF1E3A5F),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Badge for group templates
                          if (widget.tpl.usesGroupTable)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade600,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'GROUP',
                                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ── Name, description, & button ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                  child: Column(
                    children: [
                      Text(
                        widget.tpl.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Color(0xFF1A2840),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.tpl.description,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 30,
                        width: 100,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A5F),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () => _select(context),
                          child: const Text('Select', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

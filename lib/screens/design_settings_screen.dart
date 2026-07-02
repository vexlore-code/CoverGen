import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../utils/cover_page_provider.dart';
import '../utils/font_utils.dart';

class DesignSettingsSheet extends StatefulWidget {
  const DesignSettingsSheet({super.key});

  @override
  State<DesignSettingsSheet> createState() => _DesignSettingsSheetState();
}

class _DesignSettingsSheetState extends State<DesignSettingsSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75 + bottomPad,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: [
                const Icon(Icons.palette_outlined, color: Color(0xFF1E3A5F), size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Design Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2840),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabs,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF6B7280),
              indicator: BoxDecoration(
                color: const Color(0xFF1E3A5F),
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: '🖋 Typography'),
                Tab(text: '📐 Layout'),
                Tab(text: '🎨 Style'),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: const [
                _TypographyTab(),
                _LayoutTab(),
                _StyleTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Typography tab ───────────────────────────────────────────────────────────

class _TypographyTab extends StatelessWidget {
  const _TypographyTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CoverPageProvider>();
    final data = provider.data;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const _Label('Font Family'),
        const SizedBox(height: 10),
        // Horizontal scroll font picker
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kFontFamilies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (ctx, i) {
              final family = kFontFamilies[i];
              final selected = data.fontFamily == family;
              return GestureDetector(
                onTap: () => provider.setFontFamily(family),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 120,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF1E3A5F) : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? const Color(0xFF1E3A5F) : Colors.grey.shade300,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Aa',
                        style: TextStyle(
                          fontFamily: family,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: selected ? Colors.white : const Color(0xFF1A2840),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        family.split(' ').first,
                        style: TextStyle(
                          fontSize: 10,
                          color: selected ? Colors.white70 : Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),
        const _Label('Font Size'),
        _SliderRow(
          value: data.fontSize,
          min: 10,
          max: 24,
          divisions: 28,
          label: '${data.fontSize.round()} pt',
          onChanged: (v) => provider.setFontSize(v),
          leadingIcon: Icons.text_fields,
        ),

        const SizedBox(height: 16),
        // Preview text
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preview',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Metropolitan University',
                style: TextStyle(
                  fontFamily: data.fontFamily,
                  fontSize: data.fontSize + 4,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2840),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Department of Computer Science and Engineering',
                style: TextStyle(
                  fontFamily: data.fontFamily,
                  fontSize: data.fontSize,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Layout tab ──────────────────────────────────────────────────────────────

class _LayoutTab extends StatelessWidget {
  const _LayoutTab();

  static const _formats = ['A4', 'Letter', 'A3'];
  static const _formatDesc = {
    'A4': '794 × 1123 pt (Standard)',
    'Letter': '816 × 1056 pt (US)',
    'A3': '1123 × 1587 pt (Large)',
  };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CoverPageProvider>();
    final data = provider.data;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const _Label('Logo Size'),
        _SliderRow(
          value: data.logoSize,
          min: 40,
          max: 160,
          divisions: 24,
          label: '${data.logoSize.round()} px',
          onChanged: (v) => provider.setLogoSize(v),
          leadingIcon: Icons.image_outlined,
        ),

        const SizedBox(height: 24),
        const _Label('Page Format'),
        const SizedBox(height: 10),
        Row(
          children: _formats.map((f) {
            final selected = data.pageFormat == f;
            return Expanded(
              child: GestureDetector(
                onTap: () => provider.setPageFormat(f),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF1E3A5F) : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? const Color(0xFF1E3A5F) : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        f,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: selected ? Colors.white : const Color(0xFF1A2840),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatDesc[f]!.split(' ').first,
                        style: TextStyle(
                          fontSize: 10,
                          color: selected ? Colors.white60 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            _formatDesc[data.pageFormat]!,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }
}

// ─── Style tab ────────────────────────────────────────────────────────────────

class _StyleTab extends StatefulWidget {
  const _StyleTab();

  @override
  State<_StyleTab> createState() => _StyleTabState();
}

class _StyleTabState extends State<_StyleTab> {
  static const _borderStyles = ['none', 'single', 'double', 'dashed', 'shadow'];
  static const _borderLabels = {
    'none': 'None',
    'single': 'Single',
    'double': 'Double',
    'dashed': 'Dashed',
    'shadow': 'Shadow',
  };
  static const _borderIcons = {
    'none': Icons.crop_free,
    'single': Icons.border_outer,
    'double': Icons.border_all,
    'dashed': Icons.border_style,
    'shadow': Icons.blur_on,
  };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CoverPageProvider>();
    final data = provider.data;
    final currentColor = data.themeColor;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        // ── Theme Color ────────────────────────────────────────────────────
        const _Label('Theme / Accent Color'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              SlidePicker(
                pickerColor: currentColor,
                onColorChanged: (c) => provider.setThemeColor(c),
                enableAlpha: false,
                showParams: true,
                showIndicator: true,
                colorModel: ColorModel.rgb,
                indicatorSize: const Size(double.infinity, 40),
                indicatorBorderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              const SizedBox(height: 12),
              // Preset color swatches
              Wrap(
                spacing: 8,
                children: [
                  0xFF1E3A5F, 0xFF8B0000, 0xFF006400, 0xFF4B0082,
                  0xFF8B4513, 0xFF00008B, 0xFF2F4F4F, 0xFFB8860B,
                  0xFF36454F, 0xFF722F37,
                ].map((v) {
                  final c = Color(v);
                  return GestureDetector(
                    onTap: () => provider.setThemeColor(c),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: data.themeColorValue == v ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [BoxShadow(color: c.withValues(alpha: 0.4), blurRadius: 4)],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        // ── Border Style ───────────────────────────────────────────────────
        const _Label('Page Border Style'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _borderStyles.map((s) {
            final selected = data.borderStyle == s;
            return GestureDetector(
              onTap: () => provider.setBorderStyle(s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF1E3A5F) : const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected ? const Color(0xFF1E3A5F) : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _borderIcons[s]!,
                      size: 16,
                      color: selected ? Colors.white : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _borderLabels[s]!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : const Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── Shared sub-widgets ───────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF374151),
          letterSpacing: 0.3,
        ),
      );
}

class _SliderRow extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final ValueChanged<double> onChanged;
  final IconData leadingIcon;

  const _SliderRow({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.onChanged,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(leadingIcon, size: 18, color: Colors.grey.shade600),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: const Color(0xFF1E3A5F),
          ),
        ),
        Container(
          width: 54,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A5F).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E3A5F),
            ),
          ),
        ),
      ],
    );
  }
}

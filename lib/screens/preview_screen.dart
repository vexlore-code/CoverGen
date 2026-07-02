import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../models/cover_page_data.dart';
import '../templates/template_registry.dart';
import '../utils/cover_page_provider.dart';
import '../utils/export_utils.dart';
import '../utils/pdf_picker.dart';
import '../widgets/page_border_widget.dart';
import '../widgets/covergen_logo.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey _boundaryKey = GlobalKey();
  final TransformationController _transformController = TransformationController();

  bool _busy = false;
  bool _didInitZoom = false;
  String? _dragging;
  Offset _dragStartLocal = Offset.zero;
  Offset _dragStartOffset = Offset.zero;

  static const double _pageW = 794;
  static const double _pageH = 1123;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _fitToScreen(BoxConstraints constraints) {
    if (_didInitZoom) return;
    final aw = constraints.maxWidth - 32;
    final ah = constraints.maxHeight - 32;
    if (aw <= 0 || ah <= 0) return;
    final scale = (aw / _pageW) < (ah / _pageH)
        ? (aw / _pageW).clamp(0.05, 1.0)
        : (ah / _pageH).clamp(0.05, 1.0);
    _transformController.value = Matrix4.identity()..scale(scale);
    _didInitZoom = true;
  }

  Future<Uint8List> _capture() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return ExportUtils.captureWidgetAsImage(_boundaryKey);
  }

  Future<void> _handle(Future<void> Function(Uint8List bytes) action) async {
    setState(() => _busy = true);
    try {
      final bytes = await _capture();
      await action(bytes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveAsImage() => _handle((bytes) async {
        await ExportUtils.saveImageToGallery(bytes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saved to gallery ✅')),
          );
        }
      });

  Future<String?> _showRenameDialog(String initialName) async {
    final ctrl = TextEditingController(text: initialName);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save PDF File'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            labelText: 'File Name',
            suffixText: '.pdf',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _shareAsPdf() async {
    final defaultName = 'cover_page_${DateTime.now().millisecondsSinceEpoch}';
    final customName = await _showRenameDialog(defaultName);
    if (customName == null || customName.isEmpty) return;

    await _handle((bytes) async {
      final fmt = ExportUtils.formatFromString(
          context.read<CoverPageProvider>().data.pageFormat);
      final pdf = await ExportUtils.buildPdfFromImage(bytes, format: fmt);
      final file = await ExportUtils.savePdfToTempFile(pdf, name: customName);
      await ExportUtils.shareFile(file, text: 'My cover page — CoverGen');
    });
  }

  Future<void> _shareImage() => _handle((bytes) async {
        final file = await ExportUtils.saveImageToTempFile(bytes);
        await ExportUtils.shareFile(file, text: 'My cover page — CoverGen');
      });

  Future<void> _print() => _handle((bytes) async {
        final fmt = ExportUtils.formatFromString(
            context.read<CoverPageProvider>().data.pageFormat);
        final pdf = await ExportUtils.buildPdfFromImage(bytes, format: fmt);
        await ExportUtils.printPdf(pdf);
      });

  /// Pick a PDF file via native Android picker and merge the cover as first page.
  Future<void> _mergeWithPdf() async {
    // Step 1: Open native Android PDF picker
    final pdfFile = await PdfPicker.pickPdf();
    if (pdfFile == null) return; // user cancelled

    // Step 2: Ask for output file name
    final defaultName = 'assignment_with_cover_${DateTime.now().millisecondsSinceEpoch}';
    final customName = await _showRenameDialog(defaultName);
    if (customName == null || customName.isEmpty) return;

    // Step 3: Capture cover, merge, and share
    await _handle((bytes) async {
      final fmt = ExportUtils.formatFromString(
          context.read<CoverPageProvider>().data.pageFormat);
      final mergedBytes = await ExportUtils.mergeCoverWithPdf(bytes, pdfFile, format: fmt);
      final mergedFile = await ExportUtils.savePdfToTempFile(mergedBytes, name: customName);
      await ExportUtils.shareFile(mergedFile, text: 'My assignment with cover page — CoverGen');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Merged PDF ready! ✅')),
        );
      }
    });
  }

  Offset _currentScale() {
    final m = _transformController.value;
    return Offset(m.row0[0], m.row1[1]);
  }

  // ─── Drag & drop ──────────────────────────────────────────────────────────

  void _onDragStart(String key, Offset localPos, CoverPageData data) {
    setState(() {
      _dragging = key;
      _dragStartLocal = localPos;
      _dragStartOffset = data.getOffset(key);
    });
  }

  void _onDragUpdate(Offset localPos, BuildContext ctx) {
    if (_dragging == null) return;
    final delta = (localPos - _dragStartLocal);
    final newOff = _dragStartOffset + delta;
    context.read<CoverPageProvider>().setElementOffset(_dragging!, newOff);
  }

  void _onDragEnd() => setState(() => _dragging = null);

  @override
  Widget build(BuildContext context) {
    final data = context.watch<CoverPageProvider>().data;
    final template = kTemplates[data.templateIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CoverGenLogo(size: 20, color: Colors.white),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Preview — ${template.name}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Edit
          IconButton(
            tooltip: 'Edit details',
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Page canvas ────────────────────────────────────────────────────
          LayoutBuilder(
            builder: (ctx, constraints) {
              WidgetsBinding.instance.addPostFrameCallback((_) => _fitToScreen(constraints));

              final pageContent = RepaintBoundary(
                key: _boundaryKey,
                child: Material(
                  elevation: 0,
                  child: SizedBox(
                    width: _pageW,
                    height: _pageH,
                    child: PageBorderWidget(
                      borderStyle: data.borderStyle,
                      borderColor: data.themeColor,
                      child: template.builder(data),
                    ),
                  ),
                ),
              );

              return InteractiveViewer(
                transformationController: _transformController,
                minScale: 0.1,
                maxScale: 4,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(200),
                panEnabled: true,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  builder: (_, t, child) => Opacity(
                    opacity: t,
                    child: Transform.scale(scale: 0.96 + 0.04 * t, child: child),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 30,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: pageContent,
                  ),
                ),
              );
            },
          ),

          // ── Busy overlay ───────────────────────────────────────────────────
          AnimatedOpacity(
            opacity: _busy ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_busy,
              child: Container(
                color: Colors.black45,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),


        ],
      ),

      // ── Export actions ─────────────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _ExportBtn(icon: Icons.picture_as_pdf, label: 'PDF', onTap: _busy ? null : _shareAsPdf),
                  const SizedBox(width: 4),
                  _ExportBtn(icon: Icons.save_alt, label: 'Save', onTap: _busy ? null : _saveAsImage),
                  const SizedBox(width: 4),
                  _ExportBtn(icon: Icons.share, label: 'Share', onTap: _busy ? null : _shareImage),
                  const SizedBox(width: 4),
                  _ExportBtn(icon: Icons.print, label: 'Print', onTap: _busy ? null : _print),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : _mergeWithPdf,
                  icon: const Icon(Icons.merge_type, size: 18),
                  label: const Text('Merge Cover + PDF Assignment'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Export button ────────────────────────────────────────────────────────────

class _ExportBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _ExportBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: onTap == null ? Colors.grey.shade200 : const Color(0xFF1E3A5F),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: onTap == null ? Colors.grey : Colors.white, size: 20),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: onTap == null ? Colors.grey : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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

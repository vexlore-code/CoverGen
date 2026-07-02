import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

class ExportUtils {
  /// Capture a RepaintBoundary as PNG bytes.
  static Future<Uint8List> captureWidgetAsImage(
    GlobalKey boundaryKey, {
    double pixelRatio = 3.0,
  }) async {
    final boundary =
        boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /// Save PNG bytes to a temp file and return the file.
  static Future<File> saveImageToTempFile(
    Uint8List bytes, {
    String name = 'cover_page',
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name.png');
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Build a one-page PDF from PNG image bytes.
  static Future<Uint8List> buildPdfFromImage(
    Uint8List imageBytes, {
    PdfPageFormat format = PdfPageFormat.a4,
  }) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(imageBytes);
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        margin: pw.EdgeInsets.zero,
        build: (context) => pw.Center(
          child: pw.Image(image, fit: pw.BoxFit.contain),
        ),
      ),
    );
    return pdf.save();
  }

  /// Merge cover page (as image bytes) with an existing PDF file.
  /// The cover page is prepended as the first page.
  static Future<Uint8List> mergeCoverWithPdf(
    Uint8List coverImageBytes,
    File pdfFile, {
    PdfPageFormat format = PdfPageFormat.a4,
  }) async {
    final pdf = pw.Document();
    final coverImage = pw.MemoryImage(coverImageBytes);

    // Page 1 — cover
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        margin: pw.EdgeInsets.zero,
        build: (context) => pw.Center(
          child: pw.Image(coverImage, fit: pw.BoxFit.contain),
        ),
      ),
    );

    // Remaining pages — original PDF pages
    final existingPages = await pdfFromFile(pdfFile);
    for (final page in existingPages) {
      pdf.addPage(
        pw.Page(
          pageFormat: format,
          margin: pw.EdgeInsets.zero,
          build: (context) => pw.Center(child: pw.Image(page, fit: pw.BoxFit.contain)),
        ),
      );
    }

    return pdf.save();
  }

  /// Render each page of a PDF file as [pw.MemoryImage].
  /// Uses the `printing` package's raster pipeline.
  static Future<List<pw.MemoryImage>> pdfFromFile(File file) async {
    final bytes = await file.readAsBytes();
    final images = <pw.MemoryImage>[];
    await for (final page in Printing.raster(bytes, dpi: 150)) {
      final png = await page.toPng();
      images.add(pw.MemoryImage(png));
    }
    return images;
  }

  /// Save PDF bytes to a temp file and return the file.
  static Future<File> savePdfToTempFile(
    Uint8List bytes, {
    String name = 'cover_page',
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Save image bytes to the device gallery.
  static Future<void> saveImageToGallery(Uint8List bytes) async {
    await Gal.putImageBytes(bytes, album: 'CoverGen');
  }

  /// Share a file via the native share sheet.
  static Future<void> shareFile(File file, {String? text}) async {
    await Share.shareXFiles([XFile(file.path)], text: text);
  }

  /// Send PDF bytes to the system print dialog.
  static Future<void> printPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
  }

  /// Returns the correct [PdfPageFormat] for a format string.
  static PdfPageFormat formatFromString(String format) {
    switch (format) {
      case 'Letter':
        return PdfPageFormat.letter;
      case 'A3':
        return PdfPageFormat.a3;
      default:
        return PdfPageFormat.a4;
    }
  }
}

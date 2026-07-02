import 'dart:io';
import 'package:flutter/services.dart';

/// Calls the native Android PDF picker via a MethodChannel.
/// Returns the path to the picked PDF, or null if the user cancelled.
class PdfPicker {
  static const _channel = MethodChannel('com.covergen/pdf_picker');

  static Future<File?> pickPdf() async {
    try {
      final path = await _channel.invokeMethod<String>('pickPdf');
      if (path == null) return null;
      return File(path);
    } catch (e) {
      return null;
    }
  }
}

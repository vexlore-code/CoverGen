import 'package:flutter/material.dart';
import '../models/cover_page_data.dart';

/// Renders the logo: bundled MU logo asset, user-uploaded file, or a
/// fallback icon — so every template doesn't repeat this branching.
class LogoWidget extends StatelessWidget {
  final CoverPageData data;
  final double height;
  final Color fallbackColor;
  const LogoWidget({
    super.key,
    required this.data,
    this.height = 90,
    this.fallbackColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    if (data.useBundledMuLogo) {
      return Image.asset('assets/logos/mu_logo.png', height: height, fit: BoxFit.contain);
    }
    if (data.logoImage != null) {
      return Image.file(data.logoImage!, height: height, fit: BoxFit.contain);
    }
    return Icon(Icons.school, size: height, color: fallbackColor);
  }
}

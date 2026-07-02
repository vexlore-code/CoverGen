import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// All selectable font families for cover pages.
const List<String> kFontFamilies = [
  'Merriweather',
  'Playfair Display',
  'EB Garamond',
  'Crimson Text',
  'Source Serif 4',
  'Libre Baskerville',
  'Lato',
  'Open Sans',
  'Roboto Slab',
  'Noto Serif',
];

/// Returns a [TextStyle] using the specified [family] (one of [kFontFamilies]).
/// Falls back to Merriweather for any unrecognised family name.
TextStyle coverFont(
  String family, {
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? letterSpacing,
  FontStyle? fontStyle,
  double? height,
  TextDecoration? decoration,
}) {
  final base = TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
    fontStyle: fontStyle,
    height: height,
    decoration: decoration,
  );
  return switch (family) {
    'Playfair Display' => GoogleFonts.playfairDisplay(textStyle: base),
    'EB Garamond' => GoogleFonts.ebGaramond(textStyle: base),
    'Crimson Text' => GoogleFonts.crimsonText(textStyle: base),
    'Source Serif 4' => GoogleFonts.sourceSerif4(textStyle: base),
    'Libre Baskerville' => GoogleFonts.libreBaskerville(textStyle: base),
    'Lato' => GoogleFonts.lato(textStyle: base),
    'Open Sans' => GoogleFonts.openSans(textStyle: base),
    'Roboto Slab' => GoogleFonts.robotoSlab(textStyle: base),
    'Noto Serif' => GoogleFonts.notoSerif(textStyle: base),
    _ => GoogleFonts.merriweather(textStyle: base),
  };
}

/// Short preview text for showing a font in the selector.
String fontPreviewLabel(String family) => 'Aa — $family';

import 'package:flutter/material.dart';
import '../models/cover_page_data.dart';
import 'template_classic.dart';
import 'template_modern.dart';
import 'template_minimal.dart';
import 'template_bold.dart';
import 'template_bullet_list.dart';
import 'template_group_classic.dart';
import 'template_group_modern.dart';
import 'template_traditional_centered.dart';
import 'template_box_grid.dart';
import 'template_underline_form.dart';
import 'template_neon_dark.dart';
import 'template_ribbon_elegant.dart';
import 'template_geometric.dart';
import 'template_magazine.dart';
import 'template_watermark.dart';
import 'template_full_border.dart';

class TemplateInfo {
  final String name;
  final String description;
  final bool usesGroupTable;
  final bool hasBoxesOrLines;
  final bool isDecorative;
  final Widget Function(CoverPageData data) builder;

  const TemplateInfo({
    required this.name,
    required this.description,
    required this.builder,
    this.usesGroupTable = false,
    this.hasBoxesOrLines = true,
    this.isDecorative = false,
  });
}

final List<TemplateInfo> kTemplates = [
  TemplateInfo(
    name: 'Classic Formal',
    description: 'Double border, centered layout, side-by-side info blocks',
    builder: (d) => TemplateClassic(data: d),
  ),
  TemplateInfo(
    name: 'Modern Sidebar',
    description: 'Navy sidebar with student/teacher info, bold typography',
    builder: (d) => TemplateModern(data: d),
  ),
  TemplateInfo(
    name: 'Minimal Elegant',
    description: 'Lots of white space, thin rule lines, understated',
    builder: (d) => TemplateMinimal(data: d),
  ),
  TemplateInfo(
    name: 'Bold Banner',
    description: 'Gradient banner header, crimson accent cards',
    builder: (d) => TemplateBold(data: d),
  ),
  TemplateInfo(
    name: 'Bullet List (MU Style)',
    description: 'Instructor/Student Information bullet lists, Topic, Date — no borders',
    hasBoxesOrLines: false,
    builder: (d) => TemplateBulletList(data: d),
  ),
  TemplateInfo(
    name: 'Group Table — Classic',
    description: 'Formal bordered page with a group-members table',
    usesGroupTable: true,
    builder: (d) => TemplateGroupClassic(data: d),
  ),
  TemplateInfo(
    name: 'Group Table — Modern',
    description: 'Teal banner header with a group-members table',
    usesGroupTable: true,
    builder: (d) => TemplateGroupModern(data: d),
  ),
  TemplateInfo(
    name: 'Traditional Centered',
    description: 'Classic plain-text centered layout, no borders or tables',
    hasBoxesOrLines: false,
    builder: (d) => TemplateTraditionalCentered(data: d),
  ),
  TemplateInfo(
    name: 'Box Grid',
    description: 'Soft rounded info cards in a two-column grid — no table lines',
    builder: (d) => TemplateBoxGrid(data: d),
  ),
  TemplateInfo(
    name: 'Underline Form',
    description: 'Fill-in-the-blank style with underlined fields, double frame',
    builder: (d) => TemplateUnderlineForm(data: d),
  ),
  // ── New decorative templates ────────────────────────────────────────────────
  TemplateInfo(
    name: 'Neon Dark',
    description: 'Dark background with neon glowing accents — modern Gen-Z style',
    isDecorative: true,
    builder: (d) => TemplateNeonDark(data: d),
  ),
  TemplateInfo(
    name: 'Ribbon Elegant',
    description: 'Diagonal corner ribbons with ornate serif layout',
    isDecorative: true,
    builder: (d) => TemplateRibbonElegant(data: d),
  ),
  TemplateInfo(
    name: 'Geometric Modern',
    description: 'Clean geometric shapes as decorative elements, minimal layout',
    isDecorative: true,
    builder: (d) => TemplateGeometric(data: d),
  ),
  TemplateInfo(
    name: 'Magazine Style',
    description: 'Full-color header block with editorial magazine layout',
    isDecorative: true,
    builder: (d) => TemplateMagazine(data: d),
  ),
  TemplateInfo(
    name: 'Watermark Formal',
    description: 'University name as diagonal watermark behind classic content',
    isDecorative: true,
    builder: (d) => TemplateWatermark(data: d),
  ),
  TemplateInfo(
    name: 'Ornate Full Border',
    description: 'Certificate-style ornate border with tick marks and diamonds',
    isDecorative: true,
    builder: (d) => TemplateFullBorder(data: d),
  ),
];

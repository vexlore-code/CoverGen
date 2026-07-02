# CoverGen

A Flutter app for generating academic cover pages (assignments, lab reports,
term papers) with **10 professional templates**, live preview, and export to
**PDF** and **Image (PNG)**.

## Features
- **10 templates**, including plain-text (no borders), table-based, group-member table, and boxed/card styles:
  1. Classic Formal — double border, side-by-side info blocks
  2. Modern Sidebar — navy sidebar layout
  3. Minimal Elegant — white space, thin rule lines
  4. Bold Banner — gradient banner, crimson cards
  5. **Bullet List (MU Style)** — matches the common Metropolitan University lab-report format (Instructor Information / Student Information bullets, Topic, Date — no borders)
  6. **Group Table — Classic** — formal bordered page with a group-members table (SL / Name / ID)
  7. **Group Table — Modern** — teal banner + group-members table
  8. **Traditional Centered** — plain centered text, no borders or tables
  9. **Box Grid** — soft rounded info cards, no table lines
  10. **Underline Form** — fill-in-the-blank style with underlined fields
- Bundled **Metropolitan University logo** (one-tap "Use MU Logo") or upload your own
- Group submission support: add/remove unlimited group members with name + ID
- Fill in university, department, course, assignment, student/group, and teacher info
- Live preview before export
- Export as PDF or PNG image; save to gallery, share, or print

## Project Structure
```
lib/
  models/cover_page_data.dart      -> data model (incl. GroupMember) for all form fields
  utils/cover_page_provider.dart   -> app state (Provider)
  utils/export_utils.dart          -> PDF/image capture, save, share, print
  widgets/logo_widget.dart         -> shared logo renderer (bundled/uploaded/fallback)
  widgets/group_members_table.dart -> shared group-members table
  templates/                       -> the 10 visual templates + registry
  screens/
    template_select_screen.dart    -> step 1: pick a template (shows description)
    form_screen.dart               -> step 2: fill in details (adapts to group vs solo)
    preview_screen.dart            -> step 3: preview + export
  main.dart                        -> app entry point
assets/logos/mu_logo.png           -> bundled Metropolitan University logo
```

## Setup

1. **Create the Flutter project shell** (if not already created), then copy
   these files in, replacing `lib/`, `assets/`, and `pubspec.yaml`:
   ```bash
   flutter create cover_page_maker
   # then copy this lib/, assets/, and pubspec.yaml into it, overwriting
   ```

2. **Install dependencies:**
   ```bash
   cd cover_page_maker
   flutter pub get
   ```

3. **Android permissions** — add to `android/app/src/main/AndroidManifest.xml`
   (inside `<manifest>`, above `<application>`):
   ```xml
   <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="28"/>
   ```
   The `gal` and `image_picker` packages handle runtime permission prompts automatically.

4. **iOS permissions** — add to `ios/Runner/Info.plist`:
   ```xml
   <key>NSPhotoLibraryUsageDescription</key>
   <string>We need access to your photos to let you pick a logo and save cover pages.</string>
   <key>NSPhotoLibraryAddUsageDescription</key>
   <string>We need permission to save your generated cover pages to Photos.</string>
   ```

5. **Run:**
   ```bash
   flutter run
   ```

## How it works (flow)
1. **Template Select Screen** — user picks one of 10 templates → saved in `CoverPageProvider`.
   Choosing a group-table template auto-switches the form into group mode.
2. **Form Screen** — user fills university/department/course/student-or-group/teacher/date fields,
   plus logo (upload or bundled MU logo). Group templates show an add/remove member list instead
   of a single student field.
3. **Preview Screen** — renders the chosen template with real data inside a `RepaintBoundary`,
   which is captured as a PNG (`ExportUtils.captureWidgetAsImage`). That PNG is either:
   - saved directly to gallery,
   - shared as-is, or
   - wrapped into an A4 PDF page (`ExportUtils.buildPdfFromImage`) and shared/printed.

## Adding a new template
1. Create `lib/templates/template_yourname.dart` — a `StatelessWidget` taking
   `CoverPageData data` and returning a `Container` sized `794x1123` (A4 @ 96dpi).
   Use `LogoWidget(data: data)` for the logo and `GroupMembersTable(data: data)` if it's a group template.
2. Register it in `lib/templates/template_registry.dart`'s `kTemplates` list, setting
   `usesGroupTable: true` if it should show the group-member form instead of a single student field.
That's it — it automatically shows up in the template picker, form, and export flow.

## Notes
- All templates render at exact A4 pixel ratio (794×1123 @ 96dpi) so the PDF output
  matches standard printable A4 size.
- Image export uses `pixelRatio: 3.0` for crisp, high-res output (~2382×3369px PNG).
- Uses Google Fonts (Merriweather, Poppins, Work Sans, Montserrat, Inter, Tinos, Noto Sans) —
  first run needs internet to fetch fonts once; consider bundling them locally via `google_fonts`
  offline config if you need fully offline builds.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens diambil dari UI Design - Mobile EduTech App.
class AppColors {
  AppColors._();

  static const background = Color(0xFFF5F7FB);
  static const surface = Colors.white;
  static const primary = Color(0xFF1F3A93);
  static const primaryPressed = Color(0xFF4A63AD);
  static const primarySoft = Color(0xFFE8EDF8);
  static const border = Color(0xFFD9E1EE);
  static const divider = Color(0xFFE3E8F1);

  static const textPrimary = Color(0xFF1A1D24);
  static const textSecondary = Color(0xFF5B6270);
  static const textMuted = Color(0xFF7A808C);

  static const disabled = Color(0xFFE3E6EB);
  static const disabledText = Color(0xFF6B7280);

  static const error = Color(0xFFC8352E);
  static const success = Color(0xFF1E7F4E);
  static const warning = Color(0xFFA86400);
  static const highlight = Color(0xFFFFE14D);
  static const progressBrown = Color(0xFF8A5A00);
  static const progressPurple = Color(0xFF6B4FBB);
  static const skeleton = Color(0xFFE5E9F0);

  // Warna latar ikon menu latihan.
  static const writingBg = Color(0xFFE6EAF4);
  static const readingBg = Color(0xFFF3EADB);
  static const readingIcon = Color(0xFF9A6A1E);
  static const speakingBg = Color(0xFFDDEFEF);
  static const speakingIcon = Color(0xFF2E8C8C);
  static const listeningBg = Color(0xFFEAE6F6);
  static const listeningIcon = Color(0xFF6B4FBB);
}

class AppText {
  AppText._();

  static TextStyle sans({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double? height,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );

  /// Font serif untuk teks tulisan/cerita (gaya kertas bergaris).
  static TextStyle serif({
    double size = 18,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double? height,
    FontStyle? style,
  }) =>
      GoogleFonts.sourceSerif4(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        fontStyle: style,
      );

  static TextStyle get display =>
      sans(size: 30, weight: FontWeight.w800, color: AppColors.primary);
  static TextStyle get h1 => sans(size: 28, weight: FontWeight.w700);
  static TextStyle get h2 => sans(size: 22, weight: FontWeight.w700);
  static TextStyle get h3 => sans(size: 19, weight: FontWeight.w600);
  static TextStyle get title => sans(size: 17, weight: FontWeight.w600);
  static TextStyle get body => sans(size: 16, color: AppColors.textSecondary, height: 1.5);
  static TextStyle get label => sans(size: 15, weight: FontWeight.w600);
  static TextStyle get caption => sans(size: 13, color: AppColors.textSecondary, height: 1.4);
  static TextStyle get small => sans(size: 12, color: AppColors.textSecondary, height: 1.4);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        error: AppColors.error,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
    return base.copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppText.sans(size: 20, weight: FontWeight.w600),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: AppColors.border,
        dragHandleSize: Size(32, 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
      ),
    );
  }
}


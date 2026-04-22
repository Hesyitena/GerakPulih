import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── COLORS ──────────────────────────────────────
  static const Color primary = Color(0xFF12E2A3);
  static const Color primaryDark = Color(0xFF02B87F);
  static const Color primaryLight = Color(0x2612E2A3);
  static const Color secondary = Color(0xFF9D50BB);
  static const Color secondaryDark = Color(0xFF6E48AA);
  static const Color secondaryLight = Color(0x269D50BB);
  static const Color warning = Color(0xFFFFB75E);
  static const Color danger = Color(0xFFFF5E62);
  static const Color success = Color(0xFF12E2A3);

  static const Color bgColor = Color(0xFFF8FAF9);
  static const Color bgCard = Color(0xB3FFFFFF); // 70% white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color dark = Color(0xFF1A2332);
  static const Color darkMedium = Color(0xFF2C3E55);
  static const Color textPrimary = Color(0xFF1A2332);
  static const Color textSecondary = Color(0xFF5A7184);
  static const Color textMuted = Color(0xFF8FA3B1);

  // Pose feedback
  static const Color poseGood = Color(0xD912E2A3);
  static const Color poseWarn = Color(0xD9FFB75E);
  static const Color poseBad = Color(0xD9FF5E62);

  // ── GRADIENTS ────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );
  static const LinearGradient meshGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8FAF9), Color(0xFFEEF7F4)],
  );

  // ── SHADOWS ──────────────────────────────────────
  static List<BoxShadow> get shadowSm => [
        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
      ];
  static List<BoxShadow> get shadowMd => [
        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 32, offset: const Offset(0, 12)),
        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4)),
      ];
  static List<BoxShadow> get shadowPrimary => [
        BoxShadow(color: primary.withOpacity(0.4), blurRadius: 32, offset: const Offset(0, 8)),
      ];

  // ── BORDER RADIUS ────────────────────────────────
  static const double rSm = 12;
  static const double rMd = 18;
  static const double rLg = 24;
  static const double rXl = 32;
  static const double rFull = 9999;

  // ── THEME DATA ───────────────────────────────────
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.nunitoTextTheme().copyWith(
          displayLarge: GoogleFonts.nunito(fontWeight: FontWeight.w900, color: textPrimary),
          headlineLarge: GoogleFonts.nunito(fontWeight: FontWeight.w900, color: textPrimary),
          headlineMedium: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: textPrimary),
          titleLarge: GoogleFonts.nunito(fontWeight: FontWeight.w700, color: textPrimary),
          bodyLarge: GoogleFonts.nunito(fontWeight: FontWeight.w500, color: textSecondary),
          bodyMedium: GoogleFonts.nunito(fontWeight: FontWeight.w500, color: textSecondary),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            color: textPrimary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rFull)),
            textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 16),
            elevation: 0,
          ),
        ),
      );
}

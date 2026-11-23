import 'package:flutter/material.dart';

/// Centralized color palette & design tokens for Let's Pay dark theme.
/// All colors are defined here so that UI changes propagate from one place.
abstract final class AppColors {
  // ── Background ──────────────────────────────────────────────────────────────
  static const Color bgPage = Color(0xFF0A0D14);
  static const Color bgPhone = Color(0xFF0E1120);
  static const Color bgSurface = Color(0xFF141828);
  static const Color bgSurface2 = Color(0xFF1C2235);

  // ── Brand / Accent ───────────────────────────────────────────────────────────
  static const Color accentPrimary = Color(0xFF6C63FF);
  static const Color accentSecondary = Color(0xFF3B82F6);
  static const Color accentElectric = Color(0xFF60A5FA);

  // ── Gradient stops ────────────────────────────────────────────────────────────
  /// Top-to-bottom dark background gradient
  static const List<Color> bgGradient = [
    Color(0xFF1A1D35),
    Color(0xFF0F1225),
    Color(0xFF0C0F1E),
    Color(0xFF111428),
  ];

  /// Primary button gradient
  static const List<Color> btnPrimary = [
    Color(0xFF6C63FF),
    Color(0xFF3B82F6),
  ];

  // ── Card Colors ──────────────────────────────────────────────────────────────
  static const Color cardBlueDeep = Color(0xFF1E3A8A);
  static const Color cardBlueMid = Color(0xFF1E40AF);
  static const Color cardBlueBright = Color(0xFF2563EB);
  static const Color cardBlueLight = Color(0xFF3B82F6);

  // ── Text ─────────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFF8B9DC3);
  static const Color textMuted = Color(0xFF4B5A7A);

  // ── Utility ──────────────────────────────────────────────────────────────────
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;
}

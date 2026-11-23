import 'package:flutter/material.dart';

/// Typography tokens for Let's Pay.
/// Uses Flutter's built-in system fonts (no external package needed).
abstract final class AppTextStyles {
  // ── Brand Heading ─────────────────────────────────────────────────────────────
  static const TextStyle brandTitle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.0,
    height: 0.95,
  );

  // ── Tagline ───────────────────────────────────────────────────────────────────
  static const TextStyle tagline = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.7,
    letterSpacing: 0.2,
  );

  // ── Button ───────────────────────────────────────────────────────────────────
  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );

  // ── Terms ────────────────────────────────────────────────────────────────────
  static const TextStyle terms = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.1,
  );

  static const TextStyle termsLink = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
}

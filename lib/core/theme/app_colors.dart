import 'package:flutter/material.dart';

/// Brand palette used across the app (extracted from inline hex literals).
abstract final class AppColors {
  /// Primary brand red.
  static const Color primary = Color(0xffef2b39);

  /// Warm cream hero background on auth/onboarding screens.
  static const Color cream = Color(0xffffefbf);

  /// Soft field background.
  static const Color fieldFill = Color(0xFFececf8);

  /// Brown accent used on the onboarding CTA.
  static const Color brown = Color(0xff8c592a);

  static final Color primaryGrey = Colors.black38;
}
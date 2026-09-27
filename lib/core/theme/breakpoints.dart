import 'package:flutter/widgets.dart';

/// Three-tier responsive breakpoints for the portrait-first app (width only).
///
/// Ported from the iBIZ `useBreakpoints` hook:
///
///   small  < 480dp — phones (360–430dp typical)
///   medium 480–767 — large phones, foldables, small tablets (7–8")
///   large  ≥ 768dp — tablets / web
///
/// Deliberately NOT Material's 600/840/1200 buckets: those collapse every
/// phone into a single base tier. 480/768 keeps a distinct medium tier.
/// Thresholds and the large-tier content width live here so the whole scheme
/// is configurable in one place.
const double smallMaxWidth = 480;
const double mediumMaxWidth = 768;

/// Readable content column on the large tier (tablets / web).
const double contentMaxWidth = 900;

enum AppBreakpoint { small, medium, large }

AppBreakpoint breakpointForWidth(double width) {
  if (width < smallMaxWidth) return AppBreakpoint.small;
  if (width < mediumMaxWidth) return AppBreakpoint.medium;
  return AppBreakpoint.large;
}

class AppBreakpoints {
  final double width;
  final AppBreakpoint breakpoint;

  const AppBreakpoints({required this.width, required this.breakpoint});

  bool get isSmall => breakpoint == AppBreakpoint.small;
  bool get isMedium => breakpoint == AppBreakpoint.medium;
  bool get isLarge => breakpoint == AppBreakpoint.large;
}

extension BreakpointsContext on BuildContext {
  /// Current width tier — rebuilds whenever [MediaQuery] reports a size change
  /// (resize, fold, orientation), mirroring `useBreakpoints()`.
  AppBreakpoints get breakpoints {
    final width = MediaQuery.sizeOf(this).width;
    return AppBreakpoints(width: width, breakpoint: breakpointForWidth(width));
  }

  /// Horizontal gutter used by page-level layouts, scaled by tier.
  double get pageGutter => breakpoints.isSmall ? 16 : 24;

  /// Maximum width any screen content column should reach on the large tier.
  double get contentWidth => contentMaxWidth;
}

/// Design-driven font scale factor (independent of OS accessibility scaling).
/// The app's styles use large fixed point sizes; shrink them on narrow phones
/// and grow slightly on tablets/web so single-line type never overflows.
double textScaleForWidth(double width) {
  if (width < smallMaxWidth) return 0.85;
  if (width < mediumMaxWidth) return 1.0;
  return 1.1;
}
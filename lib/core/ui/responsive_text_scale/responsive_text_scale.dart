import 'package:flutter/material.dart';

import '../../theme/breakpoints.dart';

/// Applies the design-driven font scale (see [textScaleForWidth]) on top of the
/// platform accessibility text scale, with both combined clamped to 1.3x so
/// unbounded OS font scaling can't break layouts.
///
/// Mirrors the iBIZ `FONT_SCALES` idea. Use via the `MaterialApp.builder`.
class ResponsiveTextScale extends StatelessWidget {
  final Widget child;

  const ResponsiveTextScale({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final base = MediaQuery.textScalerOf(context);
    final factor =
        (base.scale(1.0) * textScaleForWidth(width)).clamp(0.8, 1.3);
    final data = MediaQuery.of(context)
        .copyWith(textScaler: TextScaler.linear(factor));
    return MediaQuery(data: data, child: child);
  }
}
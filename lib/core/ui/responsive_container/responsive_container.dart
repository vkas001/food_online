import 'package:flutter/widgets.dart';

import '../../theme/breakpoints.dart';

/// Centers screen content in a readable column on the large tier (tablets /
/// web) while staying full-bleed on small/medium.
///
/// Ported from the iBIZ `ResponsiveContainer`.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;

  const ResponsiveContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isLarge = context.breakpoints.isLarge;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isLarge ? contentMaxWidth : double.infinity,
        ),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
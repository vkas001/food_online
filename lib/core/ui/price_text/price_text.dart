import 'package:flutter/material.dart';

import '../../theme/text_styles.dart';

/// Formats a numeric amount as `RS <value>`.
class PriceText extends StatelessWidget {
  final int amount;
  final TextStyle? style;

  const PriceText({super.key, required this.amount, this.style});

  @override
  Widget build(BuildContext context) {
    return Text('RS $amount', style: style ?? AppStyles.white());
  }
}
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

/// Primary rounded brand button (red pill by default).
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final double width;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.color = AppColors.primary,
    this.width = 150,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(label, style: AppStyles.white()),
        ),
      ),
    );
  }
}
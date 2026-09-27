import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../models/category_model.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;
  final String categoryIndex;
  final String track;
  final ValueChanged<String> onTap;

  const CategoryTile({
    super.key,
    required this.category,
    required this.categoryIndex,
    required this.track,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = track == categoryIndex;
    final name = category.name ?? '';
    final image = category.image ?? '';

    return GestureDetector(
      onTap: () => onTap(categoryIndex),
      child: isSelected
          ? Container(
              margin: const EdgeInsets.only(right: 20.0, bottom: 10.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        image,
                        height: 100,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10.0),
                      Text(name, style: AppStyles.white()),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              margin: const EdgeInsets.only(right: 20.0, bottom: 10.0),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  Image.asset(image, height: 50, width: 50, fit: BoxFit.cover),
                  const SizedBox(width: 10.0),
                  Text(name, style: AppStyles.simple()),
                ],
              ),
            ),
    );
  }
}
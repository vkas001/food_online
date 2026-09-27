import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/breakpoints.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/ui/responsive_container/responsive_container.dart';
import '../models/category_model.dart';
import '../models/menu_item.dart';
import '../services/catalog_data.dart';
import '../widgets/category_tile/category_tile.dart';
import '../widgets/food_tile/food_tile.dart';

/// Menu browse screen (ported from `pages/home_page.dart`).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categories = [];
  String track = "0";
  String _query = "";

  static const double _minTileWidth = 140;
  static const int _maxColumns = 4;

  @override
  void initState() {
    categories = getCategories();
    super.initState();
  }

  List<MenuItem> get _visibleItems {
    final base = itemsForCategory(track);
    if (_query.isEmpty) return base;
    final q = _query.toLowerCase();
    return base.where((i) => i.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final gutter = context.pageGutter;
    final gap = context.breakpoints.isSmall ? 12.0 : 20.0;

    return Scaffold(
      body: ResponsiveContainer(
        child: Container(
          margin: EdgeInsets.only(left: gutter, top: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "images/logo.png",
                          height: 80,
                          width: 80,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          "Order your favourite food!",
                          style: AppStyles.simple(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: gutter),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10.0),
                      child: Image.asset(
                        "images/user.jpg",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      margin: EdgeInsets.only(right: gutter),
                      decoration: BoxDecoration(
                        color: AppColors.fieldFill,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        onChanged: (value) => setState(() => _query = value),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search...",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(Icons.search, color: Colors.white, size: 30.0),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryTile(
                      category: categories[index],
                      categoryIndex: index.toString(),
                      track: track,
                      onTap: (index) => setState(() => track = index),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Column count adapts to the measured width (min tile width
                    // math) — the iBIZ `columnCountFor` approach.
                    final cols = ((constraints.maxWidth + gap) /
                            (_minTileWidth + gap))
                        .floor()
                        .clamp(1, _maxColumns.toInt())
                        .toInt();
                    final tileWidth =
                        (constraints.maxWidth - gap * (cols - 1)) / cols;
                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        // Fixed-ish tile height so images stay usable.
                        childAspectRatio: tileWidth / 215,
                        mainAxisSpacing: gap,
                        crossAxisSpacing: gap,
                      ),
                      itemCount: _visibleItems.length,
                      itemBuilder: (context, index) {
                        return FoodTile(item: _visibleItems[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
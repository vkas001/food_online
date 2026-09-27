import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/ui/responsive_container/responsive_container.dart';

class ShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    // System navigation bar inset (gesture pill / 3-button bar). The bar's
    // black background extends over it; only the tab icons sit above it.
    final systemBottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      body: ResponsiveContainer(child: navigationShell),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: EdgeInsets.only(bottom: systemBottomInset),
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              _Tab(
                index: 0,
                icon: Icons.home,
                navigationShell: navigationShell,
              ),
              _Tab(
                index: 1,
                icon: Icons.shopping_bag,
                navigationShell: navigationShell,
              ),
              _Tab(
                index: 2,
                icon: Icons.wallet,
                navigationShell: navigationShell,
              ),
              _Tab(
                index: 3,
                icon: Icons.person,
                navigationShell: navigationShell,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final int index;
  final IconData icon;
  final StatefulNavigationShell navigationShell;

  const _Tab({
    required this.index,
    required this.icon,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = navigationShell.currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => navigationShell.goBranch(
          index,
          initialLocation: isSelected,
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}
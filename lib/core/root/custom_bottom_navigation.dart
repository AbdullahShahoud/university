import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../theme/theme_extensions.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final List<NavigationItem> items;
  final ValueChanged<int> onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return CurvedNavigationBar(
      index: currentIndex,
      items: items
          .map((item) => Icon(item.icon, size: 30.w, color: Colors.white))
          .toList(),
      color: colors.primary,
      height: 60.h,
      buttonBackgroundColor: colors.primary,
      // backgroundColor: Colors.transparent,
      animationCurve: Curves.easeIn,
      animationDuration: const Duration(milliseconds: 600),
      onTap: onTap,
      letIndexChange: (index) => true,
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  NavigationItem({
    required this.icon,
    required this.color,
    required this.activeIcon,
    required this.label,
  });
}

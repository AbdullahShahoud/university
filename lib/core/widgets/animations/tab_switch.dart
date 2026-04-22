import 'package:flutter/material.dart';

/// A smooth tab switcher that provides fade and slide transitions between tab content.
/// Perfect for bottom navigation tabs and profile section tabs.
///
/// Features:
/// - Fade transition with optional slide
/// - Configurable slide direction and distance
/// - Smooth curve animations
/// - Maintains layout stability
class AnimatedTabSwitcher extends StatelessWidget {
  const AnimatedTabSwitcher({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.slideDirection = AxisDirection.right,
    this.slideDistance = 20.0,
  });

  final int index;
  final List<Widget> children;
  final Duration duration;
  final Curve curve;
  final AxisDirection slideDirection;
  final double slideDistance;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (child, animation) {
        final slideAnimation = Tween<Offset>(
          begin: _getSlideOffset(slideDirection),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      child: children[index],
    );
  }

  Offset _getSlideOffset(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return Offset(0, slideDistance / 100);
      case AxisDirection.down:
        return Offset(0, -slideDistance / 100);
      case AxisDirection.left:
        return Offset(slideDistance / 100, 0);
      case AxisDirection.right:
        return Offset(-slideDistance / 100, 0);
    }
  }
}

/// A specialized tab switcher for bottom navigation.
/// Provides horizontal slide transitions optimized for navigation.
class BottomNavTabSwitcher extends StatelessWidget {
  const BottomNavTabSwitcher({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AnimatedTabSwitcher(
      index: currentIndex,
      children: children,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      slideDirection: AxisDirection.right,
      slideDistance: 30.0,
    );
  }
}

/// A specialized tab switcher for profile section tabs.
/// Provides subtle vertical slide transitions for section changes.
class ProfileTabSwitcher extends StatelessWidget {
  const ProfileTabSwitcher({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AnimatedTabSwitcher(
      index: currentIndex,
      children: children,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      slideDirection: AxisDirection.up,
      slideDistance: 15.0,
    );
  }
}

/// A custom tab bar that integrates with AnimatedTabSwitcher.
/// Provides visual feedback for tab selection with smooth transitions.
class AnimatedTabBar extends StatelessWidget {
  const AnimatedTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorWeight = 2.0,
    this.tabBarHeight = 48.0,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final double indicatorWeight;
  final double tabBarHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: tabBarHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        controller: DefaultTabController.of(context),
        onTap: onTabSelected,
        indicatorColor: indicatorColor ?? theme.primaryColor,
        labelColor: labelColor ?? theme.primaryColor,
        unselectedLabelColor: unselectedLabelColor ?? theme.colorScheme.onSurface.withOpacity(0.6),
        indicatorWeight: indicatorWeight,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.bodyMedium,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        tabAlignment: TabAlignment.start,
        isScrollable: true,
      ),
    );
  }
}

/// A complete tab view system that combines AnimatedTabSwitcher with AnimatedTabBar.
/// Provides a seamless tabbed interface with smooth transitions.
class AnimatedTabView extends StatefulWidget {
  const AnimatedTabView({
    super.key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.onTabChanged,
    this.tabBarHeight = 48.0,
    this.slideDirection = AxisDirection.right,
    this.slideDistance = 20.0,
  });

  final List<String> tabs;
  final List<Widget> children;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final double tabBarHeight;
  final AxisDirection slideDirection;
  final double slideDistance;

  @override
  State<AnimatedTabView> createState() => _AnimatedTabViewState();
}

class _AnimatedTabViewState extends State<AnimatedTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _tabController.addListener(() {
      widget.onTabChanged?.call(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedTabBar(
          tabs: widget.tabs,
          selectedIndex: _tabController.index,
          onTabSelected: (index) {
            setState(() {
              _tabController.index = index;
            });
          },
          tabBarHeight: widget.tabBarHeight,
        ),
        Expanded(
          child: AnimatedTabSwitcher(
            index: _tabController.index,
            children: widget.children,
            slideDirection: widget.slideDirection,
            slideDistance: widget.slideDistance,
          ),
        ),
      ],
    );
  }
}
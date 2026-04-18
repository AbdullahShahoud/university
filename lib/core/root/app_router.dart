import 'package:flutter/material.dart';
import '../../features/explore/ui/screens/explore_screen.dart';
import '../../features/favorites/ui/screens/favorites_screen.dart';
import '../../features/news/ui/screens/news_screen.dart';
import '../../features/notifications/ui/screens/notifications_screen.dart';
import '../../features/profile/ui/screens/profile_screen.dart';
import '../localization/app_localizations.dart';
import 'custom_bottom_navigation.dart';

/// App Router
///
/// Defines named routes and navigation structure for all features
class AppRouter {
  // Named routes
  static const String explore = '/explore';
  static const String startupProfile = '/startup_profile';
  static const String news = '/news';
  static const String favorites = '/favorites';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  /// Get all screens in the correct navigation order
  static List<Widget> getScreens() {
    return [
      const ExploreScreen(),
      // const StartupProfileScreen(startupId: 'placeholder'),
      const NewsScreen(),
      const FavoritesScreen(),
      const NotificationsScreen(),
      const ProfileScreen(),
    ];
  }

  /// Get bottom navigation items for the custom navigation bar
  static List<NavigationItem> getNavigationItems(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      NavigationItem(
        icon: Icons.search_outlined,
        activeIcon: Icons.search,
        label: localizations.explore,
      ),
      NavigationItem(
        icon: Icons.article_outlined,
        activeIcon: Icons.article,
        label: localizations.news,
      ),
      NavigationItem(
        icon: Icons.person_add_outlined,
        activeIcon: Icons.person_add,
        label: localizations.followings,
      ),
      NavigationItem(
        icon: Icons.notifications_none,
        activeIcon: Icons.notifications,
        label: localizations.notifications,
      ),
      NavigationItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: localizations.profile,
      ),
    ];
  }

  /// Get bottom navigation bar items (deprecated - use getNavigationItems)
  @Deprecated('Use getNavigationItems instead')
  static List<BottomNavigationBarItem> getBottomNavigationBarItems(
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context)!;

    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.search_outlined),
        activeIcon: const Icon(Icons.search),
        label: localizations.explore,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.article_outlined),
        activeIcon: const Icon(Icons.article),
        label: localizations.news,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_add_outlined),
        activeIcon: const Icon(Icons.person_add),
        label: localizations.followings,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.notifications_none),
        activeIcon: const Icon(Icons.notifications),
        label: localizations.notifications,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline),
        activeIcon: const Icon(Icons.person),
        label: localizations.profile,
      ),
    ];
  }
}

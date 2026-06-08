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
      const NewsScreen(),
      const FavoritesScreen(),
      const ExploreScreen(),

      const NotificationsScreen(),
      const ProfileScreen(),
    ];
  }

  /// Get bottom navigation items for the custom navigation bar
  static List<NavigationItem> getNavigationItems(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      NavigationItem(
        icon: Icons.article_outlined,
        activeIcon: Icons.article,

        label: localizations.news,
        color: Colors.white,
      ),
      NavigationItem(
        icon: Icons.person_add_outlined,
        activeIcon: Icons.person_add,
        label: localizations.followings,
        color: Colors.white,
      ),
      NavigationItem(
        icon: Icons.search_outlined,
        activeIcon: Icons.search,
        label: localizations.explore,
        color: Colors.white,
      ),
      NavigationItem(
        icon: Icons.notifications_none,
        activeIcon: Icons.notifications,
        label: localizations.notifications,
        color: Colors.white,
      ),
      NavigationItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: localizations.profile,
        color: Colors.white,
      ),
    ];
  }

  /// Get bottom navigation bar items (deprecated - use getNavigationItems)
  @Deprecated('Use getNavigationItems instead')
  static List<BottomNavigationBarItem> getBottomNavigationBarItems(
    BuildContext context,
  ) {
    // final localizations = AppLocalizations.of(context)!;

    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.search_outlined, color: Colors.white),
        activeIcon: const Icon(Icons.search, color: Colors.white),
        backgroundColor: Colors.transparent,
        // label: localizations.explore,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.article_outlined, color: Colors.white),
        activeIcon: const Icon(Icons.article, color: Colors.white),
        backgroundColor: Colors.transparent,

        // label: localizations.news,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_add_outlined, color: Colors.white),
        activeIcon: const Icon(Icons.person_add, color: Colors.white),
        // label: localizations.followings,
        backgroundColor: Colors.transparent,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.notifications_none, color: Colors.white),
        activeIcon: const Icon(Icons.notifications, color: Colors.white),
        backgroundColor: Colors.transparent,

        // label: localizations.notifications,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline, color: Colors.white),
        activeIcon: const Icon(Icons.person, color: Colors.white),
        backgroundColor: Colors.transparent,

        // label: localizations.profile,
      ),
    ];
  }
}

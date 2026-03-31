import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/explore/data/repo/explore_repository.dart';
import '../../features/explore/logic/cubit/explore_cubit.dart';
import '../../features/favorites/data/repositories/favorites_repository.dart';
import '../../features/favorites/logic/cubit/favorites_cubit.dart';
import '../../features/news/data/repositories/news_repository.dart';
import '../../features/news/logic/cubit/news_cubit.dart';
import '../../features/notifications/data/repositories/notifications_repository.dart';
import '../../features/notifications/logic/cubit/notifications_cubit.dart';
import '../../features/profile/logic/cubit/profile_cubit.dart';
import '../../features/startup_profile/data/repo/startup_repository.dart';
import '../../features/startup_profile/logic/cubit/startup_cubit.dart';
import '../../core/root/navigation_cubit.dart';

/// Service Locator - GetIt dependency injection setup
final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> setupServiceLocator() async {
  // Register HTTP client
  getIt.registerSingleton<Dio>(
    Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    ),
  );

  // Register Repositories
  _registerRepositories();

  // Register Cubits
  _registerCubits();
}

/// Register all repositories
void _registerRepositories() {
  // Explore Repository
  getIt.registerSingleton<ExploreRepository>(
    ExploreRepositoryImpl(getIt<Dio>()),
  );

  // Startup Repository
  getIt.registerSingleton<StartupRepository>(
    StartupRepositoryImpl(getIt<Dio>()),
  );

  // News Repository
  getIt.registerSingleton<NewsRepository>(NewsRepositoryImpl(getIt<Dio>()));

  // Notifications Repository
  getIt.registerSingleton<NotificationsRepository>(
    NotificationsRepositoryImpl(getIt<Dio>()),
  );

  // Favorites Repository
  getIt.registerSingleton<FavoritesRepository>(
    FavoritesRepositoryImpl(getIt<Dio>()),
  );
}

/// Register all cubits
void _registerCubits() {
  // Navigation Cubit (Singleton)
  getIt.registerSingleton<NavigationCubit>(NavigationCubit());

  // Profile Cubit (Singleton - for theme & language management)
  getIt.registerSingleton<ProfileCubit>(ProfileCubit());

  // Explore Cubit (Singleton)
  getIt.registerSingleton<ExploreCubit>(
    ExploreCubit(getIt<ExploreRepository>()),
  );

  // Startup Cubit (Singleton)
  getIt.registerSingleton<StartupCubit>(
    StartupCubit(getIt<StartupRepository>()),
  );

  // News Cubit (Singleton)
  getIt.registerSingleton<NewsCubit>(NewsCubit(getIt<NewsRepository>()));

  // Notifications Cubit (Singleton)
  getIt.registerSingleton<NotificationsCubit>(
    NotificationsCubit(getIt<NotificationsRepository>()),
  );

  // Favorites Cubit (Singleton)
  getIt.registerSingleton<FavoritesCubit>(
    FavoritesCubit(getIt<FavoritesRepository>()),
  );
}

/// Helper to access repositories from anywhere
class RepositoryLocator {
  static ExploreRepository get explore => getIt<ExploreRepository>();
  static StartupRepository get startup => getIt<StartupRepository>();
  static NewsRepository get news => getIt<NewsRepository>();
  static NotificationsRepository get notifications =>
      getIt<NotificationsRepository>();
  static FavoritesRepository get favorites => getIt<FavoritesRepository>();
}

/// Helper to access cubits from anywhere
class CubitLocator {
  static NavigationCubit get navigation => getIt<NavigationCubit>();
  static ProfileCubit get profile => getIt<ProfileCubit>();
  static ExploreCubit get explore => getIt<ExploreCubit>();
  static StartupCubit get startup => getIt<StartupCubit>();
  static NewsCubit get news => getIt<NewsCubit>();
  static NotificationsCubit get notifications => getIt<NotificationsCubit>();
  static FavoritesCubit get favorites => getIt<FavoritesCubit>();
}

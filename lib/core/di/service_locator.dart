import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../networking/dio_factory.dart';

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
import '../../features/auth/data/repo/auth_repository.dart';
import '../../features/auth/logic/cubit/auth_cubit.dart';
import '../../features/hub/data/repo/hub_repository.dart';
import '../../features/hub/logic/cubit/hub_cubit.dart';
import '../../core/root/navigation_cubit.dart';

/// Service Locator - GetIt dependency injection setup
final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> setupServiceLocator() async {
  // Register HTTP client
  // Use centralized DioFactory to get configured Dio (baseUrl + interceptors)
  getIt.registerSingleton<Dio>(DioFactory.createDio());

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

  // Auth Repository
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(getIt<Dio>()));

  // Hub Repository
  getIt.registerSingleton<HubRepository>(HubRepositoryImpl(getIt<Dio>()));

  // Hub Cubit
  getIt.registerSingleton<HubCubit>(HubCubit(getIt<HubRepository>()));
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

  // Startup Cubit (Factory - new instance each time)
  getIt.registerFactory<StartupCubit>(
    () => StartupCubit(getIt<StartupRepository>()),
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

  // Auth Cubit (Singleton)
  getIt.registerSingleton<AuthCubit>(
    AuthCubit(authRepository: getIt<AuthRepository>()),
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
  static AuthRepository get auth => getIt<AuthRepository>();
  static HubRepository get hub => getIt<HubRepository>();
  static HubCubit get hubCubit => getIt<HubCubit>();
}

/// Helper to access cubits from anywhere
class CubitLocator {
  static NavigationCubit get navigation => getIt<NavigationCubit>();
  static ProfileCubit get profile => getIt<ProfileCubit>();
  static AuthCubit get auth => getIt<AuthCubit>();
  static ExploreCubit get explore => getIt<ExploreCubit>();
  static StartupCubit get startup => getIt<StartupCubit>();
  static NewsCubit get news => getIt<NewsCubit>();
  static NotificationsCubit get notifications => getIt<NotificationsCubit>();
  static FavoritesCubit get favorites => getIt<FavoritesCubit>();
}

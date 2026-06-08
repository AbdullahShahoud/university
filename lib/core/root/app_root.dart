import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/profile/logic/cubit/profile_cubit.dart';
import '../../features/onboarding/ui/screens/onboarding_screen.dart';
import '../../features/onboarding/logic/cubit/onboarding_cubit.dart';
import '../../features/onboarding/data/repo/onboarding_repository.dart';
import '../../features/auth/logic/cubit/auth_cubit.dart';
import '../../features/auth/ui/screens/login_screen.dart';
import '../localization/app_localizations.dart';
import '../theme/theme.dart';
import '../di/service_locator.dart';
import 'app_router.dart';
import 'auth_router.dart';
import 'navigation_cubit.dart';
import 'custom_bottom_navigation.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _isOnboardingCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
    // Load settings only once when app starts
    getIt<ProfileCubit>().loadSettings();
    // Check auth status
    getIt<AuthCubit>().checkAuthStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isOnboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    });
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    setState(() {
      _isOnboardingCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>.value(value: getIt<ProfileCubit>()),
            BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
          ],
          child: BlocBuilder<ProfileCubit, ProfileState>(
            bloc: getIt<ProfileCubit>(),
            buildWhen: (previous, current) =>
                previous.isDarkTheme != current.isDarkTheme ||
                previous.languageCode != current.languageCode,
            builder: (context, profileState) {
              return MaterialApp(
                title: 'Audience App',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                debugShowCheckedModeBanner: false,
                themeMode: profileState.isDarkTheme
                    ? ThemeMode.dark
                    : ThemeMode.light,
                locale: Locale(profileState.languageCode),
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ar', 'SY'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                onGenerateRoute: (settings) =>
                    AuthRouter.generateRoute(settings),
                home: _buildHome(),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHome() {
    return BlocListener<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      listener: (context, state) {
        // Handle auth state changes if needed
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        bloc: getIt<AuthCubit>(),
        builder: (context, authState) {
          // If onboarding not completed, show onboarding
          if (!_isOnboardingCompleted) {
            return OnboardingScreenWrapper(onCompleted: _completeOnboarding);
          }

          // If authenticated, show main app
          if (authState.status == AuthStatus.authenticated) {
            return const MainScreen();
          }

          // Otherwise show login
          return const LoginScreen();
        },
      ),
    );
  }
}

class OnboardingScreenWrapper extends StatelessWidget {
  final VoidCallback onCompleted;

  const OnboardingScreenWrapper({super.key, required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(OnboardingRepository()),
      child: OnboardingWrapperView(onCompleted: onCompleted),
    );
  }
}

class OnboardingWrapperView extends StatelessWidget {
  final VoidCallback onCompleted;

  const OnboardingWrapperView({super.key, required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          onCompleted();
        }
      },
      child: const OnboardingScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      bloc: getIt<NavigationCubit>(),
      builder: (context, state) {
        final navigationItems = AppRouter.getNavigationItems(context);

        return Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: IndexedStack(
              index: state.currentIndex,
              children: AppRouter.getScreens(),
            ),
          ),
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: state.currentIndex,
            items: navigationItems,
            onTap: (index) {
              getIt<NavigationCubit>().changeTab(index);
            },
          ),
        );
      },
    );
  }
}

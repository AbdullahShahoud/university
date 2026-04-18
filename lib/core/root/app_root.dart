import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/profile/logic/cubit/profile_cubit.dart';
import '../localization/app_localizations.dart';
import '../theme/theme.dart';
import '../di/service_locator.dart';
import 'app_router.dart';
import 'navigation_cubit.dart';
import 'custom_bottom_navigation.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    super.initState();
    // Load settings only once when app starts
    getIt<ProfileCubit>().loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ProfileCubit, ProfileState>(
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
              supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SY')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const MainScreen(),
            );
          },
        );
      },
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
          body: IndexedStack(
            index: state.currentIndex,
            children: AppRouter.getScreens(),
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

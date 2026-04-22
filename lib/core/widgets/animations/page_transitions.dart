import 'package:flutter/material.dart';

/// Custom page transition for the app
/// Slide from right with fade, duration ~250ms
class AppPageTransition extends PageTransitionsBuilder {
  const AppPageTransition();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    var fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ));

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }
}

/// Custom theme data with app page transitions
class AppThemeData {
  AppThemeData._();

  static ThemeData create({
    Brightness? brightness,
    Color? primaryColor,
    Color? scaffoldBackgroundColor,
    AppBarTheme? appBarTheme,
    BottomNavigationBarThemeData? bottomNavigationBarTheme,
    TextTheme? textTheme,
    IconThemeData? iconTheme,
    CardThemeData? cardTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    FilledButtonThemeData? filledButtonTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    TextButtonThemeData? textButtonTheme,
    InputDecorationTheme? inputDecorationTheme,
    CheckboxThemeData? checkboxTheme,
    SwitchThemeData? switchTheme,
    RadioThemeData? radioTheme,
    SliderThemeData? sliderTheme,
    TabBarThemeData? tabBarTheme,
    TooltipThemeData? tooltipTheme,
    DialogThemeData? dialogTheme,
    TimePickerThemeData? timePickerTheme,
    DatePickerThemeData? datePickerTheme,
    SnackBarThemeData? snackBarTheme,
    MaterialTapTargetSize? materialTapTargetSize,
    PageTransitionsTheme? pageTransitionsTheme,
  }) {
    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: appBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      textTheme: textTheme,
      iconTheme: iconTheme,
      cardTheme: cardTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      filledButtonTheme: filledButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      textButtonTheme: textButtonTheme,
      inputDecorationTheme: inputDecorationTheme,
      checkboxTheme: checkboxTheme,
      switchTheme: switchTheme,
      radioTheme: radioTheme,
      sliderTheme: sliderTheme,
      tabBarTheme: tabBarTheme,
      tooltipTheme: tooltipTheme,
      dialogTheme: dialogTheme,
      timePickerTheme: timePickerTheme,
      datePickerTheme: datePickerTheme,
      snackBarTheme: snackBarTheme,
      materialTapTargetSize: materialTapTargetSize,
      pageTransitionsTheme: pageTransitionsTheme ??
          const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: AppPageTransition(),
              TargetPlatform.iOS: AppPageTransition(),
              TargetPlatform.linux: AppPageTransition(),
              TargetPlatform.macOS: AppPageTransition(),
              TargetPlatform.windows: AppPageTransition(),
            },
          ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../features/auth/ui/screens/login_screen.dart';
import '../../features/auth/ui/screens/signup_screen.dart';
import '../../features/auth/ui/screens/forgot_password_screen.dart';
import '../../features/auth/ui/screens/verify_reset_code_screen.dart';
import '../../features/auth/ui/screens/reset_password_screen.dart';

/// Auth Router - Handles all authentication-related routes
class AuthRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verifyResetCode = '/verify-reset-code';
  static const String resetPassword = '/reset-password';

  /// Generate routes for authentication screens
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
          settings: settings,
        );
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
          settings: settings,
        );
      case verifyResetCode:
        final email = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => VerifyResetCodeScreen(email: email ?? ''),
          settings: settings,
        );
      case resetPassword:
        final resetToken = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(resetToken: resetToken ?? ''),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
    }
  }
}

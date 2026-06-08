import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/di/service_locator.dart';
import '../../../profile/logic/cubit/profile_cubit.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = AppLocalizations.of(context)!;
    final isArabic = getIt<ProfileCubit>().state.languageCode == 'ar';

    return Scaffold(
      body: SafeArea(
        child: Background(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                // Navigate to home screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'مرحبا ${state.userData?['user']?['fullName'] ?? 'المستخدم'}',
                    ),
                    backgroundColor: colors.success,
                  ),
                );
                // TODO: Navigate to home/main screen when ready
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 40.h),
                      // Header
                      Text(
                        'مرحبا بعودتك',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'تسجيل الدخول إلى حسابك للمتابعة',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 36.h),

                      // Error Banner
                      if (state.errorMessage != null)
                        Column(
                          children: [
                            ErrorBanner(message: state.errorMessage!),
                            SizedBox(height: 16.h),
                          ],
                        ),

                      // Email Field
                      AuthTextField(
                        label: 'البريد الإلكتروني',
                        hint: 'أدخل بريدك الإلكتروني',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        prefixIcon: Icons.email_outlined,
                      ),
                      SizedBox(height: 16.h),

                      // Password Field
                      AuthTextField(
                        label: 'كلمة المرور',
                        hint: 'أدخل كلمة المرور',
                        controller: _passwordController,
                        isPassword: true,
                        validator: _validatePassword,
                        prefixIcon: Icons.lock_outlined,
                      ),
                      SizedBox(height: 12.h),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to forgot password screen
                            Navigator.of(context).pushNamed('/forgot-password');
                          },
                          child: Text(
                            'هل نسيت كلمة المرور؟',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Login Button
                      AuthButton(
                        text: 'تسجيل الدخول',
                        isLoading: state.isLoading,
                        enabled: !state.isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Divider
                      AuthDivider(text: 'أو متابعة مع'),
                      SizedBox(height: 24.h),

                      // Social Buttons (placeholder)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialButton(
                            icon: 'assets/icons/google.png',
                            onPressed: () {
                              // TODO: Implement Google Sign In
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('سيتم تفعيل قريبا'),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 16.w),
                          SocialButton(
                            icon: 'assets/icons/apple.png',
                            onPressed: () {
                              // TODO: Implement Apple Sign In
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('سيتم تفعيل قريبا'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Sign Up Link
                      AuthLink(
                        text: 'ليس لديك حساب؟',
                        linkText: 'إنشاء حساب',
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/signup');
                        },
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

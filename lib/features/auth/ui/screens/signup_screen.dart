import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/background.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../widgets/auth_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم الكامل مطلوب';
    }
    if (value.length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    }
    return null;
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != _passwordController.text) {
      return 'كلمات المرور غير متطابقة';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Background(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إنشاء الحساب بنجاح'),
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
                      SizedBox(height: 32.h),
                      // Header
                      Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'انضم إلينا وابدأ رحلتك',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),

                      // Error Banner
                      if (state.errorMessage != null)
                        Column(
                          children: [
                            ErrorBanner(message: state.errorMessage!),
                            SizedBox(height: 16.h),
                          ],
                        ),

                      // Full Name Field
                      AuthTextField(
                        label: 'الاسم الكامل',
                        hint: 'أدخل اسمك الكامل',
                        controller: _fullNameController,
                        keyboardType: TextInputType.name,
                        validator: _validateFullName,
                        prefixIcon: Icons.person_outlined,
                      ),
                      SizedBox(height: 16.h),

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
                        hint: 'أدخل كلمة المرور (6 أحرف على الأقل)',
                        controller: _passwordController,
                        isPassword: true,
                        validator: _validatePassword,
                        prefixIcon: Icons.lock_outlined,
                      ),
                      SizedBox(height: 16.h),

                      // Confirm Password Field
                      AuthTextField(
                        label: 'تأكيد كلمة المرور',
                        hint: 'أعد إدخال كلمة المرور',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        validator: _validateConfirmPassword,
                        prefixIcon: Icons.lock_outlined,
                      ),
                      SizedBox(height: 16.h),

                      // Terms Agreement Checkbox
                      Row(
                        children: [
                          SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              activeColor: colors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'أوافق على شروط الخدمة وسياسة الخصوصية',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Sign Up Button
                      AuthButton(
                        text: 'إنشاء حساب',
                        isLoading: state.isLoading,
                        enabled: !state.isLoading && _agreeToTerms,
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _agreeToTerms) {
                            context.read<AuthCubit>().signup(
                              fullName: _fullNameController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                              passwordConfirm: _confirmPasswordController.text,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Divider
                      AuthDivider(text: 'أو إنشاء حساب مع'),
                      SizedBox(height: 24.h),

                      // Social Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialButton(
                            icon: 'assets/icons/google.png',
                            onPressed: () {
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

                      // Login Link
                      AuthLink(
                        text: 'هل لديك حساب بالفعل؟',
                        linkText: 'تسجيل الدخول',
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/login');
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

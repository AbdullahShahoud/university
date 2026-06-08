import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/background.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Background(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.isCodeSent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إرسال كود التحقق إلى بريدك الإلكتروني'),
                    backgroundColor: colors.success,
                  ),
                );
                // Navigate to verification code screen
                Navigator.of(context).pushNamed(
                  '/verify-reset-code',
                  arguments: _emailController.text.trim(),
                );
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

                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: colors.inputBackground,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: colors.inputBorder),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Header
                      Text(
                        'استرجع كلمة المرور',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'أدخل بريدك الإلكتروني وسنرسل لك كود للتحقق',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 36.h),

                      // Illustration/Icon
                      Container(
                        width: 200.w,
                        height: 200.w,
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Icon(
                          Icons.mail_outline_rounded,
                          size: 100.sp,
                          color: colors.primary,
                        ),
                      ),
                      SizedBox(height: 48.h),

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
                      SizedBox(height: 24.h),

                      // Send Code Button
                      AuthButton(
                        text: 'إرسال كود التحقق',
                        isLoading: state.isLoading,
                        enabled: !state.isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().sendResetCode(
                              email: _emailController.text.trim(),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Back to Login Link
                      AuthLink(
                        text: 'تذكرت كلمة المرور؟',
                        linkText: 'عد إلى التسجيل',
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
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

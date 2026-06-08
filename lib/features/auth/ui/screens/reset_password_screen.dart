import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/background.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../widgets/auth_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String resetToken;

  const ResetPasswordScreen({super.key, required this.resetToken});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
              if (state.status == AuthStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إعادة تعيين كلمة المرور بنجاح'),
                    backgroundColor: colors.success,
                  ),
                );
                // Navigate back to login
                Navigator.of(context).pushReplacementNamed('/login');
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
                        'أنشئ كلمة مرور جديدة',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'اختر كلمة مرور قوية وسهلة التذكر',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 36.h),

                      // Illustration
                      Container(
                        width: 200.w,
                        height: 200.w,
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Icon(
                          Icons.lock_reset_outlined,
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

                      // New Password Field
                      AuthTextField(
                        label: 'كلمة المرور الجديدة',
                        hint: 'أدخل كلمة مرور قوية',
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

                      // Password Requirements
                      SizedBox(height: 20.h),
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'متطلبات كلمة المرور:',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            _PasswordRequirement(
                              text: 'على الأقل 6 أحرف',
                              isChecked: _passwordController.text.length >= 6,
                              colors: colors,
                            ),
                            SizedBox(height: 6.h),
                            _PasswordRequirement(
                              text: 'تطابق كلمات المرور',
                              isChecked:
                                  _passwordController.text.isNotEmpty &&
                                  _confirmPasswordController.text.isNotEmpty &&
                                  _passwordController.text ==
                                      _confirmPasswordController.text,
                              colors: colors,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Reset Button
                      AuthButton(
                        text: 'إعادة تعيين كلمة المرور',
                        isLoading: state.isLoading,
                        enabled: !state.isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().resetPassword(
                              resetToken: widget.resetToken,
                              password: _passwordController.text,
                              passwordConfirm: _confirmPasswordController.text,
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
                          Navigator.of(context).pushReplacementNamed('/login');
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

class _PasswordRequirement extends StatelessWidget {
  final String text;
  final bool isChecked;
  final ColorExtension colors;

  const _PasswordRequirement({
    required this.text,
    required this.isChecked,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16.sp,
          color: isChecked ? colors.success : colors.textTertiary,
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: isChecked ? colors.success : colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

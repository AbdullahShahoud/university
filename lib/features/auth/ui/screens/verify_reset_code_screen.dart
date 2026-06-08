import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/background.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../widgets/auth_widgets.dart';

class VerifyResetCodeScreen extends StatefulWidget {
  final String email;

  const VerifyResetCodeScreen({super.key, required this.email});

  @override
  State<VerifyResetCodeScreen> createState() => _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends State<VerifyResetCodeScreen> {
  late List<TextEditingController> _codeControllers;
  final _formKey = GlobalKey<FormState>();
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _codeControllers = List.generate(6, (_) => TextEditingController());
    _startResendCountdown();
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startResendCountdown() {
    _resendCountdown = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          }
        });
      }
      return _resendCountdown > 0 && mounted;
    });
  }

  String _getVerificationCode() {
    return _codeControllers.map((c) => c.text).join();
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
              if (state.isCodeVerified) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم التحقق بنجاح'),
                    backgroundColor: colors.success,
                  ),
                );
                // Navigate to reset password screen
                Navigator.of(context).pushReplacementNamed(
                  '/reset-password',
                  arguments: state.resetToken,
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
                        'تحقق من بريدك',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'أدخل الكود المرسل إلى:\n${widget.email}',
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

                      // Code Input Fields
                      Text(
                        'كود التحقق',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 50.w,
                            height: 60.h,
                            child: TextField(
                              controller: _codeControllers[index],
                              maxLength: 1,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                fillColor: colors.inputBackground,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: colors.inputBorder,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: colors.inputBorder,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: colors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 24.h),

                      // Verify Button
                      AuthButton(
                        text: 'التحقق',
                        isLoading: state.isLoading,
                        enabled:
                            !state.isLoading &&
                            _getVerificationCode().length == 6,
                        onPressed: () {
                          context.read<AuthCubit>().verifyResetCode(
                            email: widget.email,
                            code: _getVerificationCode(),
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Resend Code
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'لم تستقبل الكود؟',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: colors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            if (_resendCountdown > 0)
                              Text(
                                'إعادة الإرسال بعد $_resendCountdown ثانية',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: colors.textTertiary,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () {
                                  context.read<AuthCubit>().sendResetCode(
                                    email: widget.email,
                                  );
                                  _startResendCountdown();
                                },
                                child: Text(
                                  'إعادة إرسال الكود',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: colors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
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

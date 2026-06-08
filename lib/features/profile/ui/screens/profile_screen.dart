import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:university/core/theme/theme_extensions.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/button.dart';
import '../../logic/cubit/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: getIt<ProfileCubit>(),
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Background(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          // Profile Header
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.scale(
                                  scale: 0.8 + (value * 0.2),
                                  child: child,
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                SizedBox(height: 20.h),

                                // Text(
                                //   localizations.profile,
                                //   style: TextStyle(fontSize: 20.sp),
                                // ),
                                // SizedBox(height: 20.h),
                                Container(
                                  width: 80.w,
                                  height: 80.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 40.w,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'تطبيق المستخدم',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'user@example.com',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          // Settings
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Theme Settings
                                _AnimatedSettingsSection(
                                  index: 0,
                                  title: 'المظهر',
                                  child: Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      border: Border.all(
                                        width: 2,
                                        color: AppColors.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              state.isDarkTheme
                                                  ? Icons.dark_mode
                                                  : Icons.light_mode,
                                              color: AppColors.primary,
                                              size: 24.w,
                                            ),
                                            SizedBox(width: 12.w),
                                            Text(
                                              'الوضع الليلي',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color:
                                                    context.colors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Switch(
                                          value: state.isDarkTheme,
                                          onChanged: (value) {
                                            getIt<ProfileCubit>().toggleTheme();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                // Language Settings
                                _AnimatedSettingsSection(
                                  index: 1,
                                  title: 'اللغة',
                                  child: Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      border: Border.all(
                                        width: 2,
                                        color: AppColors.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              state.languageCode == 'en'
                                                  ? Icons.language
                                                  : Icons.language,
                                              color: AppColors.primary,
                                              size: 24.w,
                                            ),
                                            SizedBox(width: 12.w),
                                            Text(
                                              state.languageCode == 'en'
                                                  ? 'English'
                                                  : 'العربية',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color:
                                                    context.colors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            final newLang =
                                                state.languageCode == 'en'
                                                ? 'ar'
                                                : 'en';
                                            getIt<ProfileCubit>().setLanguage(
                                              newLang,
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Text(
                                              state.languageCode == 'en'
                                                  ? 'العربية'
                                                  : 'English',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                // Account Settings
                                _AnimatedSettingsSection(
                                  index: 2,
                                  title: 'الحساب',
                                  child: Column(
                                    children: [
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0, end: 1),
                                        duration: Duration(
                                          milliseconds: 400 + (0 * 100),
                                        ),
                                        curve: Curves.easeInOut,
                                        builder: (context, value, child) {
                                          return Opacity(
                                            opacity: value,
                                            child: Transform.translate(
                                              offset: Offset(
                                                0,
                                                (1 - value) * 20,
                                              ),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: _buildSettingsTile(
                                          icon: Icons.account_circle,
                                          context: context,

                                          title: 'تعديل الملف الشخصي',
                                          onTap: () =>
                                              _showComingSoonSnackbar(context),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0, end: 1),
                                        duration: Duration(
                                          milliseconds: 400 + (1 * 100),
                                        ),
                                        curve: Curves.easeInOut,
                                        builder: (context, value, child) {
                                          return Opacity(
                                            opacity: value,
                                            child: Transform.translate(
                                              offset: Offset(
                                                0,
                                                (1 - value) * 20,
                                              ),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: _buildSettingsTile(
                                          context: context,

                                          icon: Icons.lock,
                                          title: 'تغيير كلمة المرور',
                                          onTap: () =>
                                              _showComingSoonSnackbar(context),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0, end: 1),
                                        duration: Duration(
                                          milliseconds: 400 + (2 * 100),
                                        ),
                                        curve: Curves.easeInOut,
                                        builder: (context, value, child) {
                                          return Opacity(
                                            opacity: value,
                                            child: Transform.translate(
                                              offset: Offset(
                                                0,
                                                (1 - value) * 20,
                                              ),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: _buildSettingsTile(
                                          context: context,

                                          icon: Icons.privacy_tip,
                                          title: 'إعدادات الخصوصية',
                                          onTap: () =>
                                              _showComingSoonSnackbar(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                // Support
                                _AnimatedSettingsSection(
                                  index: 3,
                                  title: 'الدعم',
                                  child: Column(
                                    children: [
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0, end: 1),
                                        duration: Duration(
                                          milliseconds: 400 + (0 * 100),
                                        ),
                                        curve: Curves.easeInOut,
                                        builder: (context, value, child) {
                                          return Opacity(
                                            opacity: value,
                                            child: Transform.translate(
                                              offset: Offset(
                                                0,
                                                (1 - value) * 20,
                                              ),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: _buildSettingsTile(
                                          icon: Icons.help,
                                          context: context,

                                          title: 'المساعدة والدعم',
                                          onTap: () =>
                                              _showComingSoonSnackbar(context),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0, end: 1),
                                        duration: Duration(
                                          milliseconds: 400 + (1 * 100),
                                        ),
                                        curve: Curves.easeInOut,
                                        builder: (context, value, child) {
                                          return Opacity(
                                            opacity: value,
                                            child: Transform.translate(
                                              offset: Offset(
                                                0,
                                                (1 - value) * 20,
                                              ),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: _buildSettingsTile(
                                          context: context,

                                          icon: Icons.description,
                                          title: 'الشروط والأحكام',
                                          onTap: () =>
                                              _showComingSoonSnackbar(context),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0, end: 1),
                                        duration: Duration(
                                          milliseconds: 400 + (2 * 100),
                                        ),
                                        curve: Curves.easeInOut,
                                        builder: (context, value, child) {
                                          return Opacity(
                                            opacity: value,
                                            child: Transform.translate(
                                              offset: Offset(
                                                0,
                                                (1 - value) * 20,
                                              ),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: _buildSettingsTile(
                                          context: context,
                                          icon: Icons.security,
                                          title: 'سياسة الخصوصية',
                                          onTap: () =>
                                              _showComingSoonSnackbar(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                // Logout
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0, end: 1),
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.scale(
                                        scale: 0.8 + (value * 0.2),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: AppButton(
                                    onPressed: () =>
                                        _showComingSoonSnackbar(context),
                                    text: 'تسجيل الخروج',
                                    backgroundColor: AppColors.error,
                                  ),
                                ),
                                SizedBox(height: 32.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(
          width: 2,
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Coming soon!'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.info,
      ),
    );
  }
}

// Animated Settings Section Widget
class _AnimatedSettingsSection extends StatelessWidget {
  final int index;
  final String title;
  final Widget child;

  const _AnimatedSettingsSection({
    required this.index,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/di/service_locator.dart';
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
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: getIt<ProfileCubit>(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(localizations.profile), elevation: 0),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Header
                      Column(
                        children: [
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
                              color: AppColors.textPrimary,
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
                      SizedBox(height: 24.h),
                      // Settings
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Theme Settings
                            Text(
                              'المظهر',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.inputBorder,
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
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Switch(
                                    value: state.isDarkTheme,
                                    onChanged: (value) {
                                      context
                                          .read<ProfileCubit>()
                                          .toggleTheme();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),
                            // Language Settings
                            Text(
                              'اللغة',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.inputBorder,
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
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final newLang = state.languageCode == 'en'
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
                                        color: AppColors.primary.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
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
                            SizedBox(height: 24.h),
                            // Account Settings
                            Text(
                              'الحساب',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            _buildSettingsTile(
                              icon: Icons.account_circle,
                              title: 'تعديل الملف الشخصي',
                              onTap: () => _showComingSoonSnackbar(context),
                            ),
                            SizedBox(height: 8.h),
                            _buildSettingsTile(
                              icon: Icons.lock,
                              title: 'تغيير كلمة المرور',
                              onTap: () => _showComingSoonSnackbar(context),
                            ),
                            SizedBox(height: 8.h),
                            _buildSettingsTile(
                              icon: Icons.privacy_tip,
                              title: 'إعدادات الخصوصية',
                              onTap: () => _showComingSoonSnackbar(context),
                            ),
                            SizedBox(height: 24.h),
                            // Support
                            Text(
                              'الدعم',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            _buildSettingsTile(
                              icon: Icons.help,
                              title: 'المساعدة والدعم',
                              onTap: () => _showComingSoonSnackbar(context),
                            ),
                            SizedBox(height: 8.h),
                            _buildSettingsTile(
                              icon: Icons.description,
                              title: 'الشروط والأحكام',
                              onTap: () => _showComingSoonSnackbar(context),
                            ),
                            SizedBox(height: 8.h),
                            _buildSettingsTile(
                              icon: Icons.security,
                              title: 'سياسة الخصوصية',
                              onTap: () => _showComingSoonSnackbar(context),
                            ),
                            SizedBox(height: 24.h),
                            // Logout
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () =>
                                    _showComingSoonSnackbar(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                ),
                                child: Text(
                                  'تسجيل الخروج',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),
                    ],
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
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inputBorder),
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
                style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
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

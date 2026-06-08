import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:university/core/theme/theme_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/button.dart';
import '../../data/models/favorite_startup.dart';
import '../../logic/cubit/favorites_cubit.dart';
import '../widgets/favorites_widgets.dart';
import 'follow_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FavoritesView();
  }
}

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
    // Load favorites on first build only
    getIt<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      bloc: getIt<FavoritesCubit>(),
      builder: (context, state) {
        return Scaffold(
          body: Background(
            child: state.isLoading
                ? const FavoritesShimmerLoading()
                : state.favorites.isEmpty && !state.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add_outlined,
                          size: 64.w,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'لا توجد شركات متابعة',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'ابدأ بمتابعة الشركات الناشئة المفضلة لك',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (state.errorMessage != null) ...[
                          SizedBox(height: 16.h),
                          Text(
                            state.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                        SizedBox(height: 16.h),
                        AppButton(
                          text: localizations.retry,
                          onPressed: () => getIt<FavoritesCubit>().retry(),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      getIt<FavoritesCubit>().loadFavorites();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            localizations.followings,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            height:
                                MediaQuery.of(context).size.height.h - 100.h,
                            child: ListView.builder(
                              padding: EdgeInsets.all(16.w),
                              itemCount: state.favorites.length,
                              itemBuilder: (context, index) {
                                final favorite = state.favorites[index];
                                return TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0, end: 1),
                                  duration: Duration(
                                    milliseconds: 300 + (index * 100),
                                  ),
                                  curve: Curves.easeInOut,
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, (1 - value) * 30),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: _buildFavoriteCard(context, favorite),
                                );
                              },
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

  Widget _buildFavoriteCard(BuildContext context, FavoriteStartup favorite) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FollowDetailsScreen(startup: favorite),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.inputBorder.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.white.withValues(alpha: 0.2),
        ),
        child: Row(
          children: [
            // Logo
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: AppColors.placeholder,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  favorite.logoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.business,
                      size: 24.w,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favorite.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    favorite.category,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Unfollow button
            GestureDetector(
              onTap: () {
                getIt<FavoritesCubit>().removeFromFavorites(favorite.id);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'إلغاء المتابعة',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

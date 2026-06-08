import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/button.dart';
import '../../logic/cubit/explore_cubit.dart';
import '../../../startup_profile/ui/screens/company_details_screen.dart';
import '../widgets/explore_widgets.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final colors = context.colors;

    // Initialize explore with the singleton
    getIt<ExploreCubit>().loadInitialData();

    return Scaffold(
      body: SafeArea(
        child: Background(
          child: BlocBuilder<ExploreCubit, ExploreState>(
            bloc: getIt<ExploreCubit>(),
            builder: (context, state) {
              if (state.isLoading) {
                return const ExploreShimmerLoading();
              }

              if (state.errorMessage != null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.errorMessage!,
                          style: TextStyle(
                            color: colors.error,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        AppButton(
                          text: localizations.retry,
                          onPressed: () => getIt<ExploreCubit>().retry(),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final categories = state.categories;
              final startups = state.searchQuery?.isNotEmpty == true
                  ? state.searchResults
                  : state.latestStartups;

              return FadeTransition(
                opacity: AlwaysStoppedAnimation(1.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header with profile and notifications
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Profile section (right)
                            Row(
                              children: [
                                Container(
                                  width: 44.w,
                                  height: 44.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        colors.primary,
                                        const Color(0xFF0074da),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'أحمد محمد',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'مؤسس',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Notifications button (left)
                            IconButton(
                              icon: Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              onPressed: () {},
                              splashRadius: 24.r,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          const FilterBottomSheet(),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Icon(
                                    Icons.tune,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: SizedBox(
                                height: 50.h,
                                child: SearchBarWidget(
                                  controller: _searchController,
                                  onChanged: (value) => getIt<ExploreCubit>()
                                      .searchStartups(value),
                                  onClear: () =>
                                      getIt<ExploreCubit>().clearSearch(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: categories.map((category) {
                            final selected =
                                state.selectedCategory?.isEmpty != true &&
                                state.selectedCategory == category.id;
                            return CategoryChipWidget(
                              label: category.displayName,
                              isSelected: selected,
                              onTap: () => getIt<ExploreCubit>()
                                  .filterByCategory(category.id),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                        child: Text(
                          localizations.featuredCompanies,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 240.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          itemCount: state.featuredStartups.length,
                          itemBuilder: (context, index) {
                            final item = state.featuredStartups[index];
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
                                    offset: Offset((1 - value) * 50, 0),
                                    child: child,
                                  ),
                                );
                              },
                              child: StartupCardWidget(
                                startup: item,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CompanyDetailsScreen(
                                            startupId: item.id,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                        child: Text(
                          localizations.latest,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: startups.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 10.h,
                                childAspectRatio: 0.7,
                              ),
                          itemBuilder: (context, index) {
                            final item = startups[index];
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: Duration(
                                milliseconds: 400 + (index * 80),
                              ),
                              curve: Curves.easeInOut,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.scale(
                                    scale: 0.8 + (value * 0.2),
                                    child: Transform.translate(
                                      offset: Offset(0, (1 - value) * 30),
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: StartupGridItemWidget(
                                startup: item,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CompanyDetailsScreen(
                                            startupId: item.id,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
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

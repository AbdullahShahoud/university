import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/button.dart';
import '../../../startup_profile/logic/cubit/startup_cubit.dart';
import '../widgets/startup_profile_widgets.dart';

class StartupProfileScreen extends StatelessWidget {
  final String startupId;

  const StartupProfileScreen({super.key, required this.startupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StartupCubit>()..loadStartupDetails(startupId),
      child: const StartupProfileView(),
    );
  }
}

class StartupProfileView extends StatefulWidget {
  const StartupProfileView({super.key});

  @override
  State<StartupProfileView> createState() => _StartupProfileViewState();
}

class _StartupProfileViewState extends State<StartupProfileView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, initialIndex: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<StartupCubit, StartupState>(
      builder: (context, state) {
        if (state.isLoading && state.startup == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...')),
            body: Background(
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (state.errorMessage != null && state.startup == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Background(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: AppColors.error),
                    ),
                    SizedBox(height: 16.h),
                    AppButton(
                      onPressed: () => context.read<StartupCubit>().retry(),
                      text: localizations.retry,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final startup = state.startup!;

        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 230.h,
                  floating: false,
                  pinned: true,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            // Share startup info
                            final shareText =
                                'Check out ${startup.name}\n\n${startup.about}\n\nVisit: ${startup.website}';
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) => AlertDialog(
                                title: Text('Share ${startup.name}'),
                                content: SelectableText(shareText),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.share, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Center(
                        child: SizedBox(
                          width: 120.w,
                          child: AppButton(
                            onPressed: () =>
                                context.read<StartupCubit>().toggleFollow(),
                            text: startup.isFollowing
                                ? AppLocalizations.of(context)!.following
                                : AppLocalizations.of(context)!.follow,
                            backgroundColor: startup.isFollowing
                                ? AppColors.textSecondary
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: StartupCoverHeader(
                      coverUrl: startup.coverUrl,
                      logoUrl: startup.logoUrl,
                      name: startup.name,
                      isFollowing: startup.isFollowing,
                      onFollowPressed: () =>
                          context.read<StartupCubit>().toggleFollow(),
                      onBackPressed: () => Navigator.pop(context),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50.h),
                    child: Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabs: [
                          Tab(text: localizations.about),
                          Tab(text: 'المميزات'),
                          Tab(text: localizations.news),
                          Tab(text: 'التواصل'),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                if (state.errorMessage != null)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    color: AppColors.errorBackground,
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20.w,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            state.errorMessage!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.read<StartupCubit>().retry(),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      AboutTabWidget(startup: startup),
                      FeaturesTabWidget(features: startup.features),
                      NewsTabWidget(news: startup.news),
                      ContactTabWidget(contacts: startup.contacts),
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
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/background.dart';
import '../../data/models/startup_details.dart';
import '../../logic/cubit/startup_cubit.dart';

ImageProvider _imageProvider(String url) {
  return url.startsWith('http')
      ? NetworkImage(url)
      : AssetImage(url) as ImageProvider;
}

class CompanyDetailsScreen extends StatelessWidget {
  final String startupId;

  const CompanyDetailsScreen({super.key, required this.startupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<StartupCubit>();
        Future.microtask(() => cubit.loadStartupDetails(startupId));
        return cubit;
      },
      child: const _CompanyDetailsView(),
    );
  }
}

class _CompanyDetailsView extends StatefulWidget {
  const _CompanyDetailsView();

  @override
  State<_CompanyDetailsView> createState() => _CompanyDetailsViewState();
}

class _CompanyDetailsViewState extends State<_CompanyDetailsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, initialIndex: 0, vsync: this);
    _scrollController = ScrollController()
      ..addListener(() {
        final scrolled = _scrollController.offset > 160;
        if (scrolled != _isScrolled) {
          setState(() {
            _isScrolled = scrolled;
          });
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildCoverImage(String coverUrl) {
    return Image(
      image: _imageProvider(coverUrl),
      width: double.infinity,
      height: 280.h,
      fit: BoxFit.cover,
    );
  }

  Widget _buildLogoImage(String logoUrl) {
    return Image(image: _imageProvider(logoUrl), fit: BoxFit.fill);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<StartupCubit, StartupState>(
      builder: (context, state) {
        if (state.isLoading && state.startup == null) {
          return Scaffold(
            body: Background(
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (state.errorMessage != null && state.startup == null) {
          return Scaffold(
            body: Background(
              child: Center(child: Text(state.errorMessage ?? 'Error')),
            ),
          );
        }

        if (state.startup == null) {
          return Scaffold(
            body: Background(
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final startup = state.startup!;

        return Scaffold(
          backgroundColor: colors.background,
          body: Background(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: 180.h),
              child: Column(
                children: [
                  Stack(
                    children: [
                      _buildCoverImage(startup.coverUrl),
                      Container(
                        width: double.infinity,
                        height: 280.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: Offset(0, -60.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          Container(
                            width: 128.w,
                            height: 128.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(36.r),
                              border: Border.all(color: Colors.white, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(36.r),
                              child: Container(
                                color: Colors.white,
                                child: _buildLogoImage(startup.logoUrl),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            startup.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.memory,
                                  size: 16.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  startup.category,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        _StatCard(
                          icon: Icons.groups,
                          value: '12K',
                          label: 'متابع',
                          colors: colors,
                        ),
                        SizedBox(width: 12.w),
                        _StatCard(
                          icon: Icons.newspaper,
                          value: startup.news.length.toString(),
                          label: 'خبر',
                          colors: colors,
                        ),
                        SizedBox(width: 12.w),
                        _StatCard(
                          icon: Icons.star_rounded,
                          value: startup.rating.toStringAsFixed(1),
                          label: 'تقييم',
                          colors: colors,
                          isRating: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 26.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: colors.border.withOpacity(0.35),
                          width: 1,
                        ),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: colors.primary,
                          width: 3.w,
                        ),
                        insets: EdgeInsets.symmetric(horizontal: 8.w),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      labelColor: colors.primary,
                      unselectedLabelColor: colors.textSecondary,
                      tabs: [
                        Tab(text: 'حول'),
                        Tab(text: 'المميزات'),
                        Tab(text: 'الأخبار'),
                        Tab(text: 'اتصل بنا'),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  LimitedBox(
                    maxHeight: 1400.h,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _AboutTabContent(startup: startup),
                        _FeaturesTabContent(startup: startup),
                        _NewsTabContent(startup: startup),
                        _ContactTabContent(startup: startup),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// About Tab
class _AboutTabContent extends StatelessWidget {
  final StartupDetails startup;

  const _AboutTabContent({required this.startup});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نظرة عامة',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  width: 85.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(1.5.r),
                  ),
                ),
                SizedBox(height: 18.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: colors.border.withOpacity(0.16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  startup.name,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  startup.description,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    height: 1.8,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Text(
                              startup.category,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        startup.about,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.8,
                          color: colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoChip(
                              label: 'التأسيس',
                              value: startup.founded,
                              colors: colors,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _InfoChip(
                              label: 'الموقع',
                              value: startup.location,
                              colors: colors,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                Text(
                  'رؤيتنا ومهمتنا',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _VisionMissionCard(
                        icon: Icons.visibility,
                        title: 'الرؤية',
                        description:
                            'نحن نسعى لتحقيق رؤية مستقبلية مبتكرة',
                        colors: colors,
                        isPrimary: true,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _VisionMissionCard(
                        icon: Icons.rocket_launch,
                        title: 'المهمة',
                        description:
                            'تمكين المؤسسات من خلال التكنولوجيا',
                        colors: colors,
                        isPrimary: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image(
                    image: _imageProvider(
                      startup.coverUrl,
                    ),
                    width: double.infinity,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 24.h),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          backgroundColor: const Color(0xFF25D366),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(
                          Icons.chat,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                        label: Text(
                          'واتساب',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          backgroundColor: colors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(
                          Icons.call,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                        label: Text(
                          'اتصال سريع',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesTabContent extends StatelessWidget {
  final StartupDetails startup;

  const _FeaturesTabContent({required this.startup});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المميزات',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: colors.border.withOpacity(0.16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46.w,
                        height: 46.w,
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.auto_awesome,
                          color: colors.primary,
                          size: 26.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'حلول تقنية متقدمة',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'تساعد الشركة على تحويل الأفكار إلى تجارب رقمية من خلال منصة متكاملة ومؤتمتة.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                height: 1.8,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: startup.features.map((feature) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color: colors.border.withOpacity(0.18),
                          ),
                        ),
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            Text(
              'المميزات الرئيسية',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: startup.features.take(4).map((feature) {
                return Container(
                  width: (MediaQuery.of(context).size.width - 64.w) / 2,
                  constraints: BoxConstraints(minWidth: 140.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: colors.border.withOpacity(0.16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsTabContent extends StatelessWidget {
  final StartupDetails startup;

  const _NewsTabContent({required this.startup});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feed items
          Column(
            children: startup.news.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: colors.border.withOpacity(0.08)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: colors.surface,
                                image: DecorationImage(
                                  image: _imageProvider(startup.logoUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        startup.name,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Icon(
                                        Icons.verified,
                                        size: 16.sp,
                                        color: colors.primary,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    item.publishedAt,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primary,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'متابعة',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // AI Summary
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border(
                              left: BorderSide(
                                color: colors.primary,
                                width: 4.w,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: colors.primary,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'ملخص ذكاء اصطناعي لأحدث الأخبار',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: colors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                item.description,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  height: 1.7,
                                  color: colors.textSecondary,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Engagement bar
                      Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  _IconTextButton(
                                    icon: Icons.favorite_border,
                                    label: '1.2k',
                                    colors: colors,
                                  ),
                                  SizedBox(width: 12.w),
                                  _IconTextButton(
                                    icon: Icons.comment,
                                    label: '245',
                                    colors: colors,
                                  ),
                                  SizedBox(width: 12.w),
                                  _IconTextButton(
                                    icon: Icons.share,
                                    label: '89',
                                    colors: colors,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.bookmark_border,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

// class _NewsFilterChip extends StatelessWidget {
//   final String label;
//   final bool active;
//   final dynamic colors;

//   const _NewsFilterChip({
//     required this.label,
//     this.active = false,
//     required this.colors,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
//       decoration: BoxDecoration(
//         color: active ? colors.primary : colors.surface,
//         borderRadius: BorderRadius.circular(999.r),
//         border: Border.all(
//           color: active ? colors.primary : colors.border.withOpacity(0.12),
//         ),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 13.sp,
//           fontWeight: FontWeight.w700,
//           color: active ? Colors.white : colors.textPrimary,
//         ),
//       ),
//     );
//   }
// }

class _IconTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic colors;

  const _IconTextButton({
    required this.icon,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: colors.textSecondary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ContactTabContent extends StatelessWidget {
  final StartupDetails startup;

  const _ContactTabContent({required this.startup});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اتصل بنا',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Column(
            // spacing: 12.w,
            // runSpacing: 12.h,
            children: [
              _ContactActionCard(
                icon: Icons.chat,
                title: 'واتساب',
                subtitle: startup.phone,
                backgroundColor: colors.success.withOpacity(0.12),
                iconColor: colors.success,
              ),
              SizedBox(height: 4.h),

              _ContactActionCard(
                icon: Icons.email,
                title: 'البريد الإلكتروني',
                subtitle: startup.email,
                backgroundColor: colors.primary.withOpacity(0.12),
                iconColor: colors.primary,
              ),
              SizedBox(height: 4.h),

              _ContactActionCard(
                icon: Icons.phone,
                title: 'الهاتف',
                subtitle: startup.phone,
                backgroundColor: colors.info.withOpacity(0.12),
                iconColor: colors.info,
              ),
            ],
          ),
          SizedBox(height: 22.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: colors.border.withOpacity(0.16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أرسل لنا رسالة',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                _ContactInputField(hint: 'الاسم الكامل', colors: colors),
                SizedBox(height: 12.h),
                _ContactInputField(hint: 'البريد الإلكتروني', colors: colors),
                SizedBox(height: 12.h),
                _ContactInputField(hint: 'موضوع الرسالة', colors: colors),
                SizedBox(height: 12.h),
                _ContactInputField(
                  hint: 'كيف يمكننا مساعدتك؟',
                  maxLines: 4,
                  colors: colors,
                ),
                SizedBox(height: 18.h),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'إرسال الرسالة',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.send, size: 18.sp, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 22.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: colors.border.withOpacity(0.16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومات المكتب',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 14.h),
                _ContactLine(
                  icon: Icons.location_on,
                  label: 'الموقع',
                  value: startup.location,
                ),
                SizedBox(height: 12.h),
                _ContactLine(
                  icon: Icons.calendar_today,
                  label: 'تأسست في',
                  value: startup.founded,
                ),
                SizedBox(height: 14.h),
                Text(
                  'ساعات العمل',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 10.h),
                Column(
                  children: [
                    _WorkingHoursRow(
                      label: 'الأحد - الخميس',
                      value: '09:00 - 18:00',
                      status: colors.textPrimary,
                      borderColor: colors.border.withOpacity(0.2),
                    ),
                    SizedBox(height: 10.h),
                    _WorkingHoursRow(
                      label: 'الجمعة',
                      value: 'مغلق',
                      status: colors.error,
                      borderColor: colors.border.withOpacity(0.2),
                    ),
                    SizedBox(height: 10.h),
                    _WorkingHoursRow(
                      label: 'السبت',
                      value: '10:00 - 14:00',
                      status: colors.warning,
                      borderColor: Colors.transparent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, color: colors.primary, size: 18.sp),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final dynamic colors;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: colors.border.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color iconColor;

  const _ContactActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 80.w,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors.border.withOpacity(0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: iconColor, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_back_ios_new, color: colors.border, size: 18.sp),
        ],
      ),
    );
  }
}

class _ContactInputField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final dynamic colors;

  const _ContactInputField({
    required this.hint,
    required this.colors,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: colors.border.withOpacity(0.18)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: colors.border.withOpacity(0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: colors.primary),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
    );
  }
}

class _WorkingHoursRow extends StatelessWidget {
  final String label;
  final String value;
  final Color status;
  final Color borderColor;

  const _WorkingHoursRow({
    required this.label,
    required this.value,
    required this.status,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: colors.textPrimary),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: status,
            ),
          ),
        ],
      ),
    );
  }
}

class _VisionMissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final dynamic colors;
  final bool isPrimary;

  const _VisionMissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.colors,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors.border.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: isPrimary
                  ? LinearGradient(
                      colors: [colors.primary, colors.primary.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Color(0xFF1F2937), Color(0xFF111827)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              boxShadow: [
                BoxShadow(
                  color: isPrimary
                      ? colors.primary.withOpacity(0.3)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Stats Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final dynamic colors;
  final bool isRating;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.colors,
    this.isRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRating
                    ? Color(0xFFFBF3E6).withOpacity(0.7)
                    : Color(0xFFEFF6FF).withOpacity(0.7),
              ),
              child: Icon(
                icon,
                size: 16.w,
                color: isRating ? Color(0xFFEAB308) : colors.primary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

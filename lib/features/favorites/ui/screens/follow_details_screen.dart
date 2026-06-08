import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/background.dart';
import '../../data/models/favorite_startup.dart';
import '../../logic/cubit/favorites_cubit.dart';

ImageProvider _imgProvider(String url) {
  return url.startsWith('http')
      ? NetworkImage(url)
      : AssetImage(url) as ImageProvider;
}

class FollowDetailsScreen extends StatefulWidget {
  final FavoriteStartup startup;
  const FollowDetailsScreen({super.key, required this.startup});

  @override
  State<FollowDetailsScreen> createState() => _FollowDetailsScreenState();
}

class _FollowDetailsScreenState extends State<FollowDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final startup = widget.startup;

    final tabBar = TabBar(
      controller: _tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.center,
      labelPadding: EdgeInsets.symmetric(horizontal: 12.w),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: colors.primary, width: 3.w),
        insets: EdgeInsets.symmetric(horizontal: 4.w),
      ),
      labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      labelColor: colors.primary,
      unselectedLabelColor: colors.textSecondary,
      tabs: const [
        Tab(text: 'نظرة عامة'),
        Tab(text: 'الاستثمار'),
        Tab(text: 'الخدمات'),
        Tab(text: 'اتصل بنا'),
      ],
    );

    return Scaffold(
      backgroundColor: colors.background,
      body: Background(
        child: CustomScrollView(
          slivers: [
            // ── Collapsing hero app bar ──────────────────────────────────
            SliverAppBar(
              expandedHeight: 220.h,
              automaticallyImplyLeading: false,
              floating: false,
              pinned: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, size: 18.sp),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.share_outlined, size: 20.sp),
                  onPressed: () {},
                ),
                SizedBox(width: 4.w),
              ],
              title: Text(
                startup.name,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    _CoverImage(logoUrl: startup.logoUrl),
                    // Gradient
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.65),
                          ],
                          stops: const [0.4, 1.0],
                        ),
                      ),
                    ),
                    // Company info
                    Positioned(
                      bottom: 16.h,
                      left: 16.w,
                      right: 16.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 68.w,
                            height: 68.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: Colors.white, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(11.r),
                              child: Image(
                                image: _imgProvider(startup.logoUrl),
                                fit: BoxFit.cover,
                                errorBuilder: (context, e, s) => Center(
                                  child: Icon(
                                    Icons.business,
                                    size: 30.sp,
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        startup.name,
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.verified,
                                      color: const Color(0xFF60A5FA),
                                      size: 17.sp,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Container(
                                      width: 7.w,
                                      height: 7.w,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      '12.5k متابع',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.white.withValues(
                                          alpha: 0.85,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 7.w,
                                        vertical: 3.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                      child: Text(
                                        startup.category,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
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
                    ),
                  ],
                ),
              ),
            ),

            // ── Action buttons ───────────────────────────────────────────
            SliverToBoxAdapter(child: _ActionButtons(startup: startup)),

            // ── Sticky tab bar ───────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              leading: SizedBox.shrink(),
              toolbarHeight: 56,
              backgroundColor: colors.background,
              elevation: 0,
              flexibleSpace: tabBar,
            ),

            // ── Tab content fills remaining space ────────────────────────
            SliverFillRemaining(
              hasScrollBody: true,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _OverviewTab(startup: startup),
                  _InvestmentTab(startup: startup),
                  _ServicesTab(startup: startup),
                  _ContactTab(startup: startup),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Cover Image ─────────────────────────────────────────────────────────────

class _CoverImage extends StatelessWidget {
  final String logoUrl;
  const _CoverImage({required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(134, 0, 30, 45),
            colors.primary,
            const Color.fromARGB(31, 0, 116, 218),
          ],
        ),
      ),
      child: Opacity(
        opacity: 0.12,
        child: Image(
          image: _imgProvider(logoUrl),
          fit: BoxFit.cover,
          errorBuilder: (context, e, s) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

// ─── Action Buttons ───────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final FavoriteStartup startup;
  const _ActionButtons({required this.startup});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      color: colors.background,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                getIt<FavoritesCubit>().removeFromFavorites(startup.id);
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colors.border.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: colors.primary,
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'متابَع',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_outlined, color: Colors.white, size: 18.sp),
                    SizedBox(width: 6.w),
                    Text(
                      'رسالة',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab 1: نظرة عامة ────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  final FavoriteStartup startup;
  const _OverviewTab({required this.startup});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final milestones = [
      _Milestone(
        date: 'مارس 2024',
        title: 'جولة تمويل Series B',
        description:
            'أغلقنا جولة تمويل بقيمة \$45 مليون بقيادة Global Tech Partners للتوسع في الأسواق الإقليمية.',
        tags: ['#استثمار', '#توسع'],
        color: colors.primary,
        ringColor: const Color(0xFFD5E3FF),
      ),
      _Milestone(
        date: 'يناير 2023',
        title: 'جائزة الابتكار لعام 2023',
        description:
            'حصلنا على جائزة الابتكار الرائد من قمة التقنية العالمية لتميزنا في مجال الذكاء الاصطناعي.',
        tags: ['#جائزة'],
        color: const Color(0xFFAF2335),
        ringColor: const Color(0xFFFFDAD9),
      ),
      _Milestone(
        date: 'يونيو 2021',
        title: 'تأسيس الشركة',
        description:
            'انطلاق الشركة بهدف تحويل المنظومة الرقمية من خلال حلول تقنية متكاملة.',
        tags: ['#تأسيس'],
        color: const Color(0xFF717785),
        ringColor: const Color(0xFFC0C6D5),
      ),
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      children: [
        // Stats row
        Row(
          children: [
            _StatBadge(
              icon: Icons.groups_outlined,
              value: '12.5k',
              label: 'متابع',
              colors: colors,
            ),
            SizedBox(width: 10.w),
            _StatBadge(
              icon: Icons.star_rounded,
              value: startup.rating.toStringAsFixed(1),
              label: 'تقييم',
              colors: colors,
              valueColor: const Color(0xFFEAB308),
            ),
            SizedBox(width: 10.w),
            _StatBadge(
              icon: Icons.newspaper_outlined,
              value: '24',
              label: 'خبر',
              colors: colors,
            ),
          ],
        ),
        SizedBox(height: 24.h),

        // Section title
        _SectionTitle(title: 'المسيرة والإنجازات', colors: colors),
        SizedBox(height: 16.h),

        // Timeline
        Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              for (int i = 0; i < milestones.length; i++)
                _TimelineItem(
                  milestone: milestones[i],
                  isLast: i == milestones.length - 1,
                  colors: colors,
                ),
            ],
          ),
        ),

        SizedBox(height: 24.h),
        _SectionTitle(title: 'رؤيتنا ومهمتنا', colors: colors),
        SizedBox(height: 14.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _VisionCard(
                icon: Icons.visibility_outlined,
                title: 'الرؤية',
                description:
                    'نسعى لأن نكون الشريك التقني الأول في المنطقة لتحقيق التحول الرقمي الشامل.',
                colors: colors,
                isPrimary: true,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _VisionCard(
                icon: Icons.rocket_launch_outlined,
                title: 'المهمة',
                description:
                    'تمكين المؤسسات والأفراد من خلال تقنيات مبتكرة وحلول ذكية مستدامة.',
                colors: colors,
                isPrimary: false,
              ),
            ),
          ],
        ),

        SizedBox(height: 32.h),
      ],
    );
  }
}

class _Milestone {
  final String date;
  final String title;
  final String description;
  final List<String> tags;
  final Color color;
  final Color ringColor;

  _Milestone({
    required this.date,
    required this.title,
    required this.description,
    required this.tags,
    required this.color,
    required this.ringColor,
  });
}

class _TimelineItem extends StatelessWidget {
  final _Milestone milestone;
  final bool isLast;
  final dynamic colors;

  const _TimelineItem({
    required this.milestone,
    required this.isLast,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 24.w,
            child: Column(
              children: [
                Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: milestone.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: milestone.ringColor, width: 3),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2.w,
                      color: colors.border.withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 14.w),
          // Card
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: colors.border.withOpacity(0.18)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      milestone.date,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: milestone.color,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      milestone.title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      milestone.description,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.6,
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 6.w,
                      children: milestone.tags.map((tag) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDEF0FF),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final dynamic colors;
  final bool isPrimary;

  const _VisionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.colors,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.border.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isPrimary
                    ? [colors.primary, colors.primary.withOpacity(0.7)]
                    : [const Color(0xFF1F2937), const Color(0xFF111827)],
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 20.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.6,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab 2: الاستثمار ─────────────────────────────────────────────────────────

class _InvestmentTab extends StatelessWidget {
  final FavoriteStartup startup;
  const _InvestmentTab({required this.startup});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fundingRounds = [
      {'round': 'Series A', 'date': 'يونيو 2024', 'amount': '\$15.0M'},
      {'round': 'Pre-Series A', 'date': 'مارس 2022', 'amount': '\$8.2M'},
      {'round': 'Seed', 'date': 'يناير 2020', 'amount': '\$2.5M'},
    ];
    final chartHeights = [0.30, 0.45, 0.65, 0.85, 1.0];
    final chartYears = ['2020', '2021', '2022', '2023', '2024'];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      children: [
        // Investment Hero Card
        Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colors.border.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'جولة نمو الفئة أ (Series A)',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'نشط الآن',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التقييم الحالي',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '\$45.0M',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الحصة المتاحة',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '12.5%',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'شراء أسهم الآن',
                      style: TextStyle(
                        fontSize: 14.sp,
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
        SizedBox(height: 20.h),

        // Chart
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colors.border.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تطور قيمة السهم',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    '+42% سنوياً',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 125.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < chartHeights.length; i++) ...[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300 + i * 80),
                              height: 100.h * chartHeights[i],
                              decoration: BoxDecoration(
                                color: i == chartHeights.length - 1
                                    ? colors.primary
                                    : colors.primary.withOpacity(
                                        0.2 + chartHeights[i] * 0.6,
                                      ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.r),
                                  topRight: Radius.circular(4.r),
                                ),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              chartYears[i],
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: i == chartHeights.length - 1
                                    ? colors.primary
                                    : colors.textSecondary,
                                fontWeight: i == chartHeights.length - 1
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (i < chartHeights.length - 1) SizedBox(width: 8.w),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // Funding Rounds Table
        _SectionTitle(title: 'تاريخ جولات التمويل', colors: colors),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colors.border.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'الجولة',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'التاريخ',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      'المبلغ',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Rows
              for (int i = 0; i < fundingRounds.length; i++)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: i.isOdd
                        ? colors.surface.withOpacity(0.5)
                        : Colors.white,
                    borderRadius: i == fundingRounds.length - 1
                        ? BorderRadius.only(
                            bottomLeft: Radius.circular(12.r),
                            bottomRight: Radius.circular(12.r),
                          )
                        : null,
                    border: Border(
                      top: BorderSide(color: colors.border.withOpacity(0.15)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          fundingRounds[i]['round']!,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          fundingRounds[i]['date']!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            fundingRounds[i]['amount']!,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.primary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.check_circle,
                            color: const Color(0xFF10B981),
                            size: 16.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
}

// ─── Tab 3: الخدمات ───────────────────────────────────────────────────────────

class _ServicesTab extends StatelessWidget {
  final FavoriteStartup startup;
  const _ServicesTab({required this.startup});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final services = [
      _Service(
        icon: Icons.auto_awesome,
        title: 'حلول الذكاء الاصطناعي',
        description:
            'منصات ذكاء اصطناعي متكاملة تُحسّن العمليات وتُقلّل التكاليف التشغيلية بنسبة تصل إلى 60%.',
        tags: ['AI', 'Automation'],
      ),
      _Service(
        icon: Icons.cloud_outlined,
        title: 'البنية السحابية',
        description:
            'تصميم وتنفيذ بنى تحتية سحابية قابلة للتوسع على AWS و Azure والمنصات المحلية.',
        tags: ['Cloud', 'DevOps'],
      ),
      _Service(
        icon: Icons.security_outlined,
        title: 'الأمن السيبراني',
        description:
            'حلول أمان شاملة تشمل الحماية من التهديدات والامتثال للمعايير الدولية.',
        tags: ['Security', 'Compliance'],
      ),
      _Service(
        icon: Icons.analytics_outlined,
        title: 'تحليل البيانات',
        description:
            'تحويل البيانات الخام إلى رؤى استراتيجية قابلة للتنفيذ عبر لوحات تحكم تفاعلية.',
        tags: ['Analytics', 'BI'],
      ),
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      children: [
        // Feature stats
        Row(
          children: [
            _FeatureStat(value: '4+', label: 'خدمات', colors: colors),
            SizedBox(width: 10.w),
            _FeatureStat(value: '200+', label: 'عميل', colors: colors),
            SizedBox(width: 10.w),
            _FeatureStat(value: '98%', label: 'رضا العملاء', colors: colors),
          ],
        ),
        SizedBox(height: 24.h),
        _SectionTitle(title: 'خدماتنا الرئيسية', colors: colors),
        SizedBox(height: 14.h),
        for (final service in services) ...[
          _ServiceCard(service: service, colors: colors),
          SizedBox(height: 12.h),
        ],
        SizedBox(height: 24.h),
        _SectionTitle(title: 'التقنيات المستخدمة', colors: colors),
        SizedBox(height: 14.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children:
              [
                    'Flutter',
                    'React',
                    'Node.js',
                    'Python',
                    'TensorFlow',
                    'AWS',
                    'Docker',
                    'Kubernetes',
                  ]
                  .map(
                    (tech) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: colors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        tech,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
}

class _Service {
  final IconData icon;
  final String title;
  final String description;
  final List<String> tags;

  _Service({
    required this.icon,
    required this.title,
    required this.description,
    required this.tags,
  });
}

class _ServiceCard extends StatelessWidget {
  final _Service service;
  final dynamic colors;

  const _ServiceCard({required this.service, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.border.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(service.icon, color: colors.primary, size: 24.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  service.description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.6,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 6.w,
                  children: service.tags
                      .map(
                        (tag) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDEF0FF),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureStat extends StatelessWidget {
  final String value;
  final String label;
  final dynamic colors;

  const _FeatureStat({
    required this.value,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colors.border.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tab 4: اتصل بنا ──────────────────────────────────────────────────────────

class _ContactTab extends StatelessWidget {
  final FavoriteStartup startup;
  const _ContactTab({required this.startup});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      children: [
        // Quick action grid
        _SectionTitle(title: 'تواصل سريع', colors: colors),
        SizedBox(height: 14.h),
        Row(
          children: [
            _QuickAction(
              icon: Icons.chat_bubble_outline,
              label: 'واتساب',
              bgColor: const Color(0xFFDCFCE7),
              iconColor: const Color(0xFF16A34A),
              onTap: () {},
            ),
            SizedBox(width: 10.w),
            _QuickAction(
              icon: Icons.call_outlined,
              label: 'اتصال',
              bgColor: const Color(0xFFDEF0FF),
              iconColor: colors.primary,
              onTap: () {},
            ),
            SizedBox(width: 10.w),
            _QuickAction(
              icon: Icons.language_outlined,
              label: 'الموقع',
              bgColor: colors.surface,
              iconColor: colors.textPrimary,
              onTap: () {},
            ),
          ],
        ),
        SizedBox(height: 24.h),

        // Contact form
        Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colors.border.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
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
              _FormField(hint: 'الاسم الكامل', colors: colors),
              SizedBox(height: 12.h),
              _FormField(hint: 'البريد الإلكتروني', colors: colors),
              SizedBox(height: 12.h),
              _FormField(
                hint: 'كيف يمكننا مساعدتك؟',
                maxLines: 4,
                colors: colors,
              ),
              SizedBox(height: 18.h),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'إرسال الرسالة',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Office info
        Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colors.border.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.schedule, color: colors.textPrimary, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'ساعات العمل',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              _HoursRow(
                label: 'الأحد - الخميس',
                value: '09:00 ص - 06:00 م',
                valueColor: colors.textPrimary,
                showDivider: true,
                colors: colors,
              ),
              _HoursRow(
                label: 'السبت',
                value: '10:00 ص - 04:00 م',
                valueColor: colors.warning,
                showDivider: true,
                colors: colors,
              ),
              _HoursRow(
                label: 'الجمعة',
                value: 'مغلق',
                valueColor: colors.error,
                showDivider: false,
                colors: colors,
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // Locations
        _SectionTitle(title: 'مواقعنا', colors: colors),
        SizedBox(height: 14.h),
        _LocationCard(
          city: 'فرع الرياض',
          address: 'مركز الملك عبدالله المالي، الرياض، السعودية',
          colors: colors,
        ),
        SizedBox(height: 10.h),
        _LocationCard(
          city: 'فرع دبي',
          address: 'مركز دبي المالي العالمي، دبي، الإمارات',
          colors: colors,
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF001e2d),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final dynamic colors;

  const _FormField({
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
        hintStyle: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colors.border.withOpacity(0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colors.border.withOpacity(0.25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      ),
    );
  }
}

class _HoursRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool showDivider;
  final dynamic colors;

  const _HoursRow({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.showDivider,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: colors.border.withOpacity(0.2)))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: colors.textPrimary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final String city;
  final String address;
  final dynamic colors;

  const _LocationCard({
    required this.city,
    required this.address,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.border.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: colors.primary, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'الخريطة',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared Helpers ───────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final dynamic colors;

  const _SectionTitle({required this.title, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 140.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final dynamic colors;
  final Color? valueColor;

  const _StatBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.colors,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colors.border.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: (valueColor ?? colors.primary).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 16.sp,
                color: valueColor ?? colors.primary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: valueColor ?? const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(fontSize: 10.sp, color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

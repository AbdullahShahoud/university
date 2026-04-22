import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/di/service_locator.dart';
import '../../logic/cubit/startup_cubit.dart';

class CompanyDetailsScreen extends StatelessWidget {
  final String startupId;

  const CompanyDetailsScreen({super.key, required this.startupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StartupCubit>()..loadStartupDetails(startupId),
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
  late AnimationController _contentAnimationController;
  late Animation<double> _contentFadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Initialize content animation controller
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _contentAnimationController.forward();

    // Listen to tab changes to reset animation
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _contentAnimationController.reset();
        _contentAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<StartupCubit, StartupState>(
      builder: (context, state) {
        if (state.isLoading && state.startup == null) {
          return Scaffold(
            backgroundColor: colors.background,
            appBar: AppBar(backgroundColor: colors.background, elevation: 0),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage != null && state.startup == null) {
          return Scaffold(
            backgroundColor: colors.background,
            appBar: AppBar(backgroundColor: colors.background, elevation: 0),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48.w, color: colors.error),
                    SizedBox(height: 16.h),
                    Text(
                      state.errorMessage ?? 'An error occurred',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      onPressed: () => context.read<StartupCubit>().retry(),
                      icon: const Icon(Icons.refresh),
                      label: Text(localizations.retry),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final startup = state.startup!;

        return Scaffold(
          backgroundColor: colors.background,
          body: CustomScrollView(
            slivers: [
              // Header Section
              SliverAppBar(
                expandedHeight: 200.h,
                floating: false,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: colors.background,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: () {
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
                    icon: const Icon(Icons.share),
                    color: colors.textPrimary,
                  ),
                  SizedBox(width: 8.w),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Cover Image
                      Image.asset(
                        startup.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: colors.inputBackground,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                      // Dark gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Company Info Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.border, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadowLight.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            startup.logoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: colors.inputBackground,
                                  child: const Icon(Icons.business, size: 40),
                                ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Company Name and Rating
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              startup.name,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16.w,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${startup.rating.toStringAsFixed(1)} (${startup.reviewCount})',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: colors.textSecondary,
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
              ),
              // Follow Button - Full Width
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.read<StartupCubit>().toggleFollow(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: startup.isFollowing
                            ? colors.primary.withValues(alpha: 0.2)
                            : colors.primary,
                        foregroundColor: startup.isFollowing
                            ? colors.primary
                            : Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                      ),
                      child: Text(
                        startup.isFollowing
                            ? localizations.following
                            : localizations.follow,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Tabs Section
              SliverAppBar(
                pinned: true,
                expandedHeight: 0,
                backgroundColor: colors.background,
                elevation: 0,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.h),
                  child: Container(
                    color: colors.background,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: colors.primary,
                      indicatorWeight: 3,
                      labelColor: colors.primary,
                      unselectedLabelColor: colors.textSecondary,
                      labelStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [
                        Tab(text: localizations.about),
                        const Tab(text: 'المميزات'),
                        Tab(text: localizations.news),
                        const Tab(text: 'التواصل'),
                      ],
                    ),
                  ),
                ),
              ),
              // Tab Content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // About Tab
                    FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: _AboutTabContent(startup: startup),
                    ),
                    // Features Tab
                    FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: _FeaturesTabContent(features: startup.features),
                    ),
                    // News Tab
                    FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: _NewsTabContent(news: startup.news),
                    ),
                    // Contact Tab
                    FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: _ContactTabContent(contacts: startup.contacts),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// About Tab Content
class _AboutTabContent extends StatelessWidget {
  final dynamic startup;

  const _AboutTabContent({required this.startup});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Description
          FadeTransition(
            opacity: AlwaysStoppedAnimation(1.0),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 400),
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
              child: Text(
                startup.about,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.6,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          // Company Info Grid animated
          _AnimatedCompanyInfoItem(
            label: 'الموقع الإلكتروني',
            value: startup.website,
            colors: colors,
            delay: 0,
          ),
          SizedBox(height: 12.h),
          _AnimatedCompanyInfoItem(
            label: 'الموقع',
            value: startup.location,
            colors: colors,
            delay: 1,
          ),
          SizedBox(height: 12.h),
          _AnimatedCompanyInfoItem(
            label: 'البريد الإلكتروني',
            value: startup.email,
            colors: colors,
            delay: 2,
          ),
          SizedBox(height: 12.h),
          _AnimatedCompanyInfoItem(
            label: 'الهاتف',
            value: startup.phone,
            colors: colors,
            delay: 3,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// Features Tab Content
class _FeaturesTabContent extends StatelessWidget {
  final List<String> features;

  const _FeaturesTabContent({required this.features});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (index * 100)),
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
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(8.r),
                color: colors.cardBackground,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: colors.success, size: 20.w),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      features[index],
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: colors.textPrimary,
                      ),
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

// News Tab Content
class _NewsTabContent extends StatelessWidget {
  final dynamic news;

  const _NewsTabContent({required this.news});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: news.length ?? 0,
      itemBuilder: (context, index) {
        final article = news[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (index * 100)),
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
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailsScreen(article: article),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colors.border),
                  borderRadius: BorderRadius.circular(8.r),
                  color: colors.cardBackground,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(7.r),
                        ),
                        child: Image.asset(
                          article.imageUrl,
                          height: 150.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: colors.inputBackground),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title ?? 'No Title',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            article.publishedAt ?? 'Unknown date',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colors.textSecondary,
                            ),
                          ),
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
}

// Contact Tab Content
class _ContactTabContent extends StatefulWidget {
  final dynamic contacts;

  const _ContactTabContent({required this.contacts});

  @override
  State<_ContactTabContent> createState() => _ContactTabContentState();
}

class _ContactTabContentState extends State<_ContactTabContent> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        spacing: 12.h,
        children: [
          // WhatsApp Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // WhatsApp action
              },
              icon: const Icon(Icons.chat),
              label: const Text('تواصل عبر واتساب مباشرة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          // Phone Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Phone action
              },
              icon: const Icon(Icons.phone),
              label: const Text('اتصال مباشرة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          // Website Button
          GestureDetector(
            onTap: () {
              // Open website
            },
            child: Text(
              'زيارة الموقع الإلكتروني',
              style: TextStyle(
                fontSize: 14.sp,
                color: colors.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Name Input
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'اسمك',
              hintStyle: TextStyle(color: colors.textSecondary),
              filled: true,
              fillColor: colors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 14.h,
              ),
            ),
            style: TextStyle(fontSize: 14.sp, color: colors.textPrimary),
          ),
          // Email Input
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'بريدك الإلكتروني',
              hintStyle: TextStyle(color: colors.textSecondary),
              filled: true,
              fillColor: colors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 14.h,
              ),
            ),
            style: TextStyle(fontSize: 14.sp, color: colors.textPrimary),
          ),
          // Message Input
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'رسالتك',
              hintStyle: TextStyle(color: colors.textSecondary),
              filled: true,
              fillColor: colors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 14.h,
              ),
            ),
            style: TextStyle(fontSize: 14.sp, color: colors.textPrimary),
          ),
          SizedBox(height: 12.h),
          // Send Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Send message action
              },
              icon: const Icon(Icons.mail),
              label: const Text('إرسال الرسالة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Animated Helper Widget for Company Info
class _AnimatedCompanyInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final dynamic colors;
  final int delay;

  const _AnimatedCompanyInfoItem({
    required this.label,
    required this.value,
    required this.colors,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (delay * 100)),
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
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.border)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// News Details Screen
class NewsDetailsScreen extends StatelessWidget {
  final dynamic article;

  const NewsDetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: colors.background,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20.w),
              ),
            ),
          ),
          // Cover Image
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              height: 280.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    article.imageUrl ?? 'assets/images/placeholder.png',
                  ),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
              child: article.imageUrl == null
                  ? Container(
                      color: colors.inputBackground,
                      child: const Icon(Icons.image_not_supported),
                    )
                  : null,
            ),
          ),
          // Title and Metadata
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? 'No Title',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16.w,
                        color: colors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'قراءة: 5 دقائق',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Icon(
                        Icons.visibility,
                        size: 16.w,
                        color: colors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${article.views ?? 0} مشاهدة',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Text(
                article.description ?? 'No description available',
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 1.6,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          // Extended Article Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Text(
                'تعتبر هذه الشركة الناشئة من بين أفضل الشركات المبتكرة في السوق الحالية. تقدم حلولاً متقدمة تساهم في تحسين جودة الخدمات والمنتجات للعملاء. برنامج التطوير الذي تتبعه الشركة يركز على الابتكار المستمر والتحسين الدوري للعمليات الداخلية.\n\nتتمتع الشركة بفريق عمل متخصص ومدرب على أعلى مستويات المهنية. يسعى الفريق بشكل مستمر لتحقيق أهدافه العامة والخاصة من خلال تطبيق أفضل الممارسات الدولية. كما أن الشركة حريصة على الحفاظ على العلاقات الطويلة الأجل مع عملائها.\n\nتركز الشركة على استخدام التقنيات الحديثة والمتطورة للوصول إلى أفضل النتائج. تتعاون مع شركاء استراتيجيين لضمان تقديم خدمات عالية الجودة. بالإضافة إلى ذلك، تستثمر الشركة بشكل كبير في البحث والتطوير للبقاء في الصدارة.',
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 1.8,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          // Engagement Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // Like Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.thumb_up,
                            color: colors.textSecondary,
                            size: 24.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '123',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Comments Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble,
                            color: colors.textSecondary,
                            size: 24.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '45',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Save Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark,
                            color: colors.textSecondary,
                            size: 24.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '67',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Comments Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Text(
                'التعليقات',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          // Comment Input
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: colors.inputBackground,
                      borderRadius: BorderRadius.circular(50.r),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/Depth 5, Frame 0.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'أضف تعليقا',
                        hintStyle: TextStyle(color: colors.textSecondary),
                        filled: true,
                        fillColor: colors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sample Comments
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _CommentWidget(
                    name: 'Fatima',
                    time: '2 ساعات',
                    comment:
                        'مقال رائع جداً ، أتمنى أن تحقق هذه الشركة نجاحاً كبيراً.',
                    colors: colors,
                  ),
                  SizedBox(height: 16.h),
                  _CommentWidget(
                    name: 'Ahmed',
                    time: '3 ساعات',
                    comment: 'أتفق مع هذا الرأي ، المنتجات تبدو مبشرة جداً.',
                    colors: colors,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
        ],
      ),
    );
  }
}

// Comment Widget
class _CommentWidget extends StatelessWidget {
  final String name;
  final String time;
  final String comment;
  final dynamic colors;

  const _CommentWidget({
    required this.name,
    required this.time,
    required this.comment,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: colors.inputBackground,
            borderRadius: BorderRadius.circular(50.r),
            image: const DecorationImage(
              image: AssetImage('assets/images/Depth 5, Frame 0.png'),
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
                    name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                comment,
                style: TextStyle(fontSize: 14.sp, color: colors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

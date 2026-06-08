import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../screens/company_details_screen.dart';

// ==================== Hero Header Section ====================
class HeroHeaderSection extends StatelessWidget {
  final CompanyDetailsData company;

  const HeroHeaderSection({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          height: 280.h,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(company.heroImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient Overlay
        Container(
          height: 280.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== Profile Info Section ====================
class ProfileInfoSection extends StatelessWidget {
  final CompanyDetailsData company;

  const ProfileInfoSection({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      margin: EdgeInsets.only(top: -60.h, bottom: 24.h),
      child: Column(
        children: [
          // Company Logo
          Container(
            width: 128.w,
            height: 128.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.r),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28.r),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(8.w),
                child: Image.network(company.logoImage, fit: BoxFit.contain),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Company Name
          Text(
            company.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(height: 8.h),
          // Category Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.memory, size: 16.sp, color: AppColors.primary),
                SizedBox(width: 6.w),
                Text(
                  company.category,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
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

// ==================== Stats Row Section ====================
class StatsRowSection extends StatelessWidget {
  final CompanyDetailsData company;

  const StatsRowSection({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _StatCard(
            icon: Icons.groups,
            value: _formatNumber(company.followers),
            label: 'متابع',
            isPrimary: true,
          ),
          SizedBox(width: 12.w),
          _StatCard(
            icon: Icons.newspaper,
            value: company.news.toString(),
            label: 'خبر',
            isPrimary: true,
          ),
          SizedBox(width: 12.w),
          _StatCard(
            icon: Icons.star_rounded,
            value: company.rating.toStringAsFixed(1),
            label: 'تقييم',
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isPrimary;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: isPrimary
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  size: 18.sp,
                  color: isPrimary ? AppColors.primary : Colors.amber,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== Tabs Section ====================
class TabsSection extends StatefulWidget {
  final CompanyDetailsData company;

  const TabsSection({super.key, required this.company});

  @override
  State<TabsSection> createState() => _TabsSectionState();
}

class _TabsSectionState extends State<TabsSection> {
  int _selectedTab = 0;
  final List<String> _tabs = ['حول', 'المميزات', 'الأخبار', 'اتصل بنا'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: List.generate(
                _tabs.length,
                (index) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedTab = index);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: _selectedTab == index ? Colors.white : null,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: _selectedTab == index
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        _tabs[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: _selectedTab == index
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: _selectedTab == index
                              ? AppColors.primary
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        // Tab Content
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _buildTabContent(_selectedTab),
        ),
      ],
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return _AboutTabContent(company: widget.company);
      case 1:
        return _FeaturesTabContent();
      case 2:
        return _NewsTabContent();
      case 3:
        return _ContactTabContent();
      default:
        return const SizedBox.shrink();
    }
  }
}

// ==================== Tab Contents ====================
class _AboutTabContent extends StatelessWidget {
  final CompanyDetailsData company;

  const _AboutTabContent({required this.company});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          company.description,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            height: 1.6,
          ),
        ),
        SizedBox(height: 24.h),
        // Vision & Mission Cards
        _MissionVisionCard(
          icon: Icons.visibility,
          title: 'الرؤية',
          description: company.vision,
          isPrimary: true,
        ),
        SizedBox(height: 16.h),
        _MissionVisionCard(
          icon: Icons.rocket_launch,
          title: 'المهمة',
          description: company.mission,
          isPrimary: false,
        ),
        SizedBox(height: 24.h),
        // Featured Image
        ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Image.network(
            company.featuredImage,
            width: double.infinity,
            height: 200.h,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class _MissionVisionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isPrimary;

  const _MissionVisionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: isPrimary
                  ? LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Colors.grey[900]!, Colors.grey[800]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              boxShadow: [
                BoxShadow(
                  color: (isPrimary ? AppColors.primary : Colors.grey[900]!)
                      .withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20.sp),
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
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
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

class _FeaturesTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'المميزات قادمة قريباً',
      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
    );
  }
}

class _NewsTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'الأخبار قادمة قريباً',
      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
    );
  }
}

class _ContactTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'معلومات الاتصال قادمة قريباً',
      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
    );
  }
}

// ==================== Bottom Action Buttons ====================
class BottomActionButtons extends StatelessWidget {
  final CompanyDetailsData company;

  const BottomActionButtons({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          Row(
            children: [
              // WhatsApp Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Open WhatsApp
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF25D366).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat, color: Colors.white, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'واتساب',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Call Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Make call
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.call, color: Colors.white, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'اتصال سريع',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
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
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

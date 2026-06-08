import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/button.dart';
import '../../data/models/startup_details.dart';

// Cover Header Widget
class StartupCoverHeader extends StatelessWidget {
  final String coverUrl;
  final String logoUrl;
  final String name;
  final bool isFollowing;
  final VoidCallback onFollowPressed;
  final VoidCallback onBackPressed;

  const StartupCoverHeader({
    super.key,
    required this.coverUrl,
    required this.logoUrl,
    required this.name,
    required this.isFollowing,
    required this.onFollowPressed,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Cover Image
        Image.asset(
          coverUrl,
          height: 200.h,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.placeholder,
            child: const Icon(Icons.error),
          ),
        ),
        // Back Button
        Positioned(
          top: 16.h,
          left: 16.w,
          child: GestureDetector(
            onTap: onBackPressed,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
        // Logo and Info
        Positioned(
          bottom: -30.h,
          left: 16.w,
          right: 16.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Logo
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.background, width: 4),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Image.asset(
                  logoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.placeholder,
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Company Info and Follow Button
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Builder(
                      builder: (context) {
                        final localizations = AppLocalizations.of(context)!;
                        return SizedBox(
                          width: 100.w,
                          height: 36.h,
                          child: AppButton(
                            onPressed: onFollowPressed,
                            text: isFollowing
                                ? localizations.following
                                : localizations.follow,
                            backgroundColor: isFollowing
                                ? AppColors.textSecondary
                                : AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// About Tab Widget
class AboutTabWidget extends StatelessWidget {
  final StartupDetails startup;

  const AboutTabWidget({super.key, required this.startup});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          // Rating and Reviews
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  icon: Icons.star,
                  value: startup.rating.toStringAsFixed(1),
                  label: 'Rating',
                ),
                _buildStatItem(
                  icon: Icons.rate_review,
                  value: startup.reviewCount.toString(),
                  label: 'Reviews',
                ),
                _buildStatItem(
                  icon: Icons.location_on,
                  value: startup.location.split(',').first,
                  label: 'Location',
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          // About Section
          Text(
            'About',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            startup.about,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          // Details
          _buildDetailItem('Founded', startup.founded),
          _buildDetailItem('Location', startup.location),
          _buildDetailItem('Email', startup.email),
          _buildDetailItem('Website', startup.website),
          _buildDetailItem('Phone', startup.phone),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24.w),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

// Features Tab Widget
class FeaturesTabWidget extends StatelessWidget {
  final List<String> features;

  const FeaturesTabWidget({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.inputBorder),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 24.w,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          features[index],
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// News Tab Widget
class NewsTabWidget extends StatelessWidget {
  final List<StartupNews> news;

  const NewsTabWidget({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Text(
            'No news available',
            style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: List.generate(
          news.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: NewsCard(news: news[index]),
          ),
        ),
      ),
    );
  }
}

// News Card Widget
class NewsCard extends StatelessWidget {
  final StartupNews news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.inputBackground,
      ),
      // overflow: Overflow.hidden,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (news.imageUrl.isNotEmpty)
            Image.asset(
              news.imageUrl,
              height: 150.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.placeholder,
                child: const Icon(Icons.error),
              ),
            ),
          // Content
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Text(
                  news.description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Text(
                  _formatDate(news.publishedAt),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String publishedAt) {
    try {
      final date = DateTime.parse(publishedAt);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes}m ago';
        }
        return '${difference.inHours}h ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return publishedAt;
    }
  }
}

// Contact Tab Widget
class ContactTabWidget extends StatelessWidget {
  final List<Contact> contacts;

  const ContactTabWidget({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Text(
            'No contacts available',
            style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: List.generate(
          contacts.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: ContactCard(contact: contacts[index]),
          ),
        ),
      ),
    );
  }
}

// Contact Card Widget
class ContactCard extends StatelessWidget {
  final Contact contact;

  const ContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.inputBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Center(
                  child: Text(
                    contact.name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      contact.title,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildContactItem(Icons.email, contact.email),
          SizedBox(height: 8.h),
          _buildContactItem(Icons.phone, contact.phone),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: AppColors.textSecondary),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

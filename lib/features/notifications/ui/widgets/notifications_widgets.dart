import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../data/models/notification.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Dismissible(
      key: Key(notification.id),
      onDismissed: (_) => onDismiss(),
      background: Container(
        color: colors.error,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.w),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: notification.isRead ? colors.borderLight : colors.primary,
            width: notification.isRead ? 1 : 2,
          ),
        ),
        child: Row(
          children: [
            if (notification.imageUrl != null)
              CircleAvatar(
                backgroundImage: NetworkImage(notification.imageUrl!),
                radius: 24.r,
              )
            else
              CircleAvatar(
                radius: 24.r,
                backgroundColor: colors.primary,
                child: Icon(
                  _getIconForType(notification.type),
                  color: Colors.white,
                ),
              ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _formatTime(notification.timestamp),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'follow':
        return Icons.person_add;
      case 'message':
        return Icons.mail;
      case 'update':
        return Icons.update;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class NewsCardWidget extends StatelessWidget {
  final dynamic article;

  const NewsCardWidget({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    article.category,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              article.description,
              style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.person, size: 12.sp, color: colors.textTertiary),
                SizedBox(width: 4.w),
                Text(
                  article.author,
                  style: TextStyle(fontSize: 10.sp, color: colors.textTertiary),
                ),
                SizedBox(width: 12.w),
                Icon(Icons.visibility, size: 12.sp, color: colors.textTertiary),
                SizedBox(width: 4.w),
                Text(
                  '${article.views} views',
                  style: TextStyle(fontSize: 10.sp, color: colors.textTertiary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationsShimmerLoading extends StatelessWidget {
  const NotificationsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Shimmer.fromColors(
      baseColor: Color.fromARGB(169, 210, 232, 255),
      highlightColor: Color.fromARGB(255, 210, 232, 255),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            height: 80.h,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
          );
        },
      ),
    );
  }
}

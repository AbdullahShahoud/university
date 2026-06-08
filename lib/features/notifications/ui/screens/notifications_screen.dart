import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/ux_helpers.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/models/notification.dart';
import '../../logic/cubit/notifications_cubit.dart';
import '../widgets/notifications_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationsCubit>()..loadNotifications(),
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final colors = context.colors;

    return BlocListener<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        // Show error snackbar when error occurs
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (context.mounted) {
              context.showErrorSnackBar(state.errorMessage!);
            }
          });
        }
      },
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Background(
                child: _buildBody(context, state, colors, localizations),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificationsState state,
    ColorExtension colors,
    AppLocalizations localizations,
  ) {
    if (state.isLoading) {
      return const NotificationsShimmerLoading();
    }

    if (state.notifications.isEmpty) {
      return EmptyStateWidget(
        title: 'No notifications',
        message: 'You\'re all caught up!',
        icon: Icons.notifications_none,
        actionLabel: 'Refresh',
        onAction: () => context.read<NotificationsCubit>().loadNotifications(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationsCubit>().loadNotifications();
      },
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                Text(
                  localizations.notifications,
                  style: TextStyle(fontSize: 20.sp),
                ),
                Spacer(),
                if (context.read<NotificationsCubit>().unreadCount > 0)
                  SizedBox(
                    width: 120.w,
                    height: 60.h,
                    child: AppButton(
                      onPressed: () {
                        context.read<NotificationsCubit>().markAllAsRead();
                        context.showSuccessSnackBar(
                          'All notifications marked as read',
                        );
                      },
                      text: 'Mark all read',
                      backgroundColor: Colors.transparent,
                      textColor: colors.primary,
                    ),
                  ),
              ],
            ),
          ),

          Container(
            height: MediaQuery.of(context).size.height.h - 150.h,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset((1 - value) * -50, 0),
                        child: child,
                      ),
                    );
                  },
                  child: _buildNotificationItem(context, notification, colors),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    AppNotification notification,
    ColorExtension colors,
  ) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<NotificationsCubit>().deleteNotification(notification.id);
        context.showSuccessSnackBar('Notification deleted');
      },
      confirmDismiss: (_) async {
        return await context.showConfirmDialog(
          title: 'Delete Notification',
          message: 'Are you sure you want to delete this notification?',
          confirmText: 'Delete',
          cancelText: 'Cancel',
        );
      },
      background: const Icon(Icons.delete, color: Colors.white),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: notification.isRead ? colors.borderLight : colors.primary,
            width: notification.isRead ? 1 : 2,
          ),
          borderRadius: BorderRadius.circular(8.r),
          color: notification.isRead
              ? Colors.white.withValues(alpha: 0.2)
              : colors.primary.withOpacity(0.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: _getTypeColor(notification.type),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Center(
                    child: Icon(
                      _getTypeIcon(notification.type),
                      color: Colors.white,
                      size: 20.w,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8.w,
                              height: 8.h,
                              margin: EdgeInsets.only(left: 8.w),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _formatTime(notification.timestamp),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
                // PopupMenuButton(
                //   itemBuilder: (context) => [
                //     if (!notification.isRead)
                //       PopupMenuItem(
                //         onTap: () {
                //           context.read<NotificationsCubit>().markAsRead(
                //             notification.id,
                //           );
                //           Future.delayed(const Duration(milliseconds: 100), () {
                //             if (context.mounted) {
                //               context.showSuccessSnackBar('Marked as read');
                //             }
                //           });
                //         },
                //         child: Row(
                //           children: [
                //             const Icon(Icons.done_all, size: 18),
                //             SizedBox(width: 8.w),
                //             const Text('Mark as read'),
                //           ],
                //         ),
                //       ),

                //     // PopupMenuItem(
                //     //   onTap: () {
                //     //     context.read<NotificationsCubit>().deleteNotification(
                //     //       notification.id,
                //     //     );
                //     //     Future.delayed(const Duration(milliseconds: 100), () {
                //     //       if (context.mounted) {
                //     //         context.showSuccessSnackBar('Notification deleted');
                //     //       }
                //     //     });
                //     //   },
                //     //   child: Row(
                //     //     children: [
                //     //       const Icon(Icons.delete, size: 18, color: Colors.red),
                //     //       SizedBox(width: 8.w),
                //     //       const Text(
                //     //         'Delete',
                //     //         style: TextStyle(color: Colors.red),
                //     //       ),
                //     //     ],
                //     //   ),
                //     // ),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'follow':
        return Colors.blue;
      case 'message':
        return Colors.green;
      case 'update':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'follow':
        return Icons.person_add;
      case 'message':
        return Icons.message;
      case 'update':
        return Icons.update;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

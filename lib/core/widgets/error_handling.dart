import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/colors.dart';
import 'button.dart';

/// Error Dialog Widget
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onDismiss;
  final bool showRetry;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.onDismiss,
    this.showRetry = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 24.w),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
      ),
      actions: [
        if (onDismiss != null)
          TextButton(onPressed: onDismiss!, child: const Text('Dismiss')),
        if (showRetry)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry();
            },
            child: const Text('Retry'),
          ),
      ],
    );
  }
}

/// Error Snackbar
void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.white, size: 20.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(message, style: TextStyle(fontSize: 12.sp)),
          ),
        ],
      ),
      backgroundColor: AppColors.error,
      duration: const Duration(seconds: 4),
    ),
  );
}

/// Success Snackbar
void showSuccessSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 20.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(message, style: TextStyle(fontSize: 12.sp)),
          ),
        ],
      ),
      backgroundColor: AppColors.success,
      duration: const Duration(seconds: 3),
    ),
  );
}

/// Loading Dialog
class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty State Widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;
  final String? retryButtonText;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onRetry,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64.w, color: AppColors.textSecondary),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: 16.h),
            AppButton(
              text: retryButtonText ?? 'Retry',
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}

/// Error State Widget
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  final IconData? icon;

  const ErrorStateWidget({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64.w,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            AppButton(
              text: 'Try Again',
              onPressed: onRetry,
              backgroundColor: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading Skeleton
class LoadingSkeleton extends StatelessWidget {
  final int itemCount;
  final double height;

  const LoadingSkeleton({super.key, this.itemCount = 5, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Container(
          height: height.h,
          decoration: BoxDecoration(
            color: AppColors.placeholder.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }
}

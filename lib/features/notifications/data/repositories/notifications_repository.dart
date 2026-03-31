import 'package:dio/dio.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/notification.dart';

abstract class NotificationsRepository {
  Future<ApiResult<List<AppNotification>>> getNotifications();
  Future<ApiResult<void>> markAsRead(String notificationId);
  Future<ApiResult<void>> deleteNotification(String notificationId);
}

class NotificationsRepositoryImpl extends ApiService
    implements NotificationsRepository {
  NotificationsRepositoryImpl(Dio dio) : super.withDio(dio);

  static final _mockNotifications = <AppNotification>[
    AppNotification(
      id: 'notif-1',
      title: ' متابعة شركة',
      message: 'تمت متابعتك لشركة التقنية بنجاح',
      type: 'follow',
      relatedId: 'startup-1',
      imageUrl: 'assets/images/Depth 5, Frame 0 (1).png',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    AppNotification(
      id: 'notif-2',
      title: 'أخبار جديدة',
      message: 'لديك 3 أخبار جديدة من الشركات المتابعة ',
      type: 'update',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: true,
    ),
    AppNotification(
      id: 'notif-3',
      title: 'رسالة جديدة',
      message: 'استلمت رسالة جديدة من شركة الاستلام البريد',
      type: 'message',
      relatedId: 'user-2',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: true,
    ),
  ];

  @override
  Future<ApiResult<List<AppNotification>>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return ApiResult.success(_mockNotifications);
  }

  @override
  Future<ApiResult<void>> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResult.success(null);
  }

  @override
  Future<ApiResult<void>> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResult.success(null);
  }
}

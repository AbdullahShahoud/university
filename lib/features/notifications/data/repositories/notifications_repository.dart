import 'package:dio/dio.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service_base.dart';
import '../models/notification.dart';

abstract class NotificationsRepository {
  Future<ApiResult<List<AppNotification>>> getNotifications();
  Future<ApiResult<void>> markAsRead(String notificationId);
  Future<ApiResult<void>> deleteNotification(String notificationId);
}

class NotificationsRepositoryImpl extends ApiServiceBase
    implements NotificationsRepository {
  NotificationsRepositoryImpl(Dio dio) : super.withDio(dio);

  @override
  Future<ApiResult<List<AppNotification>>> getNotifications() async {
    try {
      final response = await dio.get('/audience/notifications');
      final data = response.data['data'];
      final listData = (data is Map<String, dynamic>)
          ? (data['notifications'] as List<dynamic>? ?? [])
          : <dynamic>[];
      final list = listData
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<void>> markAsRead(String notificationId) async {
    try {
      await dio.post('/audience/notifications/$notificationId/mark-read');
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<void>> deleteNotification(String notificationId) async {
    try {
      await dio.delete('/audience/notifications/$notificationId');
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/notification.dart';
import '../../data/repositories/notifications_repository.dart';

part 'notifications_cubit.freezed.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    @Default([]) List<AppNotification> notifications,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _NotificationsState;
}

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsCubit(this._repository) : super(const NotificationsState());

  int get unreadCount => state.notifications.where((n) => !n.isRead).length;

  Future<void> loadNotifications() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getNotifications();

    result.when(
      success: (notifications) {
        emit(state.copyWith(notifications: notifications, isLoading: false));
      },
      failure: (error) {
        emit(state.copyWith(errorMessage: error.message, isLoading: false));
      },
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    final result = await _repository.deleteNotification(notificationId);

    result.when(
      success: (_) {
        final updated = state.notifications
            .where((notification) => notification.id != notificationId)
            .toList();
        emit(state.copyWith(notifications: updated));
      },
      failure: (error) {
        emit(state.copyWith(errorMessage: error.message));
      },
    );
  }

  void retry() {
    loadNotifications();
  }

  Future<void> markAsRead(String notificationId) async {
    final updatedNotifications = state.notifications.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();

    emit(state.copyWith(notifications: updatedNotifications));

    await _repository.markAsRead(notificationId);
  }

  Future<void> markAllAsRead() async {
    final updatedNotifications = state.notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();

    emit(state.copyWith(notifications: updatedNotifications));

    for (final notification in state.notifications) {
      if (!notification.isRead) {
        await _repository.markAsRead(notification.id);
      }
    }
  }
}

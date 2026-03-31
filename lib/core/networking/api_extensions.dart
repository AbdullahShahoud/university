import 'api_result.dart';

/// Extensions on ApiResult for convenient handling
///
/// Provides convenient methods to work with ApiResult without needing
/// to use .when() or .map() in all cases
extension ApiResultExtension<T> on ApiResult<T> {
  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is error
  bool get isError => this is Error<T>;

  /// Get data if success, null otherwise
  T? getOrNull() {
    return whenOrNull(success: (data) => data, error: (_) => null);
  }

  /// Get error message if error, null otherwise
  String? getErrorOrNull() {
    return whenOrNull(success: (_) => null, error: (message) => message);
  }

  /// Execute callback if success
  Future<ApiResult<T>> onSuccess(Future<T> Function(T) callback) async {
    return when(
      success: (data) async {
        try {
          final result = await callback(data);
          return ApiResult.success(result);
        } catch (e) {
          return ApiResult.error(e.toString());
        }
      },
      error: (message) async => ApiResult.error(message),
    );
  }

  /// Execute callback if error
  Future<ApiResult<T>> onError(Future<void> Function(String) callback) async {
    return when(
      success: (data) async => ApiResult.success(data),
      error: (message) async {
        await callback(message);
        return ApiResult.error(message);
      },
    );
  }

  /// Transform success value to another type
  ApiResult<R> map<R>(R Function(T) transform) {
    return when(
      success: (data) => ApiResult.success(transform(data)),
      error: (message) => ApiResult.error(message),
    );
  }

  /// Fold result into a single value
  R fold<R>(R Function(String) onError, R Function(T) onSuccess) {
    return when(success: onSuccess, error: onError);
  }

  /// Throw exception if error
  T getOrThrow() {
    return when(
      success: (data) => data,
      error: (message) => throw Exception(message),
    );
  }

  /// Get data with fallback value if error
  T getOrElse(T fallback) {
    return when(success: (data) => data, error: (_) => fallback);
  }
}

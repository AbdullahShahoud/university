import 'api_result.dart';
import '../error/api_error_model.dart';

/// Extensions on ApiResult for convenient handling
///
/// Provides convenient methods to work with ApiResult without needing
/// to use .when() or .map() in all cases
extension ApiResultExtension<T> on ApiResult<T> {
  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is Failure<T>;

  /// Get data if success, null otherwise
  T? getOrNull() {
    return whenOrNull(success: (data) => data, failure: (_) => null);
  }

  /// Get failure details if failure, null otherwise
  ApiErrorModel? getFailureOrNull() {
    return whenOrNull(success: (_) => null, failure: (error) => error);
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
      failure: (error) async => ApiResult.failure(error),
    );
  }

  /// Execute callback if failure
  Future<ApiResult<T>> onFailure(
    Future<void> Function(ApiErrorModel) callback,
  ) async {
    return when(
      success: (data) async => ApiResult.success(data),
      failure: (error) async {
        await callback(error);
        return ApiResult.failure(error);
      },
    );
  }

  /// Transform success value to another type
  ApiResult<R> map<R>(R Function(T) transform) {
    return when(
      success: (data) => ApiResult.success(transform(data)),
      failure: (error) => ApiResult.failure(error),
    );
  }

  /// Fold result into a single value
  R fold<R>(R Function(ApiErrorModel) onFailure, R Function(T) onSuccess) {
    return when(success: onSuccess, failure: onFailure);
  }

  /// Throw exception if failure
  T getOrThrow() {
    return when(
      success: (data) => data,
      failure: (error) => throw Exception(error.message),
    );
  }

  /// Get data with fallback value if failure
  T getOrElse(T fallback) {
    return when(success: (data) => data, failure: (_) => fallback);
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
import '../error/api_error_model.dart';

part 'api_result.freezed.dart';

/// Result wrapper for API calls
///
/// Represents either a successful response with data or a failure.
///
/// Usage:
/// ```dart
/// final result = await apiService.handleApiCall(
///   dio.get('/endpoint'),
///   (json) => MyModel.fromJson(json),
/// );
///
/// result.when(
///   success: (data) => print('Success: $data'),
///   failure: (error) => print('Error: ${error.message}'),
/// );
/// ```
@Freezed()
abstract class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(ApiErrorModel error) = Failure<T>;

  static ApiResult<T> error<T>(String message) =>
      ApiResult.failure(ApiErrorModel(message: message));
}

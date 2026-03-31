import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_result.freezed.dart';
part 'api_result.g.dart';

/// Result wrapper for API calls
///
/// Represents either a successful response with data or an error
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
///   error: (message) => print('Error: $message'),
/// );
/// ```
@freezed
class ApiResult<T> with _$ApiResult<T> {
  /// Successful API response with data
  const factory ApiResult.success(T data) = Success<T>;

  /// Failed API response with error message
  const factory ApiResult.error(String message) = Error<T>;
}

/// API Error Details Model
///
/// Used to provide structured error information from API responses
@freezed
class ApiError with _$ApiError {
  const factory ApiError({
    required String message,
    @Default(500) int statusCode,
    String? details,
  }) = _ApiError;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
}

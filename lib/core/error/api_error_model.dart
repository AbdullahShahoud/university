import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error_model.freezed.dart';
part 'api_error_model.g.dart';

/// Standardized API Error Response Model
///
/// Represents error details returned from API endpoints.
/// Uses Freezed for immutability, equality, and JSON serialization.
///
/// Example:
/// ```dart
/// final error = ApiErrorModel(
///   message: 'Invalid credentials',
///   statusCode: 401,
///   errorCode: 'INVALID_CREDENTIALS',
/// );
/// ```
@freezed
class ApiErrorModel with _$ApiErrorModel {
  /// Creates an ApiErrorModel
  ///
  /// Parameters:
  /// - [message]: Human-readable error message
  /// - [statusCode]: HTTP status code (defaults to 500)
  /// - [details]: Additional error details or debugging info
  /// - [errorCode]: Machine-readable error identifier
  const factory ApiErrorModel({
    required String message,
    @Default(500) int statusCode,
    String? details,
    String? errorCode,
  }) = _ApiErrorModel;

  /// Creates ApiErrorModel from JSON response
  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  /// Convert to JSON
  // @override
  // Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
}

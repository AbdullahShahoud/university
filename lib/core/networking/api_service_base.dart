import 'package:dio/dio.dart';
import '../error/api_error_model.dart';
import 'api_result.dart';
import 'dio_factory.dart';

/// Abstract base class for all API services.
///
/// Provides common functionality for making API calls with proper
/// error handling and response mapping.
abstract class ApiServiceBase {
  late final Dio _dio;

  ApiServiceBase() {
    _dio = DioFactory.createDio();
  }

  /// For testing: allows custom Dio instance injection.
  ApiServiceBase.withDio(this._dio);

  Dio get dio => _dio;

  /// Generic method to handle API calls with automatic error handling.
  Future<ApiResult<T>> handleApiCall<T>(
    Future<Response> apiCall,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await apiCall;
      return _handleSuccessResponse(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResult.failure(
        ApiErrorModel(message: 'Unknown error: ${e.toString()}'),
      );
    }
  }

  ApiResult<T> _handleSuccessResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          return ApiResult.success(fromJson(data));
        } else if (data is List) {
          return ApiResult.success(data as T);
        } else {
          return ApiResult.success(data as T);
        }
      } else {
        final message = response.data?['message'] ?? 'Server error';
        return ApiResult.failure(
          ApiErrorModel(
            message: '$message (Status: $statusCode)',
            statusCode: statusCode,
          ),
        );
      }
    } catch (e) {
      return ApiResult.failure(
        ApiErrorModel(message: 'Failed to parse response: ${e.toString()}'),
      );
    }
  }

  ApiResult<T> _handleDioError<T>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResult.failure(
          ApiErrorModel(
            message:
                'Connection timeout. Please check your internet connection.',
          ),
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error';
        return ApiResult.failure(
          ApiErrorModel(
            message: '$message (Status: $statusCode)',
            statusCode: statusCode ?? 0,
          ),
        );
      case DioExceptionType.cancel:
        return ApiResult.failure(
          ApiErrorModel(message: 'Request cancelled by user'),
        );
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return ApiResult.failure(
            ApiErrorModel(
              message: 'No internet connection. Please check your network.',
            ),
          );
        }
        return ApiResult.failure(
          ApiErrorModel(message: 'Network error: ${error.message}'),
        );
      default:
        return ApiResult.failure(
          ApiErrorModel(message: 'An unexpected error occurred'),
        );
    }
  }
}

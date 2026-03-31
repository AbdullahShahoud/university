import 'package:dio/dio.dart';
import 'api_result.dart';
import 'dio_factory.dart';

/// Abstract base class for all API services
///
/// Provides common functionality for making API calls with proper
/// error handling and response mapping
abstract class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = DioFactory.createDio();
  }

  /// For testing: allows custom Dio instance injection
  ApiService.withDio(this._dio);

  Dio get dio => _dio;

  /// Generic method to handle API calls with automatic error handling
  ///
  /// Parameters:
  /// - [apiCall]: The Future<Response> from dio
  /// - [fromJson]: Function to convert Map to model (for JSON responses)
  ///
  /// Returns:
  /// - [ApiResult.success] with parsed data
  /// - [ApiResult.error] with error message
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
      return ApiResult.error('Unknown error: ${e.toString()}');
    }
  }

  /// Handles successful API responses
  ApiResult<T> _handleSuccessResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final statusCode = response.statusCode ?? 0;

      // Check for successful status codes
      if (statusCode >= 200 && statusCode < 300) {
        final data = response.data;

        // Handle different response types
        if (data is Map<String, dynamic>) {
          return ApiResult.success(fromJson(data));
        } else if (data is List) {
          // For list responses, cast directly
          return ApiResult.success(data as T);
        } else {
          return ApiResult.success(data as T);
        }
      } else {
        final message = response.data?['message'] ?? 'Server error';
        return ApiResult.error('$message (Status: $statusCode)');
      }
    } catch (e) {
      return ApiResult.error('Failed to parse response: ${e.toString()}');
    }
  }

  /// Handles Dio exceptions with user-friendly messages
  ApiResult<T> _handleDioError<T>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResult.error(
          'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error';
        return ApiResult.error('$message (Status: $statusCode)');

      case DioExceptionType.cancel:
        return ApiResult.error('Request cancelled by user');

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return ApiResult.error(
            'No internet connection. Please check your network.',
          );
        }
        return ApiResult.error('Network error: ${error.message}');

      default:
        return ApiResult.error('An unexpected error occurred');
    }
  }
}

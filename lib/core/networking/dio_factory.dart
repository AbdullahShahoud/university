import 'dart:developer' as developer;
import 'package:dio/dio.dart';

/// DioFactory
///
/// Factory class responsible for creating and configuring Dio instance with
/// centralized configuration management
class DioFactory {
  static const String _baseUrl = 'https://api.example.com';
  static const int _connectTimeout = 30;
  static const int _receiveTimeout = 30;
  static const int _sendTimeout = 30;

  DioFactory._();

  /// Creates and returns configured Dio instance with all interceptors
  ///
  /// Can be overridden by providing custom [baseUrl] for testing
  static Dio createDio({String? baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? _baseUrl,
        connectTimeout: const Duration(seconds: _connectTimeout),
        receiveTimeout: const Duration(seconds: _receiveTimeout),
        sendTimeout: const Duration(seconds: _sendTimeout),
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      LoggingInterceptor(),
      // TODO: Add as needed
      // - AuthInterceptor()
      // - RetryInterceptor()
      // - ErrorInterceptor()
    ]);

    return dio;
  }
}

/// LoggingInterceptor
///
/// Logs API requests and responses using dart:developer for better performance
/// in production builds
class LoggingInterceptor extends Interceptor {
  static const String _logTag = 'API_LOG';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final log = StringBuffer()
      ..writeln('═══════════════════════════════════')
      ..writeln('🚀 REQUEST: ${options.method.toUpperCase()} ${options.path}')
      ..writeln('Headers: ${_formatHeaders(options.headers)}');

    if (options.data != null) {
      log.writeln('Body: ${_formatData(options.data)}');
    }
    log.writeln('═══════════════════════════════════');

    developer.log(log.toString(), name: _logTag);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final log = StringBuffer()
      ..writeln('═══════════════════════════════════')
      ..writeln(
        '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}',
      )
      ..writeln('Data: ${_formatData(response.data)}')
      ..writeln('═══════════════════════════════════');

    developer.log(log.toString(), name: _logTag);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final log = StringBuffer()
      ..writeln('═══════════════════════════════════')
      ..writeln(
        '❌ ERROR: ${err.response?.statusCode} ${err.requestOptions.path}',
      )
      ..writeln('Type: ${err.type}')
      ..writeln('Message: ${err.message}')
      ..writeln('Detail: ${_formatData(err.response?.data)}')
      ..writeln('═══════════════════════════════════');

    developer.log(log.toString(), name: _logTag, level: 1000);
    super.onError(err, handler);
  }

  /// Formats headers for logging (removes sensitive data)
  static String _formatHeaders(Map<String, dynamic>? headers) {
    if (headers == null || headers.isEmpty) return '{}';

    final sensitive = {'authorization', 'token', 'api-key', 'x-api-key'};
    final formatted = <String, dynamic>{};

    headers.forEach((key, value) {
      formatted[key] = sensitive.contains(key.toLowerCase()) ? '***' : value;
    });

    return formatted.toString();
  }

  /// Formats data for logging (truncates large payloads)
  static String _formatData(dynamic data) {
    if (data == null) return 'null';

    final str = data.toString();
    if (str.length > 500) {
      return '${str.substring(0, 500)}... (truncated)';
    }
    return str;
  }
}

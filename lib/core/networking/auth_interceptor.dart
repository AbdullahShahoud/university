import 'package:dio/dio.dart';
import 'dio_factory.dart';
import 'token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _storage;

  AuthInterceptor(this._storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _storage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {}
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    // Try refresh token on 401
    if (status == 401) {
      try {
        final refreshToken = await _storage.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          return handler.next(err);
        }

        // Use a fresh Dio instance to call refresh endpoint
        final refreshDio = DioFactory.createDio(
          baseUrl: err.requestOptions.baseUrl,
        );
        final resp = await refreshDio.post(
          '/auth/refreshToken',
          data: {'refreshToken': refreshToken},
        );

        final newToken = resp.data?['data']?['token'] as String?;
        final newRefresh = resp.data?['data']?['refreshToken'] as String?;

        if (newToken != null && newRefresh != null) {
          await _storage.saveTokens(newToken, newRefresh);

          // retry original request with new token
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';
          // mark to avoid infinite loop
          opts.headers['x-retried'] = 'true';

          final clone = await refreshDio.fetch(opts);
          return handler.resolve(clone);
        }
      } catch (e) {
        await _storage.clearTokens();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}

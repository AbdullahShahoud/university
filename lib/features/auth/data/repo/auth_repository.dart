import 'package:dio/dio.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service_base.dart';
import '../../../../core/networking/token_storage.dart';

abstract class AuthRepository {
  Future<ApiResult<Map<String, dynamic>>> login(String email, String password);
  Future<ApiResult<Map<String, dynamic>>> signup(
    String fullName,
    String email,
    String password,
    String passwordConfirm,
  );
  Future<ApiResult<Map<String, dynamic>>> refreshToken(String refreshToken);
  Future<ApiResult<void>> logout({String? refreshToken});
}

class AuthRepositoryImpl extends ApiServiceBase implements AuthRepository {
  final TokenStorage _storage = TokenStorage();

  AuthRepositoryImpl(Dio dio) : super.withDio(dio);

  @override
  Future<ApiResult<Map<String, dynamic>>> login(
    String email,
    String password,
  ) async {
    try {
      final resp = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = resp.data['data'] as Map<String, dynamic>?;
      final token = data?['token'] as String?;
      final refresh = data?['refreshToken'] as String?;
      if (token != null && refresh != null) {
        await _storage.saveTokens(token, refresh);
      }
      return ApiResult.success(data ?? <String, dynamic>{});
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> signup(
    String fullName,
    String email,
    String password,
    String passwordConfirm,
  ) async {
    try {
      final resp = await dio.post(
        '/auth/signup',
        data: {
          'fullName': fullName,
          'email': email,
          'password': password,
          'passwordConfirm': passwordConfirm,
        },
      );
      final data = resp.data['data'] as Map<String, dynamic>?;
      final token = data?['token'] as String?;
      final refresh = data?['refreshToken'] as String?;
      if (token != null && refresh != null) {
        await _storage.saveTokens(token, refresh);
      }
      return ApiResult.success(data ?? <String, dynamic>{});
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final resp = await dio.post(
        '/auth/refreshToken',
        data: {'refreshToken': refreshToken},
      );
      final data = resp.data['data'] as Map<String, dynamic>?;
      final token = data?['token'] as String?;
      final refresh = data?['refreshToken'] as String?;
      if (token != null && refresh != null) {
        await _storage.saveTokens(token, refresh);
      }
      return ApiResult.success(data ?? <String, dynamic>{});
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<void>> logout({String? refreshToken}) async {
    try {
      final body = <String, dynamic>{};
      if (refreshToken != null) body['refreshToken'] = refreshToken;
      await dio.post('/auth/logout', data: body);
      await _storage.clearTokens();
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }
}

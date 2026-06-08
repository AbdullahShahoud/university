import 'package:dio/dio.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service_base.dart';
import '../models/startup.dart';

abstract class ExploreRepository {
  Future<ApiResult<List<Startup>>> getFeaturedStartups();
  Future<ApiResult<List<Startup>>> getLatestStartups();
  Future<ApiResult<List<Category>>> getCategories();
  Future<ApiResult<List<Startup>>> searchStartups(String query);
  Future<ApiResult<List<Startup>>> getStartupsByCategory(String categoryId);
}

class ExploreRepositoryImpl extends ApiServiceBase
    implements ExploreRepository {
  ExploreRepositoryImpl(Dio dio) : super.withDio(dio);

  @override
  Future<ApiResult<List<Startup>>> getFeaturedStartups() async {
    try {
      final response = await dio.get('/audience/startups/featured');
      final data = response.data['data'] as List<dynamic>? ?? [];
      final list = data
          .map((e) => Startup.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<List<Startup>>> getLatestStartups() async {
    try {
      final response = await dio.get('/audience/startups/latest');
      final data = response.data['data'] as List<dynamic>? ?? [];
      final list = data
          .map((e) => Startup.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<List<Category>>> getCategories() async {
    try {
      final response = await dio.get('/audience/categories');
      final data = response.data['data'] as List<dynamic>? ?? [];
      final list = data
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<List<Startup>>> searchStartups(String query) async {
    try {
      final response = await dio.get(
        '/audience/startups',
        queryParameters: {'search': query},
      );
      final data = response.data['data'] as List<dynamic>? ?? [];
      final list = data
          .map((e) => Startup.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<List<Startup>>> getStartupsByCategory(
    String categoryId,
  ) async {
    try {
      final params = <String, dynamic>{};
      if (categoryId != 'all') params['category'] = categoryId;
      final response = await dio.get(
        '/audience/startups',
        queryParameters: params,
      );
      final data = response.data['data'] as List<dynamic>? ?? [];
      final list = data
          .map((e) => Startup.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }
}

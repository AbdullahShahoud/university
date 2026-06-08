import 'package:dio/dio.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service_base.dart';
import '../models/favorite_startup.dart';

abstract class FavoritesRepository {
  Future<ApiResult<List<FavoriteStartup>>> getFavorites();
  Future<ApiResult<void>> addToFavorites(String startupId);
  Future<ApiResult<void>> removeFromFavorites(String startupId);
}

class FavoritesRepositoryImpl extends ApiServiceBase
    implements FavoritesRepository {
  FavoritesRepositoryImpl(Dio dio) : super.withDio(dio);

  @override
  Future<ApiResult<List<FavoriteStartup>>> getFavorites() async {
    try {
      final response = await dio.get('/audience/favorites');
      final data = response.data['data'] as List<dynamic>? ?? [];
      final list = data.map((e) {
        final startup =
            (e as Map<String, dynamic>)['startup'] as Map<String, dynamic>?;
        if (startup != null) {
          return FavoriteStartup.fromJson({
            'id': startup['id'].toString(),
            'name': startup['name'] ?? '',
            'logoUrl': startup['logoUrl'] ?? '',
            'category': startup['category'] ?? '',
            'rating': (startup['rating'] as num?)?.toDouble() ?? 0.0,
          });
        }
        return FavoriteStartup.fromJson({
          'id': e['startupId'].toString(),
          'name': e['startupName'] ?? '',
          'logoUrl': e['logoUrl'] ?? '',
          'category': e['category'] ?? '',
          'rating': 0.0,
        });
      }).toList();
      return ApiResult.success(list);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<void>> addToFavorites(String startupId) async {
    try {
      await dio.post('/audience/favorites', data: {'startupId': startupId});
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<void>> removeFromFavorites(String startupId) async {
    try {
      await dio.delete('/audience/favorites/$startupId');
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }
}

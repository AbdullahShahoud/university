import 'package:dio/dio.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service_base.dart';
import '../models/news_article.dart';

abstract class NewsRepository {
  Future<ApiResult<List<NewsArticle>>> getNewsArticles({int page = 1});
}

class NewsRepositoryImpl extends ApiServiceBase implements NewsRepository {
  NewsRepositoryImpl(Dio dio) : super.withDio(dio);

  @override
  Future<ApiResult<List<NewsArticle>>> getNewsArticles({int page = 1}) async {
    try {
      final response = await dio.get(
        '/audience/news',
        queryParameters: {'page': page},
      );
      final data = response.data['data'] as List<dynamic>? ?? [];
      final articles = data
          .map((e) => NewsArticle.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(articles);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }
}

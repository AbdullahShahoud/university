import 'package:dio/dio.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service_base.dart';
import '../models/hub_models.dart';

abstract class HubRepository {
  Future<ApiResult<List<HubEvent>>> getEvents({int page = 1, int limit = 10});

  Future<ApiResult<Map<String, dynamic>>> registerEvent(String eventId);

  Future<ApiResult<List<HubJob>>> getJobs({int page = 1, int limit = 10});

  Future<ApiResult<Map<String, dynamic>>> applyJob(
    String jobId, {
    String? resumeUrl,
    String? coverLetter,
  });

  Future<ApiResult<List<HubTraining>>> getTrainings({
    int page = 1,
    int limit = 10,
  });

  Future<ApiResult<Map<String, dynamic>>> registerTraining(String trainingId);
}

class HubRepositoryImpl extends ApiServiceBase implements HubRepository {
  HubRepositoryImpl(Dio dio) : super.withDio(dio);

  @override
  Future<ApiResult<List<HubEvent>>> getEvents({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final resp = await dio.get(
        '/audience/hub/events',
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = resp.data['data'] as List<dynamic>? ?? [];
      final list = data
          .map((e) => HubEvent.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> registerEvent(String eventId) async {
    try {
      final resp = await dio.post('/audience/hub/events/$eventId/register');
      final data = resp.data['data'] as Map<String, dynamic>? ?? {};
      return ApiResult.success(data);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<List<HubJob>>> getJobs({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final resp = await dio.get(
        '/audience/hub/jobs',
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = resp.data['data'] as List<dynamic>? ?? [];
      final list = data
          .map((e) => HubJob.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> applyJob(
    String jobId, {
    String? resumeUrl,
    String? coverLetter,
  }) async {
    try {
      final resp = await dio.post(
        '/audience/hub/jobs/$jobId/apply',
        data: {
          if (resumeUrl != null) 'resumeUrl': resumeUrl,
          if (coverLetter != null) 'coverLetter': coverLetter,
        },
      );
      final data = resp.data['data'] as Map<String, dynamic>? ?? {};
      return ApiResult.success(data);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<List<HubTraining>>> getTrainings({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final resp = await dio.get(
        '/audience/hub/trainings',
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = resp.data['data'] as List<dynamic>? ?? [];
      final list = data
          .map((e) => HubTraining.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> registerTraining(
    String trainingId,
  ) async {
    try {
      final resp = await dio.post(
        '/audience/hub/trainings/$trainingId/register',
      );
      final data = resp.data['data'] as Map<String, dynamic>? ?? {};
      return ApiResult.success(data);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }
}

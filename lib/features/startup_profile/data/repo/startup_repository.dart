import 'package:dio/dio.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service_base.dart';
import '../models/startup_details.dart';

abstract class StartupRepository {
  Future<ApiResult<StartupDetails>> getStartupDetails(String startupId);
}

class StartupRepositoryImpl extends ApiServiceBase
    implements StartupRepository {
  StartupRepositoryImpl(Dio dio) : super.withDio(dio);

  @override
  Future<ApiResult<StartupDetails>> getStartupDetails(String startupId) async {
    try {
      final response = await dio.get('/audience/startups/id/$startupId');
      final data = response.data['data'];
      // API returns { data: { startup: { ... }, isFollowing: true, ... } }
      final startupJson = (data is Map<String, dynamic>)
          ? (data['startup'] as Map<String, dynamic>?)
          : null;
      if (startupJson == null) {
        return ApiResult.error('Startup data missing');
      }
      final details = StartupDetails.fromJson(startupJson);
      return ApiResult.success(details);
    } on DioException catch (e) {
      return ApiResult.error(e.message ?? 'Network error');
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }
}

import 'package:dio/dio.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/favorite_startup.dart';

abstract class FavoritesRepository {
  Future<ApiResult<List<FavoriteStartup>>> getFavorites();
  Future<ApiResult<void>> addToFavorites(String startupId);
  Future<ApiResult<void>> removeFromFavorites(String startupId);
}

class FavoritesRepositoryImpl extends ApiService
    implements FavoritesRepository {
  FavoritesRepositoryImpl(Dio dio) : super.withDio(dio);

  static final _mockFavorites = <FavoriteStartup>[
    const FavoriteStartup(
      id: 'tech-1',
      name: 'شركة التقنية المتطورة',
      logoUrl: 'assets/images/Depth 5, Frame 0 (1).png',
      category: 'technology',
      rating: 4.8,
    ),
    const FavoriteStartup(
      id: 'commerce-1',
      name: 'التجارة العالمية',
      logoUrl: 'assets/images/Depth 5, Frame 0 (2).png',
      category: 'commerce',
      rating: 4.6,
    ),
    const FavoriteStartup(
      id: 'services-1',
      name: 'الخدمات المتميزة',
      logoUrl: 'assets/images/Depth 5, Frame 0 (2).png',
      category: 'services',
      rating: 4.5,
    ),
    const FavoriteStartup(
      id: 'app-1',
      name: 'تطبيقات الهاتف',
      logoUrl: 'assets/images/Depth 5, Frame 0 (3).png',
      category: 'apps',
      rating: 4.7,
    ),
    const FavoriteStartup(
      id: 'fintech-1',
      name: 'حلول التمويل الرقمي',
      logoUrl: 'assets/images/Depth 4, Frame 1.png',
      category: 'fintech',
      rating: 4.9,
    ),
    const FavoriteStartup(
      id: 'education-1',
      name: 'منصات التعليم الذكي',
      logoUrl: 'assets/images/Depth 4, Frame 1 (1).png',
      category: 'education',
      rating: 4.4,
    ),
    const FavoriteStartup(
      id: 'health-1',
      name: 'الصحة الرقمية المتقدمة',
      logoUrl: 'assets/images/Depth 5, Frame 0.png',
      category: 'healthcare',
      rating: 4.6,
    ),
    const FavoriteStartup(
      id: 'logistics-1',
      name: 'خدمات اللوجستيات الذكية',
      logoUrl: 'assets/images/Depth 5, Frame 0 (1).png',
      category: 'logistics',
      rating: 4.5,
    ),
  ];

  @override
  Future<ApiResult<List<FavoriteStartup>>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return ApiResult.success(_mockFavorites);
  }

  @override
  Future<ApiResult<void>> addToFavorites(String startupId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return ApiResult.success(null);
  }

  @override
  Future<ApiResult<void>> removeFromFavorites(String startupId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return ApiResult.success(null);
  }
}

import 'package:dio/dio.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/startup.dart';

abstract class ExploreRepository {
  Future<ApiResult<List<Startup>>> getFeaturedStartups();
  Future<ApiResult<List<Startup>>> getLatestStartups();
  Future<ApiResult<List<Category>>> getCategories();
  Future<ApiResult<List<Startup>>> searchStartups(String query);
  Future<ApiResult<List<Startup>>> getStartupsByCategory(String categoryId);
}

class ExploreRepositoryImpl extends ApiService implements ExploreRepository {
  ExploreRepositoryImpl(Dio dio) : super.withDio(dio);

  static final _allStartups = <Startup>[
    const Startup(
      id: 'tech-1',
      name: 'شركة التقنية المتطورة',
      description: 'حلول تقنية مبتكرة',
      logoUrl: 'assets/images/Depth 5, Frame 0 (1).png',
      coverUrl: 'assets/images/Depth 5, Frame 0.png',
      rating: 4.8,
      reviewCount: 468,
      category: 'technology',
      isFollowing: false,
    ),
    const Startup(
      id: 'commerce-1',
      name: 'شركة التجارة العالمية',
      description: 'تجارة إلكترونية متكاملة',
      logoUrl: 'assets/images/Depth 5, Frame 0 (1).png',
      coverUrl: 'assets/images/Depth 5, Frame 0 (1).png',
      rating: 4.6,
      reviewCount: 414,
      category: 'commerce',
      isFollowing: false,
    ),
    const Startup(
      id: 'services-1',
      name: 'شركة الخدمات المتميزة',
      description: 'خدمات التسويق الرقمية',
      logoUrl: 'assets/images/Depth 5, Frame 0 (2).png',
      coverUrl: 'assets/images/Depth 5, Frame 0 (2).png',
      rating: 4.7,
      reviewCount: 394,
      category: 'services',
      isFollowing: false,
    ),
    const Startup(
      id: 'app-1',
      name: 'شركة تطبيقات الهاتف',
      description: 'تطبيقات متنوعة',
      logoUrl: 'assets/images/Depth 5, Frame 0 (3).png',
      coverUrl: 'assets/images/Depth 5, Frame 0 (3).png',
      rating: 4.6,
      reviewCount: 320,
      category: 'technology',
      isFollowing: false,
    ),
  ];

  static const _categories = <Category>[
    Category(id: 'all', name: 'all', displayName: 'الكل'),
    Category(id: 'technology', name: 'technology', displayName: 'التقنية'),
    Category(id: 'commerce', name: 'commerce', displayName: 'التجارة'),
    Category(id: 'services', name: 'services', displayName: 'الخدمات'),
  ];

  Future<ApiResult<List<T>>> _simulateResult<T>(List<T> data) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return ApiResult.success(data);
  }

  @override
  Future<ApiResult<List<Startup>>> getFeaturedStartups() async {
    final favourites = _allStartups.take(3).toList();
    return _simulateResult(favourites);
  }

  @override
  Future<ApiResult<List<Startup>>> getLatestStartups() async {
    return _simulateResult(_allStartups);
  }

  @override
  Future<ApiResult<List<Category>>> getCategories() async {
    return _simulateResult(_categories);
  }

  @override
  Future<ApiResult<List<Startup>>> searchStartups(String query) async {
    final lower = query.toLowerCase();
    final filtered = _allStartups.where((startup) {
      return startup.name.toLowerCase().contains(lower) ||
          startup.description.toLowerCase().contains(lower);
    }).toList();
    return _simulateResult(filtered);
  }

  @override
  Future<ApiResult<List<Startup>>> getStartupsByCategory(
    String categoryId,
  ) async {
    List<Startup> filtered;
    if (categoryId == 'all') {
      filtered = _allStartups;
    } else {
      filtered = _allStartups
          .where((startup) => startup.category == categoryId)
          .toList();
    }
    return _simulateResult(filtered);
  }
}

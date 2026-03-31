import 'package:dio/dio.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/startup_details.dart';

abstract class StartupRepository {
  Future<ApiResult<StartupDetails>> getStartupDetails(String startupId);
}

class StartupRepositoryImpl extends ApiService implements StartupRepository {
  StartupRepositoryImpl(Dio dio) : super.withDio(dio);

  static final _mockStartups = <String, StartupDetails>{
    'tech-1': StartupDetails(
      id: 'tech-1',
      name: 'شركة التقنية المتطورة',
      description: 'حلول تقنية مبتكرة',
      logoUrl: 'assets/images/Depth 5, Frame 0 (1).png',
      coverUrl: 'assets/images/Depth 5, Frame 0.png',
      rating: 4.8,
      reviewCount: 468,
      category: 'technology',
      isFollowing: false,
      website: 'https://example.com',
      email: 'contact@example.com',
      phone: '+966501234567',
      founded: '2020',
      location: 'الرياض، السعودية',
      about:
          'نحن شركة متخصصة في تطوير الحلول التقنية المبتكرة والمستدامة للشركات والمؤسسات الرائدة.',
      features: [
        'Mobile Apps',
        'Web Development',
        'Cloud Solutions',
        'AI Integration',
      ],
      news: [
        StartupNews(
          id: 'n1',
          title: 'إطلاق منتج جديد',
          description: 'تم بنجاح إطلاق منصة جديدة للتجارة الإلكترونية',
          imageUrl: 'assets/images/Depth 4, Frame 1.png',
          publishedAt: DateTime.now().toIso8601String(),
        ),
      ],
      contacts: [
        Contact(
          id: 'c1',
          name: 'أحمد محمد',
          title: 'الرئيس التنفيذي',
          email: 'ahmed@example.com',
          phone: '+966501234567',
          imageUrl: 'assets/images/Depth 5, Frame 0 (1).png',
        ),
        Contact(
          id: 'c2',
          name: 'فاطمة علي',
          title: 'مدير المنتج',
          email: 'fatima@example.com',
          phone: '+966502345678',
          imageUrl: 'assets/images/Depth 5, Frame 0 (2).png',
        ),
      ],
    ),
    'commerce-1': StartupDetails(
      id: 'commerce-1',
      name: 'شركة التجارة العالمية',
      description: 'تجارة إلكترونية متكاملة',
      logoUrl: 'assets/images/Depth 5, Frame 0 (1).png',
      coverUrl: 'assets/images/Depth 5, Frame 0 (1).png',
      rating: 4.6,
      reviewCount: 414,
      category: 'commerce',
      isFollowing: false,
      website: 'https://example.com',
      email: 'commerce@example.com',
      phone: '+966502345678',
      founded: '2019',
      location: 'جدة، السعودية',
      about:
          'منصة تجارة إلكترونية متكاملة توفر أفضل الخدمات والمنتجات للعملاء.',
      features: [
        'E-commerce Platform',
        'Payment Gateway',
        'Inventory Management',
        'Customer Support',
      ],
      news: [
        StartupNews(
          id: 'n2',
          title: 'توسع الخدمات',
          description: 'توسع الخدمات إلى دول الخليج الأخرى',
          imageUrl: 'assets/images/Depth 4, Frame 1 (1).png',
          publishedAt: DateTime.now().toIso8601String(),
        ),
      ],
      contacts: [
        Contact(
          id: 'c3',
          name: 'محمد علي',
          title: 'الرئيس التنفيذي',
          email: 'mohammad@example.com',
          phone: '+966503456789',
          imageUrl: 'assets/images/Depth 5, Frame 0 (2).png',
        ),
      ],
    ),
    'services-1': StartupDetails(
      id: 'services-1',
      name: 'شركة الخدمات المتميزة',
      description: 'خدمات التسويق الرقمية',
      logoUrl: 'assets/images/Depth 5, Frame 0 (2).png',
      coverUrl: 'assets/images/Depth 5, Frame 0 (2).png',
      rating: 4.7,
      reviewCount: 394,
      category: 'services',
      isFollowing: false,
      website: 'https://example.com',
      email: 'services@example.com',
      phone: '+966509876543',
      founded: '2021',
      location: 'الدمام، السعودية',
      about:
          'متخصصون في تقديم خدمات التسويق الرقمي والاستشارات التجارية المميزة.',
      features: [
        'Digital Marketing',
        'Social Media Management',
        'SEO Services',
        'Brand Strategy',
      ],
      news: [
        StartupNews(
          id: 'n3',
          title: 'حملة تسويقية ناجحة',
          description: 'نجحت حملتنا التسويقية في زيادة المبيعات بنسبة 150%',
          imageUrl: 'assets/images/Depth 5, Frame 0 (3).png',
          publishedAt: DateTime.now().toIso8601String(),
        ),
      ],
      contacts: [
        Contact(
          id: 'c4',
          name: 'سارة أحمد',
          title: 'مدير التسويق',
          email: 'sarah@example.com',
          phone: '+966504567890',
          imageUrl: 'assets/images/Depth 5, Frame 0 (3).png',
        ),
      ],
    ),
    'app-1': StartupDetails(
      id: 'app-1',
      name: 'شركة تطبيقات الهاتف',
      description: 'تطبيقات متنوعة',
      logoUrl: 'assets/images/Depth 5, Frame 0 (3).png',
      coverUrl: 'assets/images/Depth 5, Frame 0 (3).png',
      rating: 4.6,
      reviewCount: 320,
      category: 'technology',
      isFollowing: false,
      website: 'https://example.com',
      email: 'apps@example.com',
      phone: '+966505678901',
      founded: '2022',
      location: 'الرياض، السعودية',
      about:
          'متخصصون في تطوير تطبيقات الهاتف الذكي بمختلف أنواعها وأغراضها.',
      features: [
        'Mobile App Development',
        'iOS & Android',
        'Cross-platform',
        'UI/UX Design',
      ],
      news: [
        StartupNews(
          id: 'n4',
          title: 'تطبيق جديد',
          description: 'تم إطلاق تطبيق جديد بميزات متقدمة',
          imageUrl: 'assets/images/Depth 4, Frame 1.png',
          publishedAt: DateTime.now().toIso8601String(),
        ),
      ],
      contacts: [
        Contact(
          id: 'c5',
          name: 'عمر خالد',
          title: 'مهندس رئيسي',
          email: 'omar@example.com',
          phone: '+966506789012',
          imageUrl: 'assets/images/Depth 5, Frame 0 (1).png',
        ),
      ],
    ),
  };

  @override
  Future<ApiResult<StartupDetails>> getStartupDetails(String startupId) async {
    await Future.delayed(const Duration(milliseconds: 350));

    final startup = _mockStartups[startupId];
    if (startup != null) {
      return ApiResult.success(startup);
    }

    return ApiResult.error('Startup not found');
  }
}

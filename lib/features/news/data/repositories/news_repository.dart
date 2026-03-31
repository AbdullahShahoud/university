import 'package:dio/dio.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/news_article.dart';

abstract class NewsRepository {
  Future<ApiResult<List<NewsArticle>>> getNewsArticles({int page = 1});
}

class NewsRepositoryImpl extends ApiService implements NewsRepository {
  NewsRepositoryImpl(Dio dio) : super.withDio(dio);

  static final _mockNews = <NewsArticle>[
    NewsArticle(
      id: 'news-1',
      title: 'ثورة تقنية في مجال الذكاء الاصطناعي',
      description: 'أحدث التطورات في مجال الذكاء الاصطناعي والتعلم الآلي',
      content: 'محتوى مفصل عن ثورة الذكاء الاصطناعي...',
      imageUrl: 'assets/images/Depth 4, Frame 1.png',
      category: 'technology',
      author: 'أحمد محمد',
      sourceCompany: 'TechHub Solutions',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      views: 2500,
      tags: ['AI', 'Tech', 'Innovation'],
    ),
    NewsArticle(
      id: 'news-2',
      title: 'نمو السوق الرقمية في الشرق الأوسط',
      description: 'إحصائيات حديثة عن نمو التجارة الإلكترونية',
      content: 'محتوى مفصل عن نمو السوق الرقمية...',
      imageUrl: 'assets/images/Depth 4, Frame 1 (1).png',
      category: 'business',
      author: 'فاطمة أحمد',
      sourceCompany: 'Digital Market Analytics',
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      views: 1800,
      tags: ['Business', 'Market', 'Growth'],
    ),
    NewsArticle(
      id: 'news-3',
      title: 'شركات ناشئة عربية تقود الاستثمار',
      description: 'قصص نجاح الشركات الناشئة العربية',
      content: 'محتوى مفصل عن نجاح الشركات الناشئة...',
      imageUrl: 'assets/images/Depth 5, Frame 0 (3).png',
      category: 'startups',
      author: 'محمد علي',
      sourceCompany: 'Startup Ecosystem Hub',
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      views: 3200,
      tags: ['Startups', 'Success', 'Investment'],
    ),
    NewsArticle(
      id: 'news-4',
      title: 'البنية التحتية الرقمية تتطور في دول الخليج',
      description: 'استثمارات ضخمة في تطوير البنية التحتية للإنترنت',
      content: 'تحتل دول الخليج مراتب متقدمة في مجال البنية التحتية الرقمية...',
      imageUrl: 'assets/images/Depth 4, Frame 1.png',
      category: 'infrastructure',
      author: 'سارة السهيلي',
      sourceCompany: 'Gulf Tech Weekly',
      publishedAt: DateTime.now().subtract(const Duration(days: 4)),
      views: 1950,
      tags: ['Infrastructure', 'Investment', 'Growth'],
    ),
    NewsArticle(
      id: 'news-5',
      title: 'الخدمات المالية الرقمية تحول العالم',
      description: 'تطبيقات FinTech تغير طريقة تعاملنا مع المال',
      content: 'الخدمات المالية الرقمية تفتح آفاقاً جديدة للمستثمرين...',
      imageUrl: 'assets/images/Depth 4, Frame 1 (1).png',
      category: 'fintech',
      author: 'علي الشمري',
      sourceCompany: 'FinTech Insights',
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      views: 2750,
      tags: ['FinTech', 'Banking', 'Innovation'],
    ),
    NewsArticle(
      id: 'news-6',
      title: 'التعليم الإلكتروني ينمو بشكل غير مسبوق',
      description: 'منصات التعليم الرقمية تكتسب شعبية متزايدة',
      content: 'يشهد قطاع التعليم الإلكتروني نمواً هائلاً في الفترة الأخيرة...',
      imageUrl: 'assets/images/Depth 5, Frame 0 (3).png',
      category: 'education',
      author: 'نادية الحمادي',
      sourceCompany: 'Education Tech Today',
      publishedAt: DateTime.now().subtract(const Duration(days: 6)),
      views: 1650,
      tags: ['Education', 'Online Learning', 'Tech'],
    ),
  ];

  @override
  Future<ApiResult<List<NewsArticle>>> getNewsArticles({int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 350));

    final startIndex = (page - 1) * 5;
    final endIndex = startIndex + 5;

    final articles = _mockNews.length > startIndex
        ? _mockNews.sublist(
            startIndex,
            endIndex > _mockNews.length ? _mockNews.length : endIndex,
          )
        : <NewsArticle>[];

    return ApiResult.success(articles);
  }
}

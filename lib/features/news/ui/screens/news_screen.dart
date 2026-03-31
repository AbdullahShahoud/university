import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../news/logic/cubit/news_cubit.dart';
import '../widgets/news_widgets.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NewsView();
  }
}

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load news on first build only
    getIt<NewsCubit>().loadNews();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      getIt<NewsCubit>().loadMoreNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<NewsCubit, NewsState>(
      bloc: getIt<NewsCubit>(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(localizations.news), elevation: 0),
          body: state.isLoading && state.articles.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : state.articles.isEmpty && !state.isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.newspaper,
                        size: 64.w,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        localizations.noData,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (state.errorMessage != null)
                        Column(
                          children: [
                            Text(
                              state.errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.error,
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ElevatedButton(
                        onPressed: () => getIt<NewsCubit>().retry(),
                        child: Text(localizations.retry),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    getIt<NewsCubit>().loadNews();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16.w),
                    itemCount:
                        state.articles.length + (state.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.articles.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.h),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final article = state.articles[index];
                      return NewsListCard(
                        article: article,
                        onTap: () {
                          _navigateToDetail(context, article.id);
                        },
                      );
                    },
                  ),
                ),
        );
      },
    );
  }

  void _navigateToDetail(BuildContext context, String newsId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewsDetailScreen(newsId: newsId)),
    );
  }
}

class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load the news detail using the existing singleton
    getIt<NewsCubit>().loadNewsDetail(widget.newsId);
  }

  @override
  Widget build(BuildContext context) {
    return const NewsDetailView();
  }
}

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<NewsCubit, NewsState>(
      bloc: getIt<NewsCubit>(),
      builder: (context, state) {
        if (state.isLoadingDetail && state.selectedArticle == null) {
          return Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage != null && state.selectedArticle == null) {
          return Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.error),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => getIt<NewsCubit>().loadNewsDetail(
                      state.selectedArticle?.id ?? '',
                    ),
                    child: Text(localizations.retry),
                  ),
                ],
              ),
            ),
          );
        }

        final article = state.selectedArticle!;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.h,
                floating: false,
                pinned: true,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: NewsDetailHeader(
                    article: article,
                    onBackPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meta Info
                      NewsMetaInfo(article: article),
                      SizedBox(height: 24.h),
                      // Description
                      Text(
                        article.description,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Content
                      Text(
                        article.content,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Tags
                      if (article.tags.isNotEmpty) ...[
                        Text(
                          'Tags',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        NewsTags(tags: article.tags),
                      ],
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/button.dart';
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
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;

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
    _searchController.dispose();
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
        final colors = context.colors;
        final categories = <String>[
          'All',
          ...state.articles.map((article) => article.category).toSet().toList(),
        ];

        final searchQuery = _searchController.text.trim().toLowerCase();
        final filteredArticles = state.articles.where((article) {
          final matchesCategory =
              _selectedCategoryIndex == 0 ||
              article.category == categories[_selectedCategoryIndex];
          final matchesSearch =
              searchQuery.isEmpty ||
              article.title.toLowerCase().contains(searchQuery) ||
              article.description.toLowerCase().contains(searchQuery) ||
              article.sourceCompany.toLowerCase().contains(searchQuery);
          return matchesCategory && matchesSearch;
        }).toList();

        return Scaffold(
          body: SafeArea(
            child: Background(
              child: state.isLoading && state.articles.isEmpty
                  ? const NewsShimmerLoading()
                  : state.articles.isEmpty && !state.isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.newspaper,
                            size: 64.w,
                            color: colors.textSecondary,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            localizations.noData,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: colors.textSecondary,
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
                                    color: colors.error,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                              ],
                            ),
                          AppButton(
                            text: localizations.retry,
                            onPressed: () => getIt<NewsCubit>().retry(),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        getIt<NewsCubit>().loadNews();
                      },
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20.h),
                                  Text(
                                    localizations.news,
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  SizedBox(height: 16.h),
                                  SizedBox(
                                    height: 48.h,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: categories.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(width: 8.w),
                                      itemBuilder: (context, index) {
                                        final category = categories[index];
                                        final selected =
                                            index == _selectedCategoryIndex;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedCategoryIndex = index;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 18.w,
                                              vertical: 12.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: selected
                                                  ? colors.primary
                                                  : colors.surface,
                                              borderRadius:
                                                  BorderRadius.circular(24.r),
                                              border: Border.all(
                                                color: selected
                                                    ? colors.primary
                                                    : colors.borderLight,
                                              ),
                                            ),
                                            child: Text(
                                              category,
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600,
                                                color: selected
                                                    ? Colors.white
                                                    : colors.textPrimary,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                ],
                              ),
                            ),
                          ),
                          if (filteredArticles.isEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Center(
                                  child: Text(
                                    localizations.noData,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else
                            SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (index == filteredArticles.length) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 24.h,
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: colors.primary,
                                          ),
                                        ),
                                      );
                                    }

                                    final article = filteredArticles[index];
                                    return TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: 1),
                                      duration: Duration(
                                        milliseconds: 250 + (index * 75),
                                      ),
                                      curve: Curves.easeOut,
                                      builder: (context, value, child) {
                                        return Opacity(
                                          opacity: value,
                                          child: Transform.translate(
                                            offset: Offset(0, (1 - value) * 20),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 4.h),
                                        child: NewsListCard(
                                          article: article,
                                          onTap: () {
                                            _navigateToDetail(
                                              context,
                                              article.id,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  childCount:
                                      filteredArticles.length +
                                      (state.isLoading ? 1 : 0),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
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
        final colors = context.colors;

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
                    style: TextStyle(fontSize: 14.sp, color: colors.error),
                  ),
                  SizedBox(height: 16.h),
                  AppButton(
                    text: localizations.retry,
                    onPressed: () => getIt<NewsCubit>().loadNewsDetail(
                      state.selectedArticle?.id ?? '',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final article = state.selectedArticle!;

        return Scaffold(
          body: Background(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250.h,
                  floating: false,
                  pinned: true,
                  backgroundColor: colors.background,
                  foregroundColor: colors.textPrimary,
                  automaticallyImplyLeading:
                      false, // Remove default back button
                  flexibleSpace: FlexibleSpaceBar(
                    background: SafeArea(
                      top: true,
                      bottom: false,
                      child: NewsDetailHeader(
                        article: article,
                        onBackPressed: () => Navigator.pop(context),
                      ),
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
                            color: colors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Content
                        Text(
                          article.content,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: colors.textSecondary,
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
                              color: colors.textPrimary,
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
          ),
        );
      },
    );
  }
}

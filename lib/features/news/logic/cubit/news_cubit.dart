import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/news_article.dart';
import '../../data/repositories/news_repository.dart';

part 'news_cubit.freezed.dart';

@freezed
class NewsState with _$NewsState {
  const factory NewsState({
    @Default([]) List<NewsArticle> articles,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingDetail,
    String? errorMessage,
    @Default(1) int currentPage,
    NewsArticle? selectedArticle,
  }) = _NewsState;
}

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _repository;

  NewsCubit(this._repository) : super(const NewsState());

  Future<void> loadNews({int page = 1}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getNewsArticles(page: page);

    result.when(
      success: (articles) {
        final allArticles = page == 1
            ? articles
            : [...state.articles, ...articles];
        emit(
          state.copyWith(
            articles: allArticles,
            isLoading: false,
            currentPage: page,
          ),
        );
      },
      error: (error) {
        emit(state.copyWith(errorMessage: error, isLoading: false));
      },
    );
  }

  void loadMoreNews() {
    loadNews(page: state.currentPage + 1);
  }

  void retry() {
    loadNews(page: 1);
  }

  Future<void> loadNewsDetail(String newsId) async {
    emit(state.copyWith(isLoadingDetail: true, errorMessage: null));

    try {
      final article = state.articles.firstWhere(
        (article) => article.id == newsId,
      );
      emit(state.copyWith(selectedArticle: article, isLoadingDetail: false));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Article not found',
          isLoadingDetail: false,
        ),
      );
    }
  }
}

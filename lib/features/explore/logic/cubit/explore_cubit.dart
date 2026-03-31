import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/startup.dart';
import '../../data/repo/explore_repository.dart';

part 'explore_cubit.freezed.dart';

@freezed
class ExploreState with _$ExploreState {
  const factory ExploreState({
    @Default([]) List<Startup> featuredStartups,
    @Default([]) List<Startup> latestStartups,
    @Default([]) List<Category> categories,
    @Default([]) List<Startup> searchResults,
    @Default(false) bool isLoading,
    @Default(false) bool isSearching,
    String? errorMessage,
    String? searchQuery,
    String? selectedCategory,
  }) = _ExploreState;
}

class ExploreCubit extends Cubit<ExploreState> {
  final ExploreRepository _repository;

  ExploreCubit(this._repository) : super(const ExploreState()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final featuredResult = await _repository.getFeaturedStartups();
    final latestResult = await _repository.getLatestStartups();
    final categoriesResult = await _repository.getCategories();

    featuredResult.when(
      success: (featured) {
        latestResult.when(
          success: (latest) {
            categoriesResult.when(
              success: (categories) {
                emit(
                  state.copyWith(
                    featuredStartups: featured,
                    latestStartups: latest,
                    categories: categories,
                    isLoading: false,
                    selectedCategory: 'all',
                  ),
                );
              },
              error: (error) {
                emit(state.copyWith(errorMessage: error, isLoading: false));
              },
            );
          },
          error: (error) {
            emit(state.copyWith(errorMessage: error, isLoading: false));
          },
        );
      },
      error: (error) {
        emit(state.copyWith(errorMessage: error, isLoading: false));
      },
    );
  }

  Future<void> searchStartups(String query) async {
    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchResults: [],
          searchQuery: null,
          isSearching: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(isSearching: true, searchQuery: query, errorMessage: null),
    );

    final result = await _repository.searchStartups(query);

    result.when(
      success: (startups) {
        emit(state.copyWith(searchResults: startups, isSearching: false));
      },
      error: (error) {
        emit(state.copyWith(errorMessage: error, isSearching: false));
      },
    );
  }

  Future<void> filterByCategory(String categoryId) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        selectedCategory: categoryId,
      ),
    );

    final result = await _repository.getStartupsByCategory(categoryId);

    result.when(
      success: (startups) {
        emit(
          state.copyWith(
            latestStartups: startups,
            isLoading: false,
            selectedCategory: categoryId,
          ),
        );
      },
      error: (error) {
        emit(
          state.copyWith(
            errorMessage: error,
            isLoading: false,
            selectedCategory: categoryId,
          ),
        );
      },
    );
  }

  void clearSearch() {
    emit(
      state.copyWith(searchResults: [], searchQuery: null, isSearching: false),
    );
  }

  void retry() {
    loadInitialData();
  }
}

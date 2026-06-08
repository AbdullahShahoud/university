import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/favorite_startup.dart';
import '../../data/repositories/favorites_repository.dart';

part 'favorites_cubit.freezed.dart';

@freezed
class FavoritesState with _$FavoritesState {
  const factory FavoritesState({
    @Default([]) List<FavoriteStartup> favorites,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _FavoritesState;
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesCubit(this._repository) : super(const FavoritesState());

  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getFavorites();

    result.when(
      success: (favorites) {
        emit(state.copyWith(favorites: favorites, isLoading: false));
      },
      failure: (error) {
        emit(state.copyWith(errorMessage: error.message, isLoading: false));
      },
    );
  }

  Future<void> removeFromFavorites(String startupId) async {
    final result = await _repository.removeFromFavorites(startupId);

    result.when(
      success: (_) {
        final updated = state.favorites
            .where((item) => item.id != startupId)
            .toList();
        emit(state.copyWith(favorites: updated));
      },
      failure: (error) {
        emit(state.copyWith(errorMessage: error.message));
      },
    );
  }

  Future<void> addToFavorites(String startupId) async {
    final result = await _repository.addToFavorites(startupId);

    result.when(
      success: (_) {
        loadFavorites();
      },
      failure: (error) {
        emit(state.copyWith(errorMessage: error.message));
      },
    );
  }

  void retry() {
    loadFavorites();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/startup_details.dart';
import '../../data/repo/startup_repository.dart';

part 'startup_cubit.freezed.dart';

@freezed
class StartupState with _$StartupState {
  const factory StartupState({
    StartupDetails? startup,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(0) int selectedTabIndex,
  }) = _StartupState;
}

class StartupCubit extends Cubit<StartupState> {
  final StartupRepository _repository;

  StartupCubit(this._repository) : super(const StartupState());

  Future<void> loadStartupDetails(String startupId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getStartupDetails(startupId);

    result.when(
      success: (startup) {
        emit(state.copyWith(startup: startup, isLoading: false));
      },
      error: (error) {
        emit(state.copyWith(errorMessage: error, isLoading: false));
      },
    );
  }

  void selectTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  void toggleFollow() {
    if (state.startup != null) {
      final updatedStartup = state.startup!.copyWith(
        isFollowing: !state.startup!.isFollowing,
      );
      emit(state.copyWith(startup: updatedStartup));
    }
  }

  void retry() {
    if (state.startup != null) {
      loadStartupDetails(state.startup!.id);
    }
  }
}

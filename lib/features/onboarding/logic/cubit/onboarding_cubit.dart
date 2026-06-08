import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/onboarding_repository.dart';
import '../../data/models/onboarding_model.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingCubit(this._repository) : super(OnboardingInitial()) {
    loadOnboardingData();
  }

  void loadOnboardingData() {
    final items = _repository.getOnboardingItems();
    emit(OnboardingLoaded(items));
  }

  void nextPage(int currentIndex, int totalPages) {
    if (currentIndex < totalPages - 1) {
      emit(OnboardingPageChanged(currentIndex + 1));
    } else {
      emit(OnboardingCompleted());
    }
  }

  void previousPage(int currentIndex) {
    if (currentIndex > 0) {
      emit(OnboardingPageChanged(currentIndex - 1));
    }
  }

  void skipToEnd() {
    emit(OnboardingCompleted());
  }
}

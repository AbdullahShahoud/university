part of 'onboarding_cubit.dart';

abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final List<OnboardingItem> items;

  OnboardingLoaded(this.items);
}

class OnboardingPageChanged extends OnboardingState {
  final int currentPage;

  OnboardingPageChanged(this.currentPage);
}

class OnboardingCompleted extends OnboardingState {}

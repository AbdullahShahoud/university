import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_cubit.freezed.dart';

/// Navigation State
///
/// Manages the current bottom navigation tab index
@freezed
class NavigationState with _$NavigationState {
  const factory NavigationState({@Default(2) int currentIndex}) =
      _NavigationState;
}

/// Navigation Cubit
///
/// Manages bottom navigation state and tab switching
/// No business logic - only navigation state management
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  /// Change to a specific tab by index
  void changeTab(int index) {
    if (index != state.currentIndex) {
      emit(state.copyWith(currentIndex: index));
    }
  }

  /// Get current tab index
  int get currentIndex => 2;

  /// Check if a specific tab is currently selected
  bool isTabSelected(int index) => state.currentIndex == index;
}

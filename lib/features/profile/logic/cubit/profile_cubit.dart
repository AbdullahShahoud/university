import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_cubit.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isDarkTheme,
    @Default('en') String languageCode,
    @Default(true) bool isLoading,
    String? errorMessage,
  }) = _ProfileState;
}

class ProfileCubit extends Cubit<ProfileState> {
  static const String _themeKey = 'app_theme';
  static const String _languageKey = 'app_language';

  ProfileCubit() : super(const ProfileState());

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDarkTheme = prefs.getBool(_themeKey) ?? false;
      final languageCode = prefs.getString(_languageKey) ?? 'en';

      emit(
        state.copyWith(
          isDarkTheme: isDarkTheme,
          languageCode: languageCode,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> toggleTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newTheme = !state.isDarkTheme;
      await prefs.setBool(_themeKey, newTheme);
      emit(state.copyWith(isDarkTheme: newTheme));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> setLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      emit(state.copyWith(languageCode: languageCode));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void retry() {
    loadSettings();
  }
}

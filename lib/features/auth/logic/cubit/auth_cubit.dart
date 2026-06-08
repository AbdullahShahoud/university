import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/repo/auth_repository.dart';
import '../../../../core/networking/token_storage.dart';

part 'auth_cubit.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    @Default(false) bool isLoading,
    String? errorMessage,
    Map<String, dynamic>? userData,
    @Default(false) bool isCodeSent,
    @Default(false) bool isCodeVerified,
    String? resetToken,
  }) = _AuthState;
}

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
  success,
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final TokenStorage _tokenStorage = TokenStorage();

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState());

  Future<void> login({required String email, required String password}) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        isLoading: true,
        errorMessage: null,
      ),
    );

    final result = await _authRepository.login(email, password);

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            isLoading: false,
            userData: data,
            errorMessage: null,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            isLoading: false,
            errorMessage: error.message,
          ),
        );
      },
    );
  }

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        isLoading: true,
        errorMessage: null,
      ),
    );

    final result = await _authRepository.signup(
      fullName,
      email,
      password,
      passwordConfirm,
    );

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            isLoading: false,
            userData: data,
            errorMessage: null,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            isLoading: false,
            errorMessage: error.message,
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading, isLoading: true));

    final refreshToken = await _tokenStorage.getRefreshToken();
    final result = await _authRepository.logout(refreshToken: refreshToken);

    result.when(
      success: (_) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            isLoading: false,
            userData: null,
            errorMessage: null,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            isLoading: false,
            errorMessage: error.message,
          ),
        );
      },
    );
  }

  Future<void> sendResetCode({required String email}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // TODO: Implement when backend endpoint is available
      // For now, emit success state
      emit(state.copyWith(isLoading: false, isCodeSent: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // TODO: Implement when backend endpoint is available
      // For now, emit success state
      emit(
        state.copyWith(
          isLoading: false,
          isCodeVerified: true,
          resetToken: 'mock_reset_token_$email',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // TODO: Implement when backend endpoint is available
      emit(
        state.copyWith(
          isLoading: false,
          status: AuthStatus.success,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> checkAuthStatus() async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      emit(state.copyWith(status: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void resetAuthState() {
    emit(const AuthState());
  }
}

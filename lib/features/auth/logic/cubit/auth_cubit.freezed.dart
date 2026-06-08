// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  AuthStatus get status => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  Map<String, dynamic>? get userData => throw _privateConstructorUsedError;
  bool get isCodeSent => throw _privateConstructorUsedError;
  bool get isCodeVerified => throw _privateConstructorUsedError;
  String? get resetToken => throw _privateConstructorUsedError;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call({
    AuthStatus status,
    bool isLoading,
    String? errorMessage,
    Map<String, dynamic>? userData,
    bool isCodeSent,
    bool isCodeVerified,
    String? resetToken,
  });
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? userData = freezed,
    Object? isCodeSent = null,
    Object? isCodeVerified = null,
    Object? resetToken = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AuthStatus,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            userData: freezed == userData
                ? _value.userData
                : userData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            isCodeSent: null == isCodeSent
                ? _value.isCodeSent
                : isCodeSent // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCodeVerified: null == isCodeVerified
                ? _value.isCodeVerified
                : isCodeVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            resetToken: freezed == resetToken
                ? _value.resetToken
                : resetToken // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
    _$AuthStateImpl value,
    $Res Function(_$AuthStateImpl) then,
  ) = __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AuthStatus status,
    bool isLoading,
    String? errorMessage,
    Map<String, dynamic>? userData,
    bool isCodeSent,
    bool isCodeVerified,
    String? resetToken,
  });
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
    _$AuthStateImpl _value,
    $Res Function(_$AuthStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? userData = freezed,
    Object? isCodeSent = null,
    Object? isCodeVerified = null,
    Object? resetToken = freezed,
  }) {
    return _then(
      _$AuthStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AuthStatus,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        userData: freezed == userData
            ? _value._userData
            : userData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        isCodeSent: null == isCodeSent
            ? _value.isCodeSent
            : isCodeSent // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCodeVerified: null == isCodeVerified
            ? _value.isCodeVerified
            : isCodeVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        resetToken: freezed == resetToken
            ? _value.resetToken
            : resetToken // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AuthStateImpl implements _AuthState {
  const _$AuthStateImpl({
    this.status = AuthStatus.initial,
    this.isLoading = false,
    this.errorMessage,
    final Map<String, dynamic>? userData,
    this.isCodeSent = false,
    this.isCodeVerified = false,
    this.resetToken,
  }) : _userData = userData;

  @override
  @JsonKey()
  final AuthStatus status;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  final Map<String, dynamic>? _userData;
  @override
  Map<String, dynamic>? get userData {
    final value = _userData;
    if (value == null) return null;
    if (_userData is EqualUnmodifiableMapView) return _userData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isCodeSent;
  @override
  @JsonKey()
  final bool isCodeVerified;
  @override
  final String? resetToken;

  @override
  String toString() {
    return 'AuthState(status: $status, isLoading: $isLoading, errorMessage: $errorMessage, userData: $userData, isCodeSent: $isCodeSent, isCodeVerified: $isCodeVerified, resetToken: $resetToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(other._userData, _userData) &&
            (identical(other.isCodeSent, isCodeSent) ||
                other.isCodeSent == isCodeSent) &&
            (identical(other.isCodeVerified, isCodeVerified) ||
                other.isCodeVerified == isCodeVerified) &&
            (identical(other.resetToken, resetToken) ||
                other.resetToken == resetToken));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    isLoading,
    errorMessage,
    const DeepCollectionEquality().hash(_userData),
    isCodeSent,
    isCodeVerified,
    resetToken,
  );

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);
}

abstract class _AuthState implements AuthState {
  const factory _AuthState({
    final AuthStatus status,
    final bool isLoading,
    final String? errorMessage,
    final Map<String, dynamic>? userData,
    final bool isCodeSent,
    final bool isCodeVerified,
    final String? resetToken,
  }) = _$AuthStateImpl;

  @override
  AuthStatus get status;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  Map<String, dynamic>? get userData;
  @override
  bool get isCodeSent;
  @override
  bool get isCodeVerified;
  @override
  String? get resetToken;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'startup_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StartupState {
  StartupDetails? get startup => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  int get selectedTabIndex => throw _privateConstructorUsedError;

  /// Create a copy of StartupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StartupStateCopyWith<StartupState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StartupStateCopyWith<$Res> {
  factory $StartupStateCopyWith(
    StartupState value,
    $Res Function(StartupState) then,
  ) = _$StartupStateCopyWithImpl<$Res, StartupState>;
  @useResult
  $Res call({
    StartupDetails? startup,
    bool isLoading,
    String? errorMessage,
    int selectedTabIndex,
  });

  $StartupDetailsCopyWith<$Res>? get startup;
}

/// @nodoc
class _$StartupStateCopyWithImpl<$Res, $Val extends StartupState>
    implements $StartupStateCopyWith<$Res> {
  _$StartupStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StartupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startup = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? selectedTabIndex = null,
  }) {
    return _then(
      _value.copyWith(
            startup: freezed == startup
                ? _value.startup
                : startup // ignore: cast_nullable_to_non_nullable
                      as StartupDetails?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedTabIndex: null == selectedTabIndex
                ? _value.selectedTabIndex
                : selectedTabIndex // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of StartupState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StartupDetailsCopyWith<$Res>? get startup {
    if (_value.startup == null) {
      return null;
    }

    return $StartupDetailsCopyWith<$Res>(_value.startup!, (value) {
      return _then(_value.copyWith(startup: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StartupStateImplCopyWith<$Res>
    implements $StartupStateCopyWith<$Res> {
  factory _$$StartupStateImplCopyWith(
    _$StartupStateImpl value,
    $Res Function(_$StartupStateImpl) then,
  ) = __$$StartupStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    StartupDetails? startup,
    bool isLoading,
    String? errorMessage,
    int selectedTabIndex,
  });

  @override
  $StartupDetailsCopyWith<$Res>? get startup;
}

/// @nodoc
class __$$StartupStateImplCopyWithImpl<$Res>
    extends _$StartupStateCopyWithImpl<$Res, _$StartupStateImpl>
    implements _$$StartupStateImplCopyWith<$Res> {
  __$$StartupStateImplCopyWithImpl(
    _$StartupStateImpl _value,
    $Res Function(_$StartupStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StartupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startup = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? selectedTabIndex = null,
  }) {
    return _then(
      _$StartupStateImpl(
        startup: freezed == startup
            ? _value.startup
            : startup // ignore: cast_nullable_to_non_nullable
                  as StartupDetails?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedTabIndex: null == selectedTabIndex
            ? _value.selectedTabIndex
            : selectedTabIndex // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$StartupStateImpl implements _StartupState {
  const _$StartupStateImpl({
    this.startup,
    this.isLoading = false,
    this.errorMessage,
    this.selectedTabIndex = 0,
  });

  @override
  final StartupDetails? startup;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final int selectedTabIndex;

  @override
  String toString() {
    return 'StartupState(startup: $startup, isLoading: $isLoading, errorMessage: $errorMessage, selectedTabIndex: $selectedTabIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartupStateImpl &&
            (identical(other.startup, startup) || other.startup == startup) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.selectedTabIndex, selectedTabIndex) ||
                other.selectedTabIndex == selectedTabIndex));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    startup,
    isLoading,
    errorMessage,
    selectedTabIndex,
  );

  /// Create a copy of StartupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartupStateImplCopyWith<_$StartupStateImpl> get copyWith =>
      __$$StartupStateImplCopyWithImpl<_$StartupStateImpl>(this, _$identity);
}

abstract class _StartupState implements StartupState {
  const factory _StartupState({
    final StartupDetails? startup,
    final bool isLoading,
    final String? errorMessage,
    final int selectedTabIndex,
  }) = _$StartupStateImpl;

  @override
  StartupDetails? get startup;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  int get selectedTabIndex;

  /// Create a copy of StartupState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartupStateImplCopyWith<_$StartupStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

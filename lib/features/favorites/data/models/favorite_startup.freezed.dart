// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_startup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FavoriteStartup _$FavoriteStartupFromJson(Map<String, dynamic> json) {
  return _FavoriteStartup.fromJson(json);
}

/// @nodoc
mixin _$FavoriteStartup {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get logoUrl => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;

  /// Serializes this FavoriteStartup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FavoriteStartup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoriteStartupCopyWith<FavoriteStartup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteStartupCopyWith<$Res> {
  factory $FavoriteStartupCopyWith(
    FavoriteStartup value,
    $Res Function(FavoriteStartup) then,
  ) = _$FavoriteStartupCopyWithImpl<$Res, FavoriteStartup>;
  @useResult
  $Res call({
    String id,
    String name,
    String logoUrl,
    String category,
    double rating,
  });
}

/// @nodoc
class _$FavoriteStartupCopyWithImpl<$Res, $Val extends FavoriteStartup>
    implements $FavoriteStartupCopyWith<$Res> {
  _$FavoriteStartupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoriteStartup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoUrl = null,
    Object? category = null,
    Object? rating = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            logoUrl: null == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FavoriteStartupImplCopyWith<$Res>
    implements $FavoriteStartupCopyWith<$Res> {
  factory _$$FavoriteStartupImplCopyWith(
    _$FavoriteStartupImpl value,
    $Res Function(_$FavoriteStartupImpl) then,
  ) = __$$FavoriteStartupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String logoUrl,
    String category,
    double rating,
  });
}

/// @nodoc
class __$$FavoriteStartupImplCopyWithImpl<$Res>
    extends _$FavoriteStartupCopyWithImpl<$Res, _$FavoriteStartupImpl>
    implements _$$FavoriteStartupImplCopyWith<$Res> {
  __$$FavoriteStartupImplCopyWithImpl(
    _$FavoriteStartupImpl _value,
    $Res Function(_$FavoriteStartupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FavoriteStartup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoUrl = null,
    Object? category = null,
    Object? rating = null,
  }) {
    return _then(
      _$FavoriteStartupImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        logoUrl: null == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoriteStartupImpl implements _FavoriteStartup {
  const _$FavoriteStartupImpl({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.category,
    required this.rating,
  });

  factory _$FavoriteStartupImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoriteStartupImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String logoUrl;
  @override
  final String category;
  @override
  final double rating;

  @override
  String toString() {
    return 'FavoriteStartup(id: $id, name: $name, logoUrl: $logoUrl, category: $category, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteStartupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, logoUrl, category, rating);

  /// Create a copy of FavoriteStartup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteStartupImplCopyWith<_$FavoriteStartupImpl> get copyWith =>
      __$$FavoriteStartupImplCopyWithImpl<_$FavoriteStartupImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoriteStartupImplToJson(this);
  }
}

abstract class _FavoriteStartup implements FavoriteStartup {
  const factory _FavoriteStartup({
    required final String id,
    required final String name,
    required final String logoUrl,
    required final String category,
    required final double rating,
  }) = _$FavoriteStartupImpl;

  factory _FavoriteStartup.fromJson(Map<String, dynamic> json) =
      _$FavoriteStartupImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get logoUrl;
  @override
  String get category;
  @override
  double get rating;

  /// Create a copy of FavoriteStartup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoriteStartupImplCopyWith<_$FavoriteStartupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

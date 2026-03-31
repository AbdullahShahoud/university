import 'package:freezed_annotation/freezed_annotation.dart';

part 'startup.freezed.dart';
part 'startup.g.dart';

@freezed
class Startup with _$Startup {
  const factory Startup({
    required String id,
    required String name,
    required String description,
    required String logoUrl,
    required String coverUrl,
    required double rating,
    required int reviewCount,
    required String category,
    required bool isFollowing,
  }) = _Startup;

  factory Startup.fromJson(Map<String, dynamic> json) =>
      _$StartupFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String displayName,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

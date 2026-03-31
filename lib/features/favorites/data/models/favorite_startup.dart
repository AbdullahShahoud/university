import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_startup.freezed.dart';
part 'favorite_startup.g.dart';

@freezed
class FavoriteStartup with _$FavoriteStartup {
  const factory FavoriteStartup({
    required String id,
    required String name,
    required String logoUrl,
    required String category,
    required double rating,
  }) = _FavoriteStartup;

  factory FavoriteStartup.fromJson(Map<String, dynamic> json) =>
      _$FavoriteStartupFromJson(json);
}

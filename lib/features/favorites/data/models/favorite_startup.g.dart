// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_startup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoriteStartupImpl _$$FavoriteStartupImplFromJson(
  Map<String, dynamic> json,
) => _$FavoriteStartupImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  logoUrl: json['logoUrl'] as String,
  category: json['category'] as String,
  rating: (json['rating'] as num).toDouble(),
);

Map<String, dynamic> _$$FavoriteStartupImplToJson(
  _$FavoriteStartupImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logoUrl': instance.logoUrl,
  'category': instance.category,
  'rating': instance.rating,
};

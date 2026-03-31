// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startup_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StartupDetailsImpl _$$StartupDetailsImplFromJson(Map<String, dynamic> json) =>
    _$StartupDetailsImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      logoUrl: json['logoUrl'] as String,
      coverUrl: json['coverUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      category: json['category'] as String,
      isFollowing: json['isFollowing'] as bool,
      website: json['website'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      founded: json['founded'] as String,
      location: json['location'] as String,
      about: json['about'] as String,
      features: (json['features'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      news: (json['news'] as List<dynamic>)
          .map((e) => StartupNews.fromJson(e as Map<String, dynamic>))
          .toList(),
      contacts: (json['contacts'] as List<dynamic>)
          .map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$StartupDetailsImplToJson(
  _$StartupDetailsImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'logoUrl': instance.logoUrl,
  'coverUrl': instance.coverUrl,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'category': instance.category,
  'isFollowing': instance.isFollowing,
  'website': instance.website,
  'email': instance.email,
  'phone': instance.phone,
  'founded': instance.founded,
  'location': instance.location,
  'about': instance.about,
  'features': instance.features,
  'news': instance.news,
  'contacts': instance.contacts,
};

_$StartupNewsImpl _$$StartupNewsImplFromJson(Map<String, dynamic> json) =>
    _$StartupNewsImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      publishedAt: json['publishedAt'] as String,
    );

Map<String, dynamic> _$$StartupNewsImplToJson(_$StartupNewsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'publishedAt': instance.publishedAt,
    };

_$ContactImpl _$$ContactImplFromJson(Map<String, dynamic> json) =>
    _$ContactImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$$ContactImplToJson(_$ContactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'email': instance.email,
      'phone': instance.phone,
      'imageUrl': instance.imageUrl,
    };

import 'package:freezed_annotation/freezed_annotation.dart';

part 'startup_details.freezed.dart';
part 'startup_details.g.dart';

@freezed
class StartupDetails with _$StartupDetails {
  const factory StartupDetails({
    required String id,
    required String name,
    required String description,
    required String logoUrl,
    required String coverUrl,
    required double rating,
    required int reviewCount,
    required String category,
    required bool isFollowing,
    required String website,
    required String email,
    required String phone,
    required String founded,
    required String location,
    required String about,
    required List<String> features,
    required List<StartupNews> news,
    required List<Contact> contacts,
  }) = _StartupDetails;

  factory StartupDetails.fromJson(Map<String, dynamic> json) =>
      _$StartupDetailsFromJson(json);
}

@freezed
class StartupNews with _$StartupNews {
  const factory StartupNews({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required String publishedAt,
  }) = _StartupNews;

  factory StartupNews.fromJson(Map<String, dynamic> json) =>
      _$StartupNewsFromJson(json);
}

@freezed
class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String name,
    required String title,
    required String email,
    required String phone,
    required String imageUrl,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}

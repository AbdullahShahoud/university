// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };

_$AuthApiResponseImpl _$$AuthApiResponseImplFromJson(
  Map<String, dynamic> json,
) => _$AuthApiResponseImpl(
  status: json['status'] as String,
  message: json['message'] as String,
  data: AuthResponse.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$AuthApiResponseImplToJson(
  _$AuthApiResponseImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

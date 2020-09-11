// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Like _$LikeFromJson(Map<String, dynamic> json) {
  return Like(
    id: json['id'] as int,
    user: json['user'] as int,
    post: json['post'] as int,
  );
}

Map<String, dynamic> _$LikeToJson(Like instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'post': instance.post,
    };

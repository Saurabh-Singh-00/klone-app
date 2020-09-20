// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    username: json['username'] as String,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    email: json['email'] as String,
    dob: json['dob'] as String,
    profile: json['profile'] == null
        ? null
        : Profile.fromJson(json['profile'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'dob': instance.dob,
      'profile': instance.profile,
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    id: json['id'] as int,
    followersCount: json['followers_count'] as int,
    followingCount: json['following_count'] as int,
    profilePicture: json['profile_picture'] as String,
    postsCount: json['posts_count'] as int,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': instance.id,
      'followers_count': instance.followersCount,
      'following_count': instance.followingCount,
      'profile_picture': instance.profilePicture,
      'posts_count': instance.postsCount,
    };

Following _$FollowingFromJson(Map<String, dynamic> json) {
  return Following(
    id: json['id'] as int,
    followee: json['followee'] == null
        ? null
        : User.fromJson(json['followee'] as Map<String, dynamic>),
    follower: json['follower'] as int,
  );
}

Map<String, dynamic> _$FollowingToJson(Following instance) => <String, dynamic>{
      'id': instance.id,
      'followee': instance.followee,
      'follower': instance.follower,
    };

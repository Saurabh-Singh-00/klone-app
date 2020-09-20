import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String username;

  @JsonKey(name: 'first_name')
  String firstName;

  @JsonKey(name: 'last_name')
  String lastName;

  String email;
  String dob;
  Profile profile;

  User(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.dob,
      this.profile});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Profile {
  int id;

  @JsonKey(name: 'followers_count')
  int followersCount;

  @JsonKey(name: 'following_count')
  int followingCount;

  @JsonKey(name: 'profile_picture')
  String profilePicture;

  @JsonKey(name: 'posts_count')
  int postsCount;

  Profile(
      {this.id,
      this.followersCount,
      this.followingCount,
      this.profilePicture,
      this.postsCount});

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Following {
  final int id;
  final User followee;
  final int follower;

  Following({this.id, this.followee, this.follower});

  factory Following.fromJson(Map<String, dynamic> json) =>
      _$FollowingFromJson(json);

  Map<String, dynamic> toJson() => _$FollowingToJson(this);
}

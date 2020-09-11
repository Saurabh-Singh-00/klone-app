import 'package:json_annotation/json_annotation.dart';
import 'package:zingo/models/user.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  int id;
  User user;
  String image;
  String caption;

  @JsonKey(name: 'likes_count')
  int likesCount;

  @JsonKey(name: 'comments_count')
  int commentsCount;

  @JsonKey(name: 'created_at')
  String createdAt;

  Post(
      {this.id,
      this.user,
      this.image,
      this.caption,
      this.likesCount,
      this.commentsCount,
      this.createdAt});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

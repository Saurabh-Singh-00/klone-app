import 'package:json_annotation/json_annotation.dart';
import 'package:zingo/models/user.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  int id;
  User user;
  String text;

  @JsonKey(name: 'date_time')
  String dateTime;
  int post;

  Comment({this.id, this.user, this.text, this.dateTime, this.post});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

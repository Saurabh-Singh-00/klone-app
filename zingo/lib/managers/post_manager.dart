import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:zingo/managers/manager.dart';
import 'package:zingo/models/comment.dart';
import 'package:zingo/models/user.dart';
import 'package:zingo/services/api.dart';

class PostManager extends Manager {
  API api = API();

  Future<List> fetchPosts(
      {@required int userId,
      @required String authToken,
      @required String type}) async {
    List posts = await api.get([
      'user-profile',
      userId.toString(),
      type,
    ], headers: api.getTokenAuthHeader(token: authToken)) as List;
    print(posts);
    return posts;
  }

  Future addPost({
    User user,
    File image,
    String caption,
    String authToken,
  }) async {
    await api.postMultiPartFormData([
      'user-profile',
      user.id.toString(),
      'post'
    ], {
      'image': image,
      'caption': caption,
    }, api.getTokenAuthHeader(token: authToken));
  }

  Future<int> likePost(String postId, int userId, String authToken) async {
    Map l = await api.post([
      'user-profile',
      userId.toString(),
      'post',
      postId,
      'like'
    ], {
      'post': postId
    }, headers: api.getTokenAuthHeader(token: authToken)) as Map;
    return l['id'];
  }

  Future dislikePost(
      String postId, int userId, int likeId, String authToken) async {
    api.delete([
      'user-profile',
      userId.toString(),
      'post',
      postId,
      'like',
      likeId.toString()
    ], api.getTokenAuthHeader(token: authToken));
  }

  Future<List> fetchPostLikes(int userId, int postId, String authToken) async {
    List users = await api.get(
        ['user-profile', userId.toString(), 'post', postId.toString(), 'like'],
        headers: api.getTokenAuthHeader(token: authToken)) as List;
    return users.map((u) => User.fromJson(u['user'])).toList();
  }

  Future<List<Comment>> fetchPostComments(
      int userId, int postId, String authToken) async {
    List comments = await api.get([
      'user-profile',
      userId.toString(),
      'post',
      postId.toString(),
      'comment'
    ], headers: api.getTokenAuthHeader(token: authToken)) as List;
    return comments.map((c) => Comment.fromJson(c)).toList();
  }

  Future addComment(int userId, int postId, Map body, String authToken) async {
    return await api.post([
      'user-profile',
      userId.toString(),
      'post',
      postId.toString(),
      'comment'
    ], body, headers: api.getTokenAuthHeader(token: authToken));
    // return Comment.fromJson(comm);
  }
}

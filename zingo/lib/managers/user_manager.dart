import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:zingo/managers/manager.dart';
import 'package:zingo/models/like.dart';
import 'package:zingo/models/post.dart';
import 'package:zingo/models/user.dart';
import 'package:zingo/services/api.dart';
import 'package:zingo/services/preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserManager extends Manager {
  User user;
  HashMap<int, int> likedPosts = HashMap<int, int>();
  HashMap<int, User> userFollowers = HashMap<int, User>();
  HashMap<int, User> userFollowing = HashMap<int, User>();
  List<Post> userPosts = [];
  API api = API();
  BehaviorSubject<User> user$ = BehaviorSubject<User>();
  BehaviorSubject<List<Post>> userPosts$ = BehaviorSubject<List<Post>>();
  BehaviorSubject<List<Post>> userFeeds$ = BehaviorSubject<List<Post>>();
  BehaviorSubject<HashMap<int, int>> userLikedPost$ =
      BehaviorSubject<HashMap<int, int>>();
  BehaviorSubject<List<Post>> explorePosts$ = BehaviorSubject<List<Post>>();

  UserManager() {
    user$.stream.listen(saveUser);
    userPosts$.listen(saveUserPosts);
  }

  Future logout() async {
    await api.post(['logout'], {'token': Preferences.authToken},
        headers: api.getTokenAuthHeader(token: Preferences.authToken));
    await Preferences.deleteAuthToken('token');
  }

  void saveUserPosts(List<Post> posts) => this.userPosts.addAll(posts);

  void saveUser(User _user) {
    this.user = _user;
    fetchUserLikedPost();
    fetchUserFeeds();
    fetchUserPosts();
    fetchUserFollowers();
    explorePosts();
  }

  Future<Map> authenticate(String type,
      {Map<String, String> credentials}) async {
    Map response = await api.post([type], credentials, headers: {}) as Map;
    Map result = Map();
    print(response);
    if (response.containsKey('key')) {
      result['success'] = true;
      result['key'] = response['key'];
    } else if (response.containsKey('non_field_errors')) {
      result['success'] = false;
      result['message'] = response['non_field_errors'];
    } else if (response.containsKey('email')) {
      result['success'] = false;
      result['message'] = response['email'];
    } else if (response.containsKey('username')) {
      result['success'] = false;
      result['message'] = response['username'];
    }
    return result;
  }

  void loadUserProfile() {
    // Load logged in user profile
    api.get(['user'],
        headers:
            api.getTokenAuthHeader(token: Preferences.authToken)).then((json) {
      user$.sink.add(User.fromJson(json as Map));
    });
  }

  void fetchUserPosts() {
    api.get(['user-profile', user.id.toString(), 'post'],
        headers:
            api.getTokenAuthHeader(token: Preferences.authToken)).then((json) {
      List<Post> posts = [];
      for (Map post in json as List) {
        posts.add(Post.fromJson(post));
      }
      userPosts$.sink.add(posts);
    });
  }

  void fetchUserFeeds() {
    api.get(['user-profile', user.id.toString(), 'feed'],
        headers:
            api.getTokenAuthHeader(token: Preferences.authToken)).then((json) {
      List<Post> posts = [];
      for (Map post in json as List) {
        posts.add(Post.fromJson(post));
      }
      userFeeds$.sink.add(posts);
    });
  }

  void fetchUserLikedPost() {
    api.get(['user-profile', user.id.toString(), 'like'],
        headers:
            api.getTokenAuthHeader(token: Preferences.authToken)).then((json) {
      for (Map like in json as List) {
        Like l = Like.fromJson(like);
        likedPosts.addAll({l.post: l.id});
      }
      userLikedPost$.sink.add(likedPosts);
    });
  }

  void fetchUserFollowers() {
    api.get(['user-profile', user.id.toString(), 'follower'],
        headers: api.getTokenAuthHeader(
            token: Preferences.authToken)).then((followers) {
      for (Map record in followers as List) {
        User user = User.fromJson(record['follower']);
        userFollowers.addAll({user.id: user});
      }
    });
  }

  Future addFollower(int followeeId) async {
    Map record = await api.post([
      'user-profile',
      this.user.id.toString(),
      'follower'
    ], {
      'follower': this.user.id.toString(),
      'followee': followeeId.toString(),
    }, headers: api.getTokenAuthHeader(token: Preferences.authToken));
    User user = User.fromJson(record['follower']);
  }

  void fetchUserFollowing() {}

  Future<List<User>> searchUser(String query) async {
    Uri uri = Uri.http(
        '${API.EMU_URL}:8000', 'api/v1/search/', {'user': '$query'});
    http.Response response = await http.get(uri,
        headers: api.getTokenAuthHeader(token: Preferences.authToken));
    List _users = [];
    if (response.statusCode == 200) {
      _users = json.decode(response.body) as List;
    }
    return _users.map((u) => User.fromJson(u)).toList();
  }

  Future explorePosts() async {
    api.get(['user-profile', user.id.toString(), 'explore'],
        headers:
            api.getTokenAuthHeader(token: Preferences.authToken)).then((json) {
      List<Post> posts = [];
      for (Map post in json as List) {
        posts.add(Post.fromJson(post));
      }
      explorePosts$.sink.add(posts);
    });
  }

  Future updateUserProfilePicture(File image) async {
    api.postMultiPartFormData(
        ['user-profile', '${user.id}', 'profile', '${user.profile.id}'],
        {'image': image},
        api.getTokenAuthHeader(token: Preferences.authToken),
        requestType: "PATCH",
        key: 'profile_picture');
  }

  void loadUserProfileById(int userId) {
    // Load logged in user profile
    api.get(['user'],
        headers:
            api.getTokenAuthHeader(token: Preferences.authToken)).then((json) {
      user$.sink.add(User.fromJson(json as Map));
    });
  }

  Future<List<Post>> fetchUserPostsById(int userId) async {
    List<Post> posts = [];
    await api.get(['user-profile', userId.toString(), 'post'],
        headers:
            api.getTokenAuthHeader(token: Preferences.authToken)).then((json) {
      for (Map post in json as List) {
        posts.add(Post.fromJson(post));
      }
    });
    return posts;
  }

  @override
  void close() {
    user$.close();
    userPosts$.close();
    userFeeds$.close();
    userLikedPost$.close();
    explorePosts$.close();
    super.close();
  }
}

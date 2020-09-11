import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/models/post.dart';
import 'package:zingo/models/user.dart';
import 'package:zingo/widgets/post_card.dart';
import 'package:zingo/widgets/stream_observer.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool gridOn = true;

  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);

    return RefreshIndicator(
      onRefresh: () async {
        userManager.loadUserProfile();
      },
      child: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    child: StreamObserver(
                        onSuccess: (BuildContext context, User user) {
                          return CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.125,
                            backgroundImage:
                                NetworkImage(user.profile.profilePicture),
                          );
                        },
                        stream: userManager.user$),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StreamObserver(
                        stream: userManager.user$,
                        onSuccess: (BuildContext context, User user) => Text(
                          "${userManager.user.firstName} ${userManager.user.lastName}",
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/edit_profile');
                            },
                            color: Colors.greenAccent,
                            splashColor: Colors.white70,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                32.0,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  UserStats(
                    data: userManager.user != null
                        ? userManager.user.profile.postsCount
                        : 0,
                    label: "Posts",
                  ),
                  UserStats(
                    data: userManager.user != null
                        ? userManager.user.profile.followersCount
                        : 0,
                    label: "Followers",
                  ),
                  UserStats(
                    data: userManager.user != null
                        ? userManager.user.profile.followingCount
                        : 0,
                    label: "Following",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: gridOn
                          ? BorderSide(
                              color: Colors.greenAccent,
                              width: 2.0,
                            )
                          : BorderSide.none,
                    )),
                    child: IconButton(
                        icon: Icon(
                          Icons.grid_on,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            gridOn = true;
                          });
                        }),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: !gridOn
                          ? BorderSide(
                              color: Colors.greenAccent,
                              width: 2.0,
                            )
                          : BorderSide.none,
                    )),
                    child: IconButton(
                        icon: Icon(
                          Icons.grid_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            gridOn = false;
                          });
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: gridOn ? PostGridViewBuilder() : PostListViewBuilder(),
            ),
          ],
        ),
      ),
    );
  }
}

class PostListViewBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    return StreamObserver(
        stream: userManager.userPosts$.stream,
        onWaiting: (BuildContext context) => Center(
              child: CircularProgressIndicator(),
            ),
        onSuccess: (BuildContext context, List<Post> posts) {
          if (posts.length == 0) {
            return Center(
              child: Text(
                "No Posts Yet!",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            physics: BouncingScrollPhysics(),
            addAutomaticKeepAlives: true,
            itemBuilder: (BuildContext context, int index) {
              return PostCard(
                post: posts[index],
                isSelfCard: true,
              );
            },
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: posts.length,
          );
        });
  }
}

class PostGridViewBuilder extends StatelessWidget {
  const PostGridViewBuilder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    return StreamObserver(
        stream: userManager.userPosts$.stream,
        onWaiting: (BuildContext context) => Center(
              child: CircularProgressIndicator(),
            ),
        onSuccess: (BuildContext context, List<Post> posts) {
          if (posts.length == 0) {
            return Center(
              child: Text(
                "No Posts Yet!",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return StaggeredGridView.countBuilder(
            physics: BouncingScrollPhysics(),
            crossAxisCount: 3,
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            staggeredTileBuilder: (int index) {
              if (index % 9 == 0 || index % 9 == 7)
                return StaggeredTile.count(1, 1);
              if (index % 9 == 1 || index % 9 == 6)
                return StaggeredTile.count(2, 2);
              if (index % 9 == 2 || index % 9 == 8)
                return StaggeredTile.count(1, 1);
              return StaggeredTile.count(1, 1);
            },
            addAutomaticKeepAlives: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onLongPress: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return Center(
                          child: Material(
                            color: Colors.transparent,
                            child: PostCard(
                              post: posts[index],
                              isSelfCard: true,
                            ),
                          ),
                        );
                      });
                },
                child: Image.network(
                  posts[index].image,
                  fit: BoxFit.cover,
                ),
              );
            },
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: posts.length,
          );
        });
  }
}

class UserStats extends StatelessWidget {
  final int data;
  final String label;

  const UserStats({Key key, this.data, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "$data",
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            "$label",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

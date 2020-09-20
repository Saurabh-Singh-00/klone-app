import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/models/post.dart';
import 'package:zingo/models/user.dart';
import 'package:zingo/pages/user_list_page.dart';
import 'package:zingo/widgets/post_card.dart';

class ProfileDetailPage extends StatefulWidget {
  final User user;

  const ProfileDetailPage({Key key, this.user}) : super(key: key);

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.user.username}'s Profile"),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: RefreshIndicator(
        onRefresh: () async {
          userManager.loadUserProfileById(widget.user.id);
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.125,
                        backgroundImage: NetworkImage(
                          widget.user.profile.profilePicture,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${widget.user.firstName} ${widget.user.lastName}",
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            child: RaisedButton(
                              onPressed: userManager.userFollowing
                                      .containsKey(widget.user.id)
                                  ? () async {
                                      await userManager
                                          .removeFollowing(widget.user.id);
                                      setState(() {});
                                    }
                                  : () async {
                                      await userManager.addFollower(
                                        widget.user.id,
                                        widget.user,
                                      );
                                      setState(() {});
                                    },
                              color: Colors.white,
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
                                  userManager.userFollowing
                                          .containsKey(widget.user.id)
                                      ? 'Unfollow'
                                      : 'Follow',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.deepOrangeAccent,
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
                      data: widget.user.profile.postsCount,
                      label: "Posts",
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserListPage(
                              appBarTitle: "Followers",
                              type: "follower",
                              userId: widget.user.id,
                            ),
                          ),
                        );
                      },
                      child: UserStats(
                        data: widget.user.profile.followersCount,
                        label: "Followers",
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserListPage(
                              appBarTitle: "Followings",
                              type: "following",
                              userId: widget.user.id,
                            ),
                          ),
                        );
                      },
                      child: UserStats(
                        data: widget.user.profile.followingCount,
                        label: "Following",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: PostListViewBuilder(
                  userId: widget.user.id,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostListViewBuilder extends StatelessWidget {
  final int userId;

  const PostListViewBuilder({Key key, this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    return FutureBuilder(
        future: userManager.fetchUserPostsById(userId),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> posts) {
          if (posts.hasData) {
            if (posts.data.length == 0) {
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
                  post: posts.data[index],
                );
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: posts.data.length,
            );
          } else if (posts.hasError) {
            return Center(
              child: Text(
                "Oops Some Error occured!",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.deepOrangeAccent),
            ),
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

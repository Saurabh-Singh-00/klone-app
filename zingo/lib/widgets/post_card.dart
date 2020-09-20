import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/post_manager.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/models/post.dart';
import 'package:zingo/pages/post_comments_page.dart';
import 'package:zingo/pages/post_likes_page.dart';
import 'package:zingo/pages/profile_detail_page.dart';
import 'package:zingo/services/preferences.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final bool isSelfCard;

  const PostCard({Key key, this.post, this.isSelfCard}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(revertBack);
    animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);
  }

  void revertBack(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    } else if (status == AnimationStatus.forward) {}
  }

  animate() {
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    PostManager postManager = Provider.of<AppBLoC>(context).fetch(PostManager);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            onTap: () {
              if (widget.isSelfCard == null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext _) => ProfileDetailPage(
                              user: widget.post.user,
                            )));
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ProfilePic(
                    profilePicUrl: widget.post != null
                        ? widget.post.user.profile.profilePicture
                        : null,
                  ),
                  UserInfo(
                    name:
                        widget.post != null ? widget.post.user.username : null,
                    time: widget.post != null
                        ? DateFormat.yMMMMd('en_US')
                            .format(DateTime.parse(widget.post.createdAt))
                        : "Some Time Ago",
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(
              widget.post != null ? "${widget.post.caption}" : """""",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onDoubleTap: () async {
                if (userManager.likedPosts.containsKey(widget.post.id)) {
                  int likeId = userManager.likedPosts[widget.post.id];
                  await postManager.dislikePost(widget.post.id.toString(),
                      userManager.user.id, likeId, Preferences.authToken);
                  userManager.likedPosts.remove(widget.post.id);
                  widget.post.likesCount -= 1;
                } else {
                  animate();
                  int id = await postManager.likePost(widget.post.id.toString(),
                      userManager.user.id, Preferences.authToken);
                  userManager.likedPosts.addAll({widget.post.id: id});
                  widget.post.likesCount += 1;
                }
                setState(() {});
              },
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  fit: StackFit.expand,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.post != null
                            ? widget.post.image
                            : 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.white60,
                      size: MediaQuery.of(context).size.width *
                          0.5 *
                          animationController.value,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext _) => PostLikesPage(
                                postId: widget.post.id,
                              )));
                    },
                    child: Icon(
                      Icons.favorite,
                      color: userManager.likedPosts.containsKey(widget.post.id)
                          ? Colors.redAccent
                          : Colors.white70,
                      size: 24.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    widget.post != null
                        ? widget.post.likesCount.toString()
                        : "0",
                    style: TextStyle(color: Colors.white70, fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext _) => PostCommentsPage(
                                postId: widget.post.id,
                                post: widget.post,
                              )));
                    },
                    child: Icon(
                      FontAwesomeIcons.facebookMessenger,
                      color: Colors.white70,
                      size: 24.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    widget.post != null
                        ? widget.post.commentsCount.toString()
                        : "0",
                    style: TextStyle(color: Colors.white70, fontSize: 16.0),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final String name, time;
  const UserInfo({
    Key key,
    this.name,
    this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "$name",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
          ),
          Text(
            "$time",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white70,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  final String profilePicUrl;
  const ProfilePic({
    Key key,
    this.profilePicUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: CircleAvatar(
        backgroundImage: NetworkImage(
          profilePicUrl ?? 'https://randomuser.me/api/portraits/men/1.jpg',
        ),
      ),
    );
  }
}

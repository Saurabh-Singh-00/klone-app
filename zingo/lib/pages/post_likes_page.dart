import 'package:flutter/material.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/post_manager.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/services/preferences.dart';

class PostLikesPage extends StatelessWidget {
  final int postId;

  const PostLikesPage({Key key, this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostManager postManager = Provider.of<AppBLoC>(context).fetch(PostManager);
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    return Scaffold(
      appBar: AppBar(
        title: Text("Likes"),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: FutureBuilder(
          future: postManager.fetchPostLikes(
              userManager.user.id, postId, Preferences.authToken),
          builder: (BuildContext context, AsyncSnapshot<List> snap) {
            if (snap.hasData) {
              if (snap.data.length == 0) {
                return Center(
                  child: Text(
                    "No Likes for the Post",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            snap.data[index].profile.profilePicture,
                          ),
                        ),
                        title: Text(
                          "${snap.data[index].firstName} ${snap.data[index].lastName}",
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          "@${snap.data[index].username}",
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    });
              }
            } else if (snap.hasError) {
              return Center(
                child: Text(
                  "Oops some Error occured!",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.deepOrangeAccent),
              ),
            );
          }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/post_manager.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/models/comment.dart';
import 'package:zingo/models/post.dart';
import 'package:zingo/services/preferences.dart';

class PostCommentsPage extends StatefulWidget {
  final int postId;
  final Post post;
  const PostCommentsPage({Key key, this.postId, this.post}) : super(key: key);

  @override
  _PostCommentsPageState createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends State<PostCommentsPage> {
  final TextEditingController commentTEC = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    PostManager postManager = Provider.of<AppBLoC>(context).fetch(PostManager);
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
              future: postManager.fetchPostComments(
                  userManager.user.id, widget.postId, Preferences.authToken),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Comment>> snap) {
                if (snap.hasData) {
                  if (snap.data.length == 0) {
                    return Center(
                      child: Text(
                        "No Comments for the Post",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snap.data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                snap.data[index].user.profile.profilePicture,
                              ),
                            ),
                            title: Text(
                              "${snap.data[index].text}",
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "@${snap.data[index].user.username}",
                              style: TextStyle(color: Colors.white54),
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
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Form(
                  key: key,
                  child: TextFormField(
                    controller: commentTEC,
                    validator: (value) =>
                        value == "" ? "Field Required *" : null,
                    maxLength: 300,
                    maxLines: 2,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CircleAvatar(
                          radius: 8.0,
                          backgroundImage: NetworkImage(
                            userManager.user.profile.profilePicture,
                          ),
                        ),
                      ),
                      hintMaxLines: 3,
                      hintText: "Add Comment",
                      suffix: FlatButton(
                          onPressed: () async {
                            if (key.currentState.validate()) {
                              await postManager.addComment(
                                  userManager.user.id,
                                  widget.postId,
                                  {
                                    'post': widget.postId.toString(),
                                    'text': commentTEC.text
                                  },
                                  Preferences.authToken);
                              setState(() {});
                              widget.post.commentsCount += 1;
                              commentTEC.clear();
                            }
                          },
                          child: Text(
                            "Post",
                            style: TextStyle(color: Colors.deepOrangeAccent),
                          )),
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

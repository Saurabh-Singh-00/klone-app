import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/post_manager.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/services/preferences.dart';

class AddPostPage extends StatefulWidget {
  final File image;

  const AddPostPage({Key key, this.image}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController captionTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    PostManager postManager = Provider.of<AppBLoC>(context).fetch(PostManager);
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: TextFormField(
                controller: captionTEC,
                validator: (value) => value == "" ? "Field Required *" : null,
                maxLength: 300,
                maxLines: 3,
                decoration: InputDecoration(                  
                  hintMaxLines: 3,                  
                  hintText: "Add some Caption",
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Container(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () async {
                    await postManager.addPost(
                        user: userManager.user,
                        authToken: Preferences.authToken,
                        caption: captionTEC.text,
                        image: widget.image);
                    userManager.user.profile.postsCount += 1;
                    userManager.fetchUserPosts();
                    Navigator.of(context).pop();
                  },
                  color: Colors.deepOrange,
                  splashColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      32.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

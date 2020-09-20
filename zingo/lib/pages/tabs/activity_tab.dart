import 'package:flutter/material.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/models/post.dart';
import 'package:zingo/models/user.dart';
import 'package:zingo/pages/profile_detail_page.dart';

class ActivityTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    return Container(
      child: FutureBuilder<List>(
        initialData: [],
        future: userManager.fetchActivitiesOnUserPost(),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  "No Activities on your post",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.separated(
              itemBuilder: (context, index) {
                User user = User.fromJson(snapshot.data[index]['user']);
                Post post = Post.fromJson(snapshot.data[index]['post']);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.profile.profilePicture,
                    ),
                  ),
                  title: Text(
                    "@${user.username} Liked your post.",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: ClipRRect(
                    child: Image.network(
                      post.image,
                      height: 32.0,
                      width: 32.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileDetailPage(
                        user: user,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data.length,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error - ${snapshot.error.toString()}"),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

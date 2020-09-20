import 'package:flutter/material.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/models/user.dart';
import 'package:zingo/pages/profile_detail_page.dart';

class UserListPage extends StatelessWidget {
  final String appBarTitle, type;
  final int userId;

  const UserListPage({Key key, this.appBarTitle, this.type, this.userId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: FutureBuilder<List<User>>(
        initialData: [],
        future: type == "follower"
            ? userManager.fetchUserFollowersById(userId)
            : userManager.fetchUserFollowingsById(userId),
        builder: (context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  "No $type",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        snapshot.data[index].profile.profilePicture),
                  ),
                  title: Text(
                    "${snapshot.data[index].firstName} ${snapshot.data[index].lastName}",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text("${snapshot.data[index].username}",
                      style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileDetailPage(user: snapshot.data[index]),
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

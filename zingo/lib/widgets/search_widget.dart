import 'package:flutter/material.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/models/user.dart';
import 'package:zingo/pages/profile_detail_page.dart';

class Search extends SearchDelegate {
  final UserManager userManager;

  Search(this.userManager);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        textTheme: Theme.of(context)
            .textTheme
            .copyWith(headline6: TextStyle(color: Colors.white)),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
        appBarTheme: AppBarTheme.of(context).copyWith(
          textTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.white),
              subtitle1: TextStyle(color: Colors.white)),
        ));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          close(context, null);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: userManager.searchUser(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text("No such user!"),
            );
          }
          return Container(
            color: Theme.of(context).primaryColorDark,
            child: ListView.builder(
              itemCount: snapshot.data.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext _) => ProfileDetailPage(
                                  user: snapshot.data[index],
                                )));
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      snapshot.data[index].profile.profilePicture,
                    ),
                  ),
                  title: Text(
                    "${snapshot.data[index].firstName} ${snapshot.data[index].lastName}",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text("@${snapshot.data[index].username}",
                      style: TextStyle(color: Colors.white)),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Oops Some Error Occured!"),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorDark,
      child: Center(
        child: Text(
          "Search with username, First Name or Last Name",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

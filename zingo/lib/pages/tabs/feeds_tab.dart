import 'package:flutter/material.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/models/post.dart';
import 'package:zingo/widgets/post_card.dart';
import 'package:zingo/widgets/stream_observer.dart';

class FeedsTab extends StatefulWidget {
  @override
  _FeedsTabState createState() => _FeedsTabState();
}

class _FeedsTabState extends State<FeedsTab> {
  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    return RefreshIndicator(
      onRefresh: () async {
        userManager.fetchUserFeeds();
      },
      child: StreamObserver<List<Post>>(
        stream: userManager.userFeeds$.stream,
        onSuccess: (context, List<Post> snapshot) {
          if (snapshot.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Follow more users to see feeds",
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        userManager.fetchUserFeeds();
                      })
                ],
              ),
            );
          }
          return ListView.builder(
              key: PageStorageKey('feeds_list'),
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.length,
              itemBuilder: (BuildContext context, int index) {
                return PostCard(
                  post: snapshot[index],
                );
              });
        },
        onWaiting: (BuildContext context) => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.deepOrangeAccent),
          ),
        ),
      ),
    );
  }
}

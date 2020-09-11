import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/models/post.dart';
import 'package:zingo/widgets/post_card.dart';
import 'package:zingo/widgets/stream_observer.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    return RefreshIndicator(
      onRefresh: () async {
        userManager.explorePosts();
      },
      child: Container(
        child: StreamObserver(
            stream: userManager.explorePosts$.stream,
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
                key: PageStorageKey('explore_grid'),
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
            }),
      ),
    );
  }
}

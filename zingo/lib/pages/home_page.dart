import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/pages/tabs/activity_tab.dart';
import 'package:zingo/pages/tabs/feeds_tab.dart';
import 'package:zingo/pages/tabs/profile_tab.dart';
import 'package:zingo/pages/tabs/search_tab.dart';
import 'package:zingo/widgets/search_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController tabController;
  UserManager userManager;
  List<String> pageTitle = ['Feeds', 'Search', 'Camera', 'Likes', 'Profile'];
  @override
  void initState() {
    tabController = TabController(vsync: this, length: pageTitle.length, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle[tabController.index]),
        elevation: .0,
        actions: tabController.index == 1
            ? <Widget>[
                IconButton(
                    icon: Icon(FontAwesomeIcons.search),
                    onPressed: () {
                      showSearch(
                          context: context,
                          query: '',
                          delegate: Search(Provider.of<AppBLoC>(context)
                              .fetch(UserManager)));
                    })
              ]
            : <Widget>[],
      ),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          FeedsTab(),
          SearchTab(),
          Container(),
          ActivityTab(),
          ProfileTab(),
        ],
      ),
      extendBodyBehindAppBar: false,
      backgroundColor: Theme.of(context).primaryColorDark,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColorDark,
        elevation: 2.0,
        selectedItemColor: Colors.deepOrangeAccent,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        iconSize: 24.0,
        unselectedItemColor: Colors.white30,
        currentIndex: tabController.index,
        onTap: (int index) {
          if (index == 2) {
            Navigator.of(context).pushNamed('/camera');
          } else {
            setState(() {
              tabController.index = index;
            });
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.battleNet),
            title: Text("Feeds"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.search),
            title: Text("Search"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.plusCircle),
            title: Text("Camera"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidBell),
            title: Text("Notifications"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidUserCircle),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

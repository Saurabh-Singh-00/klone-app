import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/services/preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  UserManager userManager;

  @override
  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  Future<Null> checkIsLoggedIn() async {
    await Preferences.loadAuthToken();
    if (Preferences.authToken == null || Preferences.authToken == "") {
      Navigator.of(context).pushReplacementNamed('/welcome');
    } else {
      if (userManager != null) {
        userManager.loadUserProfile();
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/battle_net.png',
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
            ),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
          ),
        ],
      ),
    );
  }
}

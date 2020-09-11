import 'package:flutter/material.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/post_manager.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/pages/edit_profile_page.dart';
import 'package:zingo/pages/home_page.dart';
import 'package:zingo/pages/login_page.dart';
import 'package:zingo/pages/signup_page.dart';
import 'package:zingo/pages/splash_page.dart';
import 'package:zingo/pages/tabs/camera_tab.dart';
import 'package:zingo/pages/welcome_page.dart';
import 'package:zingo/themes/zingo_dark.dart';

void main() => runApp(Zingo());

class Zingo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AppBLoC>(
      bloc: AppBLoC(
        managers: {
          UserManager: UserManager(),
          PostManager: PostManager(),
        },
      ),
      child: MaterialApp(
        title: "Klone",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'ProductSans',
          primarySwatch: ZingoDarkTheme.primarySwatch,
        ),
        home: SplashPage(),
        routes: {
          '/welcome': (BuildContext _) => WelcomePage(),
          '/login': (BuildContext _) => LoginPage(),
          '/home': (BuildContext _) => HomePage(),
          '/camera': (BuildContext _) => CameraTab(),
          '/edit_profile': (BuildContext _) => EditProfilePage(),
          '/sign_up': (BuildContext _) => SignUpPage(),
        },
      ),
    );
  }
}

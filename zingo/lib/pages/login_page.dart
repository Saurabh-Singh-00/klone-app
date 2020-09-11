import 'package:flutter/material.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/services/preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  bool isLoggingIn = false;

  bool isFormValid() {
    return formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        Positioned.fill(
          child: Container(
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black38,
                  Colors.black54,
                  Colors.black87,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Image.asset(
              'images/welcome_page_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: .0,
            ),
            backgroundColor: Colors.transparent,
            body: Center(
              child: Form(
                key: formKey,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'Welcome back!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 32.0),
                      child: Text(
                        'We are happy to see you again',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: TextFormField(
                        controller: usernameTEC,
                        validator: (value) =>
                            value == "" ? "Field Required *" : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          hintText: "Username / Email",
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 28.0, vertical: 18.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: TextFormField(
                        controller: passwordTEC,
                        validator: (value) =>
                            value == "" ? "Field Required *" : null,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          hintText: "Password",
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 28.0, vertical: 18.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        width: double.infinity,
                        child: Builder(builder: (context) {
                          return RaisedButton(
                            onPressed: isLoggingIn
                                ? () {}
                                : () async {
                                    Map res = Map();
                                    if (isFormValid()) {
                                      setState(() {
                                        isLoggingIn = true;
                                      });
                                      res = await userManager.authenticate(
                                        'login',
                                        credentials: {
                                          'username': usernameTEC.text,
                                          'password': passwordTEC.text,
                                        },
                                      );
                                      setState(() {
                                        isLoggingIn = false;
                                      });
                                      if (res.containsKey('key')) {
                                        await Preferences.saveAuthToken(
                                            res['key']);
                                        userManager.loadUserProfile();
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/home',
                                            (Route predicate) => false);
                                      } else {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              res['message'][0].toString()),
                                          duration: Duration(seconds: 3),
                                        ));
                                      }
                                    }
                                  },
                            color: Colors.white,
                            splashColor: Colors.white70,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                32.0,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: !isLoggingIn
                                  ? Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.deepOrange,
                                      ),
                                    )
                                  : CircularProgressIndicator(),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

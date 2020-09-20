import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/login_page_bg.jpg'),
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black26,
                      Colors.black54,
                      Colors.black87,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        "Find new friends nearby",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 44.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        "With millions of users all over the world, we give you the ability to connect with people no matter where you are.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Container(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          color: Colors.white,
                          splashColor: Colors.white30,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              32.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Container(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/sign_up');
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
                              'Sign Up',
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
            )
          ],
        ),
      ),
    );
  }
}

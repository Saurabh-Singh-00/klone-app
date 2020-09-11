import 'package:flutter/material.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/widgets/text_editing_field.dart';
import 'package:zingo/services/preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController firstNameTEC = TextEditingController();
  TextEditingController lastNameTEC = TextEditingController();

  bool isLoggingIn = false;

  bool isFormValid() {
    return formKey.currentState.validate();
  }

  Map<String, String> submitForm() {
    Map<String, String> form = {
      'email': emailTEC.text.trim(),
      'username': usernameTEC.text.trim(),
      'password1': passwordTEC.text.trim(),
      'password2': passwordTEC.text.trim(),
      'first_name': firstNameTEC.text.trim(),
      'last_name': lastNameTEC.text.trim(),
    };
    print(form);
    return form;
  }

  @override
  void initState() {
    super.initState();
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
              'images/signup_page_bg.jpg',
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
                        'Hii there!',
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
                        'Join us on this exciting journey.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    TextEditingField(
                      controller: emailTEC,
                      value: emailTEC.value.text,
                      hintText: "Email ID",
                      isRequired: true,
                      validationText: "Email Field is Required *",
                      onChanged: (value) {
                        emailTEC.text = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Field Required";
                        } else {
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return "Invalid input";
                          }
                        }
                        return null;
                      },
                    ),
                    TextEditingField(
                      controller: passwordTEC,
                      onChanged: (value) {
                        passwordTEC.text = value;
                      },
                      hintText: "Password",
                      isRequired: true,
                      isPassword: true,
                      validationText: "Password is Required *",
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Field Required";
                        } else {
                          if (value.length < 8) {
                            return "Length of password should be atleast 8 characters";
                          }
                        }
                        return null;
                      },
                    ),
                    TextEditingField(
                      controller: firstNameTEC,
                      hintText: "First Name",
                      onChanged: (value) {
                        firstNameTEC.text = value;
                      },
                      value: firstNameTEC.value.text,
                      isRequired: true,
                      validationText: "First Name is Required *",
                    ),
                    TextEditingField(
                      controller: lastNameTEC,
                      hintText: "Last Name",
                      onChanged: (value) {
                        lastNameTEC.text = value;
                      },
                      value: lastNameTEC.value.text,
                      isRequired: true,
                      validationText: "Last Name is Required *",
                    ),
                    TextEditingField(
                      controller: usernameTEC,
                      hintText: "Username",
                      isRequired: true,
                      validationText: "Username is Required *",
                      value: usernameTEC.text,
                      onChanged: (value) {
                        usernameTEC.text = value;
                      },
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
                                      Map<String, String> form = submitForm();
                                      res = await userManager.authenticate(
                                          'registration',
                                          credentials: form);
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
                                      'Sign Up',
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zingo/bloc/provider.dart';
import 'package:zingo/bloc/bloc.dart';
import 'package:zingo/managers/user_manager.dart';
import 'package:zingo/widgets/text_editing_field.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<AppBLoC>(context).fetch(UserManager);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: userManager.user != null
          ? Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.3,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Center(
                              child: CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.width * 0.25,
                                backgroundImage: NetworkImage(
                                  userManager.user.profile.profilePicture,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: .0,
                              right: .0,
                              child: CircleAvatar(
                                child: IconButton(
                                    color: Colors.deepOrangeAccent,
                                    icon: Icon(Icons.camera),
                                    onPressed: () async {
                                      File image = await ImagePicker.pickImage(
                                          source: ImageSource.gallery);
                                      if (image != null) {
                                        File croppedFile =
                                            await ImageCropper.cropImage(
                                                sourcePath: image.path,
                                                aspectRatioPresets: [
                                                  CropAspectRatioPreset.square,
                                                ],
                                                androidUiSettings:
                                                    AndroidUiSettings(
                                                        toolbarTitle: 'Crop',
                                                        toolbarColor: Theme.of(
                                                                context)
                                                            .primaryColorDark,
                                                        toolbarWidgetColor:
                                                            Colors.white,
                                                        initAspectRatio:
                                                            CropAspectRatioPreset
                                                                .square,
                                                        lockAspectRatio: true),
                                                iosUiSettings: IOSUiSettings(
                                                  title: 'Crop',
                                                ));
                                        await userManager
                                            .updateUserProfilePicture(
                                                croppedFile);
                                        userManager.loadUserProfile();
                                        setState(() {});
                                      }
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Public Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        height: 2.0,
                        color: Colors.white60,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "@${userManager.user.username}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                        ),
                      ),
                    ),
                    TextEditingField(
                      hintText: "First Name",
                      isRequired: true,
                      validationText: "First Name is Required*",
                      value: userManager.user.firstName,
                    ),
                    TextEditingField(
                      hintText: "Last Name",
                      isRequired: true,
                      validationText: "Last Name is Required*",
                      value: userManager.user.lastName,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {},
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
                              'Save',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () async {
                            await userManager.logout();
                            await Navigator.pushNamedAndRemoveUntil(
                                context, '/welcome', (predicate) => false);
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
                              'Logout',
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
          : Center(
              child: Text("Oops Some Error Occured!"),
            ),
    );
  }
}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:zingo/pages/add_post_page.dart';
import 'package:zingo/services/storage.dart';

enum CAMERA_MODE { POST, STORY, CREATE }

class CameraTab extends StatefulWidget {
  @override
  _CameraTabState createState() => _CameraTabState();
}

class _CameraTabState extends State<CameraTab> {
  List<CameraDescription> cameras = <CameraDescription>[];
  CameraController cameraController;
  static const IMAGE_FOLDER = "Zingo";
  File capturedImage;
  bool capturedImagePreview = false;

//  CAMERA_MODE cameraMode = CAMERA_MODE.POST;

  Future initCamera() async {
    cameras = await availableCameras();
    cameraController =
        CameraController(cameras.first, ResolutionPreset.ultraHigh);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: capturedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Theme.of(context).primaryColorDark,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Crop',
        ));
    if (croppedFile != null) {
      capturedImage = croppedFile;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext _) => AddPostPage(
                image: capturedImage,
              )));
    }
  }

  Future<bool> saveImage() async {
    bool saved = false;
    try {
      String imagePath = await Storage.externalStoragePath;
      imagePath += "${DateTime.now().millisecondsSinceEpoch}.jpg";
      await cameraController?.takePicture(imagePath);
      setState(() {
        capturedImage = File(imagePath);
        capturedImagePreview = true;
      });
      saved = true;
    } catch (e) {
      print(e);
    }
    return saved;
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  bool get isCameraReady =>
      cameraController != null && cameraController.value.isInitialized;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: Text("Camera"),
      ),
      body: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          isCameraReady
              ? Container(
                  width: size,
                  height: size,
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Container(
                          width: size,
                          height: size / cameraController.value.aspectRatio,
                          child: CameraPreview(cameraController),
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          Flexible(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      await saveImage();
                      await _cropImage();
                    },
                    child: Container(
                      width: 56.0,
                      height: 56.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

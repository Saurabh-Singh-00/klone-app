import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Storage {
  static const APP_FOLDER = "Zingo";

  static Future<Directory> get externalStorageDirectory async {
    Directory dir;
    await getExternalStorageDirectory().then((directory) async {
      dir = Directory(directory.path.substring(0, 20) + "$APP_FOLDER/");
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    });
    return dir;
  }

  static Future<String> get externalStoragePath async {
    Directory dir = await externalStorageDirectory;
    return dir.path;
  }

  static Future<bool> saveImage(String fileName, File file) async {
    bool saved = false;
    try {} catch (e) {}
    return saved;
  }
}

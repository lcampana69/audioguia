
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class LocalFile {
//***************************************************************************
  static Future<File?> saveFileFromAssets(String path) async {
    try {
      final byteData = await rootBundle.load('assets/$path');
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String assetsAppDirectory = appDocDir.path;
      final file =
      await File('$assetsAppDirectory/$path').create(recursive: true);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      return file;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

//***************************************************************************
  static Future<File?> saveFileFromMemory(String path,
      Uint8List byteData) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String assetsAppDirectory = appDocDir.path;
      final file =
      await File('$assetsAppDirectory/$path').create(recursive: true);
      await file.writeAsBytes(
          byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      return file;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

//***************************************************************************
  static Future<Uint8List?> loadFile(String path) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String assetsAppDirectory = appDocDir.path;
      return await File('$assetsAppDirectory/$path').readAsBytes();
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  //***************************************************************************
  static Future<bool> existsFile(String path) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String assetsAppDirectory = appDocDir.path;
      return (await File('$assetsAppDirectory/$path').exists());
    }  on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }
  //***************************************************************************
  static Future<bool> existsDir(String path) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      final appListDir = Directory('${appDocDir.path}/$path');
      return appListDir.existsSync();
    }  on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  //***************************************************************************
  static Future<List<FileSystemEntity>> listFiles(String path,{bool recursive : true}) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final appListDir = Directory('${appDocDir.path}/$path');
      return (await appListDir.listSync(recursive: recursive));
    }  on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  //***************************************************************************
  static Future<bool> deleteFile(String path) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      String assetsAppDirectory = appDocDir.path;
      final f=(await File('$assetsAppDirectory/$path'));
      if(await f.exists())await f.delete();
      return await f.exists();
    }  on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  //***************************************************************************
  static Future<bool> deleteDir(String path) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final appListDir = Directory('${appDocDir.path}/$path');
      if(await appListDir.exists())await appListDir.delete(recursive: true);
      return !(await appListDir.exists());
    }  on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }
}
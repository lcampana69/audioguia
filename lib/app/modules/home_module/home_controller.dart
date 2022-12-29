import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../data/provider/appwrite_provider.dart';
import '../../data/repository/local_file.dart';
import '../../utils/constants.dart';

class HomeController extends GetxController {
  List<String> cities = <String>[];
  RxInt _percentSync = 0.obs;
  int get percentSync => _percentSync.value;
  set percentSync(int value) {
    _percentSync.value = value;
  }

  RxString _city=''.obs;
  String get city => _city.value;
  set city(String value) {
    _city.value = value;
  } //***************************************************************************
  Future<Map<String,Uint8List>> getCitiesLocal() async {
    Map<String,Uint8List> result = {};
    final list=await LocalFile.listFiles('',recursive: true);
    for(final f in list){
      if(f.path.contains('.xlsx')) {
        final c = f.path.split(".xlsx")[0].split('/').last;
        result[c]=(await LocalFile.loadFile('$c/icon.jpg'))!;
      }
    }
    result=Map.fromEntries(
        result.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    cities=[];
    result.forEach((key, value) {cities.add(key);});
    return result;
  }

  //***************************************************************************
  Future<bool> syncRemoteDataCities() async {
    print('syncRemoteDataCities');
    final data = await AppWriteProvider.listDocuments(
        APPWRITE_DB_CITIES, APPWRITE_COLLECTION_CITIES);
    for (final f in data) {
      final localcity = f.data['city'];
      print(localcity);
      if (!(await LocalFile.existsFile('$localcity/icon.jpg'))) {
        final files = await AppWriteProvider.getListFiles(
            bucket: f.data['bucketId']);
        final cant=files.length;
        int cont=0;
        for (final ff in files) {
          cont++;
          final bytes = await AppWriteProvider.getFile(
              f.data['bucketId'], ff.$id);
          if (bytes.length > 0) {
            await LocalFile.saveFileFromMemory('$localcity/${ff.name}', bytes);
            percentSync=((cont/cant)*100).round();
            city=localcity;
          }
        }
      }
    }
    return true;
  }
}

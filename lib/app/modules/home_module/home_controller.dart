
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../data/provider/city_provider.dart';

class HomeController extends GetxController {
  List<String> cities=<String>[];


//***************************************************************************
  Future<List<String>> getCities() async {
    List<String> result=<String>[];
    print(result);
    var assetsFile = await rootBundle.loadString('AssetManifest.json');
    print(assetsFile);
    final Map<String, dynamic> manifestMap = json.decode(assetsFile);
    manifestMap.forEach((key, value) {
      if(key.contains(".xlsx")){
        result.add(key.split(".").first+"/");
      }
    });
    return cities=result;
  }

}

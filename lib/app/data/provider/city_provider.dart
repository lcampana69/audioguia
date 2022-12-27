import 'dart:convert';
import 'dart:io';

import 'package:audio_guia/app/data/models/city_model.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../models/poi_model.dart';

class CityProvider{

  final String nameCity;
  late String _path;


  CityProvider(this.nameCity)  {
    _path="assets/$nameCity/";
  }

  Future<CityModel> loadCity() async{
    final _audios= await _readAudios();
    final _pois=await _readPois(nameCity);
    return CityModel(nameCity,
        Image.asset(_path+"icon.jpg"),
        _audios,_pois);
  }

  Future<Map<String,String>> _readAudios()  async {
    Map<String,String> audios=<String,String>{};
    var assetsFile = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(assetsFile);
      manifestMap.forEach((key, value) {
        if(key.contains(".mp3") && key.contains(nameCity)){
          String v=key.split(".").first.split("/").last;
          audios.putIfAbsent(v, () => key);
        }
      });
    return audios;
  }

  Future<List<poi>> _readPois(String c) async{
    List<poi> POIS=<poi>[];
    var file = "assets/"+c+".xlsx";
    var bytes=await rootBundle.load(file);
    var excel = Excel.decodeBytes(bytes.buffer.asUint8List());
    Sheet? tbl=excel.tables[excel.tables.keys.first];
    int maxRows=tbl?.maxRows??0;
    for(int i=1;i<maxRows;i++){
      final r=tbl?.row(i);
      final String poiName=r?.elementAt(0)?.value.toString()??"";
      final double latitude=double.parse(r?.elementAt(2)?.value.toString().split(",").first??"0");
      final double longitude=double.parse(r?.elementAt(2)?.value.toString().split(",").elementAt(1)??"0");
      final String mp3=r?.elementAt(1)?.value.toString()??"0";
      final p=poi(poiName,latitude,longitude,mp3);
      POIS.add(p);
    }

    return POIS;
  }




}
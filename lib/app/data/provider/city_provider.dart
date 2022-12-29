import 'dart:convert';
import 'dart:io';

import 'package:audio_guia/app/data/models/city_model.dart';
import 'package:audio_guia/app/data/repository/local_file.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import '../models/poi_model.dart';

class CityProvider{
  final String nameCity;
  CityProvider(this.nameCity);


  //****************************************************************************
  Future<CityModel> loadCity() async{
    final _audios= await _readAudios();
    final _pois=await _readPois(nameCity);
    final bytes=await LocalFile.loadFile('$nameCity/icon.jpg');
    return CityModel(nameCity,
        Image.memory(bytes!),
        _audios,_pois);
  }

  //****************************************************************************
  Future<Map<String,String>> _readAudios()  async {
    Map<String,String> audios=<String,String>{};
    final list=await LocalFile.listFiles(nameCity);
    for(final f in list){
      if(f.path.contains(".mp3")){
        final v = f.path.split(".mp3")[0].split('/').last;
        audios.putIfAbsent(v, () => nameCity);
      }
    }
   return audios;
  }

  //****************************************************************************
  Future<List<poi>> _readPois(String c) async{
    List<poi> POIS=<poi>[];
    final bytes=await LocalFile.loadFile('$nameCity/$nameCity.xlsx');
    var excel = Excel.decodeBytes(bytes!);
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
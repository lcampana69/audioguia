import 'package:audio_guia/app/data/models/poi_model.dart';
import 'package:flutter/material.dart';

class CityModel{

  final String name;
  final Image image;
  final Map<String,String> audios;
  final List<poi> Pois;

  CityModel(this.name, this.image, this.audios, this.Pois);
}
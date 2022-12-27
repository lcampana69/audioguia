import 'dart:typed_data';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../data/models/city_model.dart';
import '../../data/provider/city_provider.dart';

class CityController extends GetxController {
  late CityModel city;
  Location _location = Location();
  late BitmapDescriptor icon;
  LocationData lastLocation =
      LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0});
  late LocationData firstPioValidLocation;
  late GoogleMapController mapController;
  Map<MarkerId?, Marker> markers = <MarkerId?, Marker>{};
  var mp3Poi = <String,String>{}.obs;
  var mp3PoiDefault = <String,String>{}.obs;
  final player = AudioPlayer();
  var statePlayer = PlayerState.completed.obs;

//********************************************************************************
  Future<CityModel> loadCity(String c) async {
    city = await CityProvider(c).loadCity();
    icon = await _getIconMarker(
        Icons.headset_rounded, 85, Colors.white.withOpacity(0.75));
    firstPioValidLocation = _getFirstValidLocation();
    _getListMp3Default();
    return city;
  }

  //********************************************************************************
  PlayerState playerState() {
    return statePlayer.value;
  }

//********************************************************************************
  Future<void> stopPlayer() async {
    await player.stop();
  }

//********************************************************************************
  Future<void> pausePlayer() async {
    await player.pause();
  }

  //********************************************************************************
  Future<void> resumePlayer() async {
    await player.resume();
  }

//********************************************************************************
  Future<void> playMp3(String audio) async {
    final mp3='assets/'+city.name+'/audio/'+audio+'.mp3';
    ByteData bytes = await rootBundle.load(mp3);
    final bs=BytesSource(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    await player.play(bs
    );
  }

  //********************************************************************************
  Future<void> playMapNameDefault(int ind) async {
    if (mp3PoiDefault.length <= 0) return;
    await playMp3(mp3PoiDefault.value.values.elementAt(ind).trim());
  }

//********************************************************************************
  String getNamePoiInt(int index) {
    return mp3PoiDefault.value.keys.elementAt(index);
  }
//********************************************************************************
  String getMp3Poi(String poi) {
    var result = city.Pois.where((element) => element.poiName == poi);
    if (result.length > 0) return result.first.mp3.toString();
    return "";
  }

//********************************************************************************
  Map<String,String> _getListMp3Default() {
    Map<String,String> l = <String,String>{};
    var result = city.Pois.where((element) => element.latitude == 0.0);
    if (result.length > 0) {
      for(var i=0 ; i<result.length ;i++){
        final e=result.elementAt(i);
        final key = e.poiName;
        l.putIfAbsent(key, () => e.mp3);
        print(e);
      }
      };
    mp3PoiDefault.value = mp3Poi.value = l;
    return l;
  }

//********************************************************************************
  Future<BitmapDescriptor> _getIconMarker(
      IconData iconData, double size, Color color) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final iconStr = String.fromCharCode(iconData.codePoint);
    textPainter.text = TextSpan(
        text: iconStr,
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: size,
          fontFamily: iconData.fontFamily,
          color: color,
        ));
    textPainter.layout();
    textPainter.paint(canvas, Offset(0.0, 0.0));
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  //********************************************************************************
  LocationData _getFirstValidLocation() {
    var result = city.Pois.where((element) => element.latitude > 0);
    double lat = result.first.latitude;
    double lon = result.first.longitude;
    result.forEach((poi) {
      final name=getMp3Poi(poi.poiName);
      final markerId = MarkerId(poi.poiName);
      final titulo=poi.poiName;
      //final titulo=name.length>1?poi.poiName+","+name.length.toString()+" audios":poi.poiName;
      final marker = Marker(
          markerId: markerId,
          consumeTapEvents: false,
          icon: icon,
          infoWindow: InfoWindow(
              title: titulo,
              onTap: () {
                playMp3(name);
              }),
          position: LatLng(poi.latitude, poi.longitude),
          draggable: false);
      markers.putIfAbsent(markerId, () => marker);
    });
    return LocationData.fromMap({'latitude': lat, 'longitude': lon});
  }

//********************************************************************************
  @override
  void onReady() {
    mp3PoiDefault.value = <String,String>{};
    _location.onLocationChanged.listen((LocationData currentLocation) {
      lastLocation = currentLocation;
    });
    player.onPlayerStateChanged.listen((PlayerState s) {
      print(
          "-------------------------------------------------------->PlayerState:" +
              s.toString());
      statePlayer.value = s;
    });
  }

//********************************************************************************
  @override
  void dispose() {
    mapController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    player.stop();
  }
}

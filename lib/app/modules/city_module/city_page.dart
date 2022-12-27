import 'dart:ffi';

import 'package:audio_guia/app/widgets/audio_pad.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_guia/app/modules/city_module/city_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';


import '../../data/models/city_model.dart';

class CityPage extends GetView<CityController> {
  @override
  Widget build(BuildContext context) {
    final w = context.mediaQuerySize.width;
    final h = context.mediaQuerySize.height;
    final e = Get.arguments;
    final color=Colors.lightBlue;
    final w5=w/67;
    final h5=h/144;
    final city = e.replaceFirst("assets/", "").replaceFirst("/", "");
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(onPressed: () async{
            await controller.stopPlayer();
            Get.back();
          },icon: Icon(Icons.reply_sharp,size: 40,),),
          foregroundColor: color,
          actions: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 3, 3),
                child: Obx(() {
                  final cant = controller.mp3PoiDefault.length;
                  return DropdownButton<String>(
                    alignment: AlignmentDirectional.center,
                    isDense: true,
                    itemHeight: null,
                    dropdownColor: Colors.lightBlue.shade100,
                     selectedItemBuilder: (_) {
                      return [];
                    },
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(50, 8, 8, 1),
                      child: Icon(Icons.headset_rounded,size: 35,color:color,),
                    ),
                    onChanged: (ind) {
                      controller.playMapNameDefault(int.parse(ind!));
                    },
                    items: _buildList(cant,color),
                  );
                }))
          ],
          flexibleSpace:

          Container(
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[color, Colors.white]),
            ),
          ),

          title: Shimmer.fromColors(
            loop: 3,
            period: Duration(milliseconds: 2500),
            baseColor: color,
            highlightColor: Colors.white70,
            child: Text(
              city
                  .toString()
                  .capitalize ?? "",
              style: TextStyle(
                  fontFamily: 'SyneMono',
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),

          ),
          centerTitle: false,
        ),
        body: Stack(
          children: [
            FutureBuilder<CityModel>(
                future: controller.loadCity(city),
                builder: (BuildContext context,
                    AsyncSnapshot<CityModel> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.hasError)
                        return Container(
                            child: Center(child: Text('Error: ${snapshot
                                .error}')));
                      return GoogleMapsActive(h, w);
                  }
                  return Container(
                      child: Center(child: Text("Esperando...")));
                }),
            Obx(() {
              return Positioned(
                  top: h5*10,
                  right: w5,
                  child: AudioPad(controller: controller,state: controller.statePlayer.value,));
            })
          ],
        ));
  }

  List<DropdownMenuItem<String>> _buildList(int cant,Color color) {
    return List.generate(cant, (index) {
                    final titulo=controller.getNamePoiInt(index).trim();
                    final chars=titulo.length;
                    return DropdownMenuItem(
                      alignment: AlignmentDirectional.center,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 200,
                              height: 60,
                              child: Center(
                                child: Text(titulo,
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                  style: TextStyle(
                                      fontFamily: 'SyneMono',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                             Divider(
                              thickness: 2,
                              indent: 1,
                              endIndent: 1,
                              color: color,
                              height: 1,
                            ),
                          ],
                        ),
                        value: index.toString());
                  });
  }

  Widget GoogleMapsActive(double h, double w) {
    return Container(
        height: h,
        width: w,
        child: GoogleMap(
          mapType: MapType.hybrid,
          markers: Set<Marker>.of(controller.markers.values),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          tiltGesturesEnabled: false,
          onMapCreated: (GoogleMapController ctrl) =>
          controller.mapController = ctrl,
          gestureRecognizers: Set()
            ..add(Factory<PanGestureRecognizer>(() =>
                PanGestureRecognizer()))..add(
                Factory<ScaleGestureRecognizer>(() =>
                    ScaleGestureRecognizer()))..add(
                Factory<TapGestureRecognizer>(() =>
                    TapGestureRecognizer()))..add(
                Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer())),
          initialCameraPosition: CameraPosition(
            zoom: 15,
            target: LatLng(controller.firstPioValidLocation.latitude ?? 0,
                controller.firstPioValidLocation.longitude ?? 0),
          ),
        ));
  }
}

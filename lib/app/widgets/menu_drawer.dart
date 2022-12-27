
import 'package:audio_guia/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../modules/home_module/home_controller.dart';


class CreaMenuDrawer extends StatefulWidget {
  const CreaMenuDrawer({Key? key}) : super(key: key);

  @override
  _CreaMenuDrawerState createState() => _CreaMenuDrawerState();
}

class _CreaMenuDrawerState extends State<CreaMenuDrawer> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put<HomeController>(HomeController());
    final w = MediaQuery
        .of(context)
        .size
        .width;
    final h = MediaQuery
        .of(context)
        .size
        .height;
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: h*.12,
              width: w*.9,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber[700],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                  ),

                  ),
                child: Text(
                  "¿A dónde quieres ir?",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ...controller.cities.map((e) {
              final city =
                  e.replaceFirst("assets/", "").replaceFirst("/", "");
              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.CITY,arguments: city);
                },
                child: Stack(alignment: Alignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: w*0.85,
                      height: h*0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border:Border.all(color: Colors.amber)
                      ),
                      child: Image.asset(
                        e + "icon.jpg",
                        fit: BoxFit.fill,

                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: Text(
                      city.toUpperCase(),
                      style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.w900),
                    ),
                  ),
                ]),
              );
            }).toList(),
          ]),
    );
  }
}

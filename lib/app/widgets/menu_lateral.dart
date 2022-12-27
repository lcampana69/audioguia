import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/home_module/home_controller.dart';
import '../routes/app_pages.dart';

class CreaMenuLateral extends StatefulWidget {
  final HomeController controller;
  const CreaMenuLateral({Key? key, required this.controller}) : super(key: key);

  @override
  _CreaMenuLateralState createState() => _CreaMenuLateralState();
}

class _CreaMenuLateralState extends State<CreaMenuLateral> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future:widget.controller.getCities(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if(snapshot.hasData && !snapshot.hasError){
          print(snapshot.data);
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...snapshot.data!.map((e) {
                  final city = e.replaceFirst("assets/", "").replaceFirst("/", "");
                  print("------------------------------------------->"+city);
                  return InkWell(
                    onTap: () {
                      Get.toNamed(Routes.CITY, arguments: e);
                    },
                    child: Stack(alignment: Alignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            width: w * 0.50,
                            height: h * 0.15,
                            child: Image.asset(
                              e + "icon.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 9,
                        child: Text(
                          city.toUpperCase(),
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ]),
                  );
                }).toList(),
              ]);
        }else{
          return Center(child: CircularProgressIndicator());
        };
      }
    );
  }

}

import 'package:audio_guia/app/data/repository/local_file.dart';
import 'package:audio_guia/app/widgets/copyright.dart';
import 'package:audio_guia/app/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_guia/app/modules/home_module/home_controller.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:animate_do/animate_do.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    var ctrl = controller;
    final w = MediaQuery
        .of(context)
        .size
        .width;
    final h = MediaQuery
        .of(context)
        .size
        .height;
    final w5 = w / 67;
    final h5 = h / 144;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<bool>(
          future: controller.syncRemoteDataCities(),
          builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
            if (!snapshot.hasData || snapshot == null) return _syncWidget(w, h);
//return _syncWidget(w,h);
            return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/fondoviajes.jpg'),
                      fit: BoxFit.contain,
                      repeat: ImageRepeat.repeatY),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        right: w5 * 2,
                        top: h5 * 4,
                        child: SizedBox(
                          width: 33 * w5,
                          height: 50 * h5,
                          child: Text(
                            "¿A dónde vamos?",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'SyneMono',
                                color: Colors.lightBlueAccent,
                                fontSize: 29,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Positioned(
                      right: w5,
                      top: 30 * h5,
                      child: Container(
                        height: h*.58,
                        child: SingleChildScrollView(
                            child: CreaMenuLateral(
                              controller: controller,
                            )),
                      ),
                    ),
                    Positioned(
                      bottom: 5 * h5,
                      right: 2 * w5,
                      child: Row(
                        children: [
                          InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              height: 26 * h5,
                              width: 26 * w5,
                              child: lottie.Lottie.network(
                                'https://assets8.lottiefiles.com/packages/lf20_JG23ME.json',
                              ),
                            ),
                            onTap: () async {
                              return;
                              final list = await LocalFile.listFiles('');
                              for (final l in list) {
                                print(l.path);
                                print(l.parent.path);
                              }
                              print(await LocalFile.existsDir('madrid'));
                              print(await LocalFile.existsFile(
                                  'madrid/icon.jpg'));
                              print(await LocalFile.deleteDir('madrid'));
                              final listPost = await LocalFile.listFiles('');
                              for (final l in listPost) {
                                print(l.path);
                                print(l.parent.path);
                              }
                              //controller.getCitiesLocal();
                            },
                          ),
                          Image.asset('assets/images/spain.png', width: w * .12,
                            height: w * .12,
                            fit: BoxFit.fill,)
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 2 * h5, right: 2 * w5, child: Copyright()),
                  ],
                ));
          },
        ),
      ),
    );
  }

//*****************************************************************************
  Widget _syncWidget(double w, double h) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.lightBlueAccent, Colors.white]),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          lottie.Lottie.network(
              'https://assets4.lottiefiles.com/packages/lf20_dddodqmc.json',
              height: h * .2, width: w * .5, fit: BoxFit.fill
          ),
          SizedBox(height: h * .04,),
          Obx(() {
            return Text('Actualizando ${controller.city.capitalizeFirst}',
              style: TextStyle(color: Colors.blueAccent, fontSize: h * .025),);
          }),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: LinearProgressIndicator(
                minHeight: h * .02,
                value: controller.percentSync / 100,
                color: Colors.lightBlueAccent,
              ),
            );
          }),
        ],
      ),
    );
  }
}



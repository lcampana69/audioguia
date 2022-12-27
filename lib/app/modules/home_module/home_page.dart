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
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final w5=w/67;
    final h5=h/144;
    return SafeArea(
      child: Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/fondoviajes.jpg'),
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.repeatY),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                    right: w5*2,
                    top: h5*4,
                    child: SizedBox(
                      width: 33*w5,
                      height: 50*h5,
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
                  top: 30*h5,
                  child: SingleChildScrollView(
                      child: CreaMenuLateral(
                    controller: controller,
                  )),
                ),
                Positioned(
                  bottom: 5*h5,
                  right: 6*w5,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 26*h5,
                    width: 26*w5,
                    child: lottie.Lottie.network(
                      'https://assets8.lottiefiles.com/packages/lf20_JG23ME.json',
                    ),
                  ),
                ),
                Positioned(bottom: 2*h5, right: 2*w5, child: Copyright()),
              ],
            )),
      ),
    );
  }
}

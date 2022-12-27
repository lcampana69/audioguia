import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late AnimationController animateController;
    return Scaffold(
      backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.lightBlueAccent, Colors.white]),
          ),
          child: ZoomIn(
            manualTrigger: true,
            duration: Duration(milliseconds: 1500),
              controller: (controller) {
              animateController = controller;
              animateController.addStatusListener((status) {
                switch(status){
                  case AnimationStatus.completed:
                    animateController.reverse();
                    break;
                  case AnimationStatus.dismissed:
                    Get.offAllNamed(Routes.HOME);
                    break;
                }
              });
          },
      child: Center(
          child: Image.asset(
            'assets/images/icon.png',
            fit: BoxFit.fill,
          ),
      ),
    ),
        ));
  }
}

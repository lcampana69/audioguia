import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class Tools {

  //***************************************************************************
   static void snackBar(String text,{Duration duration:const Duration(milliseconds: 3000)}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        duration: duration,
        content: Text(text),
        action: SnackBarAction(
          textColor: Colors.blue,
          label: 'OK',
          onPressed: () {
            // Code to execute.
          },
        ),
      ),
    );
  }

//***************************************************************************
static Future<bool> checkRemember() async {
  final prefs = await SharedPreferences.getInstance();
  final int? start = prefs.getInt('start_remember');
  if(start==null)return false;
  final now=new DateTime.now().millisecondsSinceEpoch;
  if(now-start>MINUTES_REMEMEBER*60*1000){
    await prefs.setString('email', "");
    await prefs.setString('password', "");
    return true;
  }
  return false;
}

//***************************************************************************
  static Future<void> setRemember(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('start_remember', new DateTime.now().millisecondsSinceEpoch);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  //***************************************************************************
  static Future<String> getEmailRemember() async {
    final prefs = await SharedPreferences.getInstance();
    return (await prefs.getString('email'))??'';
  }

  //***************************************************************************
  static Future<String> getPasswordRemember() async {
    final prefs = await SharedPreferences.getInstance();
    return (await prefs.getString('password'))??'';
  }

}

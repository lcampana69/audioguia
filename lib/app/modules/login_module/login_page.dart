import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_guia/app/modules/login_module/login_controller.dart';
import '../../data/provider/appwrite_provider.dart';
import '../../routes/app_pages.dart';
import '../../utils/constants.dart';
import '../../utils/tools.dart';
import '../../widgets/login.dart';

class loginPage extends GetView<loginController> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
        future: controller.initAppWrite(),
        builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
          if (snapshot.hasData && snapshot!=null) {
            if (snapshot.data == true) return LoginPage();
            Future.delayed(Duration(milliseconds: 250), () => Get.offNamed(Routes.HOME));
          }
          return Wait();
        });
  }

  Widget Wait(){
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.lightBlueAccent, Colors.white]),
      ),
      alignment: Alignment.center,
      child: SizedBox(height:70,width:70,child: CircularProgressIndicator(
      color:Colors.blueAccent,strokeWidth: 10,
    )));
  }

  //*****************************************************************************************
  Widget LoginPage() {
    final logo = controller.logo;
    final backgnd = controller.backgnd;
    return  Login(
        //********************************************************
          fncOnLogoTap: () async {
            if (controller.isLogged()) {
              Map<String, Uint8List> audio = {};
              final data = await AppWriteProvider.listDocuments(
                  APPWRITE_DB_CITIES, APPWRITE_COLLECTION_CITIES);
              int cont = 0;
              for (final f in data) {
                if (f.data['city'] == 'madrid') {
                  final files = await AppWriteProvider.getListFiles(
                      bucket: f.data['bucketId'], name: '*.mp3');
                  for (final ff in files) {
                    print(ff.name);
                    audio[ff.name] =
                    await AppWriteProvider.getFile(f.data['bucketId'], ff.$id);
                    print(cont++);
                  }
                }
              }
              print('------------------------');
              audio.forEach((key, value) {
                print('${key} (${value.length})');
              });
            } else
              Tools.snackBar("Not logged...");
          },
          //********************************************************
          fncOnSigIn: (user, email, password, isMale) async {
            if (await controller.createAccount(user, email, password, isMale)) {
              Get.offNamed(Routes.HOME);
            }
          },
          //********************************************************
          fncOnLogin: (email, password) async {
            Tools.snackBar("Logging In...",duration: Duration(milliseconds: 500));
            if (await controller.enterAccount(email, password)) {
              await Tools.setRemember(email, password);
              Get.offNamed(Routes.HOME);
            }
          },
          //********************************************************
          fncOnForgotPassword: (email) {

          },
          //********************************************************
          color: Colors.lightBlue,
          image: backgnd,
          logo: logo,
          passwordLen: 8,
          withSigin: true,
          texts: {
            "welcome": "Bienvenido",
            "welcome_to": " a AUDIO GUIA",
            "user": "usuario",
            "email": "correo",
            "password": "password",
            "repeat_password": "repita el password",
            "login_title": "ENTRAR",
            "signup_title": "REGISTRO",
            "login": "Login para continuar",
            "signup": "Regístrese para continuar",
            "male": "Hombre",
            "female": "Mujer",
            "agreement_1": "Estoy de acuerdo con los ",
            "agreement_2": "términos y condiciones.",
            "forgot_password": "¿Olvidó el password?",
            "error_email": "Por favor, revise el correo...",
            "error_len_password": "Por favor,revise la longitud del password",
            "error_eq_password":
            "Por favor, revise la password (debe de coincidir)",
            "error_user": "Por favor, revise el usuario",
          });

  }
}


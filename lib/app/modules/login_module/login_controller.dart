import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../data/provider/appwrite_provider.dart';
import '../../utils/constants.dart';
import '../../utils/tools.dart';
import 'package:appwrite/models.dart'as appWriteModels;

//*****************************************************************************************
class TypeFile{
  String name;
  String id;
  int size;
  TypeFile({required this.name,required this.id,required this.size});
}

//*****************************************************************************************
class loginController extends GetxController{
  late Uint8List logo;
  late Uint8List backgnd;

  //*****************************************************************************************
  Future<bool> initAppWrite() async {
    AppWriteProvider.appWriteClient = Client()
        .setEndpoint(APPWRITE_HOST_NAME)
        .setProject(APPWRITE_PROJECT_ID)
        .setSelfSigned(status: false);
    logo=(await rootBundle.load('assets/images/(c)LCF.png')).buffer.asUint8List();
    backgnd=(await rootBundle.load('assets/images/fondoviajes.jpg')).buffer.asUint8List();
    await Tools.checkRemember();
    final email=await Tools.getEmailRemember();
    final password=await Tools.getPasswordRemember();
    if(email.isNotEmpty && password.isNotEmpty){
      if (await enterAccount(email, password)) {
        return false;
      }
    }
    return true;
  }

  //*****************************************************************************************
  Future<bool> createAccount(String user, String email, String password, bool isMale) async{
    if (await AppWriteProvider.createAccount(user, email, password)) {
      await AppWriteProvider.setUserPreferences({'genero':isMale?'hombre':'mujer'});
      Tools.snackBar("Bienvenido ${AppWriteProvider.getUserName()}");
      return true;
    } else {
      Tools.snackBar(AppWriteProvider.appWriteError);
      return false;
    }
  }

  //*****************************************************************************************
  Future<bool> enterAccount(String email, String password) async{
    if (await AppWriteProvider.createSession(email, password)) {
      Tools.snackBar("Bienvenido ${AppWriteProvider.getUserName()}");
      return true;
    } else
      Tools.snackBar(AppWriteProvider.appWriteError);
    return false;
  }

  //*****************************************************************************************
  Future<List<TypeFile>> fileList(String bucket) async{
    final files=await AppWriteProvider.getListFiles(bucket: bucket);
    List<TypeFile> typeFiles=[];
    for(appWriteModels.File e in files){
      typeFiles.add(TypeFile(name: e.name, id: e.$id, size: e.sizeOriginal));
    }
    return typeFiles;
  }

  //*****************************************************************************************
  Future<Uint8List> loadFile(String name) async {
    final result = await AppWriteProvider.getListFiles(bucket: APPWRITE_BUCKET_ASSETS,name:name);
    if(result.isNotEmpty){
      final file=result.first;
      if(file.sizeOriginal>0)
        return await AppWriteProvider.getFile(APPWRITE_BUCKET_ASSETS, file.$id);
    };
    return Uint8List.fromList([]);
  }

  //*****************************************************************************************
  @override
  void dispose() {
    super.dispose();
  }

  //*****************************************************************************************
  bool isLogged(){
    return AppWriteProvider.isLoggedIn;
  }

  //*****************************************************************************************
  @override
  void onReady() async{
    super.onReady();
  }

  //*****************************************************************************************
  @override
  void onInit() async {
    super.onInit();
  }

}

import 'package:appwrite/appwrite.dart';
import 'package:audio_guia/app/modules/home_module/home_bindings.dart';
import 'package:audio_guia/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app/data/provider/appwrite_provider.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter/services.dart';

import 'app/utils/tools.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp],
  ); // To turn off landscape mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      debugShowCheckedModeBanner: false,
      title: 'AudioGuia',
      theme: appThemeData,
      home: Container(),
      getPages: AppPages.pages,
      initialRoute: Routes.SPLASH,
      onDispose: ()async {
        if(AppWriteProvider.isLoggedIn){
          await AppWriteProvider.deleteSession();
          Tools.checkRemember();
        }
      },
    );
  }
}


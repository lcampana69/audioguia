import '../../app/modules/login_module/login_page.dart';
import '../../app/modules/login_module/login_bindings.dart';
import '../../app/modules/home_module/home_page.dart';
import '../../app/modules/home_module/home_bindings.dart';

import 'package:get/get.dart';

import '../../splash.dart';
import '../modules/city_module/city_bindings.dart';
import '../modules/city_module/city_page.dart';
part './app_routes.dart';
/**
 * GetX Generator - fb.com/htngu.99
 * */

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.CITY,
      page: () => CityPage(),
      binding: CityBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => Splash(),

    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => loginPage(),
      binding: loginBinding(),
    ),
  ];
}

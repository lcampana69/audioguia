import 'package:audio_guia/app/modules/city_module/city_controller.dart';
import 'package:get/get.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class CityBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CityController());
  }
}
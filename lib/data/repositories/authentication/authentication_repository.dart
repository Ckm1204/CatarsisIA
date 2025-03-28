import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get to => Get.find();

  // variables
  final deviceStorage = GetStorage();

  // called from main.dart on app start
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  // fuction to show Relevant Screen
  screenRedirect() {
    if (deviceStorage.read('isFirstTime') == null) {
      Get.to('/onboarding');
    } else {
      Get.offAllNamed('/login');
    }
  }





}
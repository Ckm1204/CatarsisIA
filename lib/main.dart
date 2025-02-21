import 'package:firebase_core/firebase_core.dart';
  import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
  import 'data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';
  import 'App.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  /// Todo: Add widgets binding
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  /// Todo: Init Local Storage
  /// Todo: Await native splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  /// Getx Storage
   await GetStorage.init();
  /// Initialize Firebase
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform).then(
      (FirebaseApp value) => Get.put(AuthencationRepository()),);



  /// Todo: Initialize Authentication

  runApp(const App());
}


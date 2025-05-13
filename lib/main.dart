import 'package:app_catarsis/utils/conection_red/connectivity_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';
import 'App.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await dotenv.load(fileName: ".env");

  /// Todo: Add widgets binding
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  /// Todo: no connection screen
  Get.put(ConnectivityService());
  /// Todo: Await native splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  /// Getx Storage
   await GetStorage.init();
  /// Initialize Firebase
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform).then(
      (FirebaseApp value) => Get.put(AuthenticationRepository()),);


  runApp(
    BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(FirebaseAuth.instance)..add(AppStarted()),
      child: App(),
    ),
  );

  /// Todo: Initialize Authentication

}


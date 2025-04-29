import 'package:app_catarsis/blocs/home/pages/home_screen.dart';
import 'package:app_catarsis/utils/conection_red/no_connection_screen.dart';
import 'package:app_catarsis/utils/services/auth_service/firebase_auth.dart';
import 'package:app_catarsis/utils/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'modules/authentication/login/pages/login_screen.dart';
import 'generated/app_localizations.dart';
import 'modules/onboarding/onboarding.dart';

class App extends StatelessWidget {
   App({Key? key}) : super(key: key);
  final FirebaseAuthService _authService = FirebaseAuthService();


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        // Mostrar pantalla de de carga circular mientras autentication repository es decide mostrar la pantalla relevante
        // home: const Scaffold(backgroundColor: Colors.blue, body: Center(child: CircularProgressIndicator(color: Colors.white))),
        home: FutureBuilder<User?>(
          future: _authService.autoLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasData && snapshot.data != null) {
              return HomeScreen();
            }

            return const OnBoardingScreen();
          },
        ),

        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('es', ''), // TODO: put here status management
        // locale: const Locale('en', ''),
        routes: {

          '/login': (context) => const LoginPage(),
           '/home': (context) => HomeScreen(),
        }
    );
  }
}


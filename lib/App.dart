import 'package:app_catarsis/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'generated/app_localizations.dart';
import 'modules/onboarding/onboarding.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home:  OnBoardingScreen(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('es', ''), // TODO: put here status management
        // locale: const Locale('en', ''),
        routes: {
          // '/login': (context) => const LoginPage(),
          // '/home': (context) => const Home_page(),
        }
    );
  }
}
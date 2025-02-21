import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String onboarding(String name) {
    String _temp0 = intl.Intl.selectLogic(
      name,
      {
        'onBoardingTitle1': 'Un lugar seguro para tus emociones',
        'onBoardingSubTitle1': 'Con Excursion encontrarás los mejores lugares de Colombia con sus detalles ',
        'onBoardingTitle2': 'Colombia',
        'onBoardingSubTitle2': 'Un pais lleno de maravillas',
        'onBoardingTitle3': 'Gratis',
        'onBoardingSubTitle3': 'Excursion es una app totalmente gratuita, ! Prepara tus maletas y comienza a explorar ¡',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String login(String name) {
    String _temp0 = intl.Intl.selectLogic(
      name,
      {
        'email': 'correo electrónico',
        'password': 'contraseña',
        'login': 'iniciar sesión',
        'username': 'Nombre de usuario',
        'userLogin': 'Usuario inicio sesion  correctamente con Google ',
        'someError': 'Algo salió mal',
        'otherError': 'Ocurrió un error inesperado',
        'other': 'Ocurrió un error inesperado',
        'loginGoogle': 'Iniciar sesión con Google',
        'dontHaveAcc': ' ¿No tienes una cuenta?',
        'signUp': 'Regístrate',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String signUp(String name) {
    String _temp0 = intl.Intl.selectLogic(
      name,
      {
        'alHaveAcc': '¿ Ya tienes una cuenta ?',
        'username': 'Nombre de usuario',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String home(String name) {
    String _temp0 = intl.Intl.selectLogic(
      name,
      {
        'welcome': 'Bienvenido',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String nav_bar(String name) {
    String _temp0 = intl.Intl.selectLogic(
      name,
      {
        'home': 'Inicio',
        'profile': 'Perfil',
        'search': 'Buscar',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String card_firestore(String name) {
    String _temp0 = intl.Intl.selectLogic(
      name,
      {
        'department': 'Departamento',
        'name': 'Nombre',
        'location': 'Ubicación',
        'average': 'Promedio',
        'total': 'Total puntuaciones',
        'addComment': 'Escribe un comentario',
        'submitComment': 'Enviar comentario',
        'submit': 'Enviar puntaje',
        'totalRatings': 'Total',
        'rating': 'Puntación',
        'weather': 'Clima',
        'description': 'Descripción',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String search(String name) {
    String _temp0 = intl.Intl.selectLogic(
      name,
      {
        'searchTitle1': 'Buscar por nombre o departamento',
        'notFound': 'No se encontraron lugares',
        'profileTitle1': 'Perfil',
        'dob': 'Fecha de cumpleaños',
        'save': 'guardar perfil',
        'other': '',
      },
    );
    return '$_temp0';
  }
}

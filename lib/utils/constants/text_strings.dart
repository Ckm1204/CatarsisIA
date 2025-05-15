import 'package:get/get.dart';

import '../../generated/app_localizations.dart';

class AppText {
  AppText._();

  // Global texts


  // OnBoarding texts

  static String onBoardingTitle1 = AppLocalizations.of(Get.context!).onboarding('onBoardingTitle1');
  static String onBoardingTitle2 = AppLocalizations.of(Get.context!).onboarding('onBoardingTitle2');
  static String onBoardingTitle3 = AppLocalizations.of(Get.context!).onboarding('onBoardingTitle3');
  static String onBoardingSubTitle1 = AppLocalizations.of(Get.context!).onboarding('onBoardingSubTitle1');
  static String onBoardingSubTitle2 = AppLocalizations.of(Get.context!).onboarding('onBoardingSubTitle2');
  static String onBoardingSubTitle3 = AppLocalizations.of(Get.context!).onboarding('onBoardingSubTitle3');

  // Login texts
  static String email = AppLocalizations.of(Get.context!).login('email');
  static String password = AppLocalizations.of(Get.context!).login('password');
  static String login = AppLocalizations.of(Get.context!).login('login');
  static String userLogin = AppLocalizations.of(Get.context!).login('userLogin');
  static String someError = AppLocalizations.of(Get.context!).login('someError');
  static String userNotFound = AppLocalizations.of(Get.context!).login('userNotFound');
  static String wrongPassword = AppLocalizations.of(Get.context!).login('wrongPassword');
  static String loginGoogle = AppLocalizations.of(Get.context!).login('loginGoogle');
  static String dontHaveAcc = AppLocalizations.of(Get.context!).login('dontHaveAcc');
  static String signUp = AppLocalizations.of(Get.context!).login('signUp');
  static String alHaveAcc = AppLocalizations.of(Get.context!).login('alHaveAcc');
  static String username = AppLocalizations.of(Get.context!).login('username');
  static String welcome = AppLocalizations.of(Get.context!).login('welcome');
// Nav Bar

static String home = AppLocalizations.of(Get.context!).nav_bar('home');
static String search = AppLocalizations.of(Get.context!).nav_bar('search');
static String profile = AppLocalizations.of(Get.context!).nav_bar('profile');
static String settings = AppLocalizations.of(Get.context!).nav_bar('data');
// CardFirestore
static String name = AppLocalizations.of(Get.context!).card_firestore('name');
static String department = AppLocalizations.of(Get.context!).card_firestore('department');
static String description = AppLocalizations.of(Get.context!).card_firestore('description');
static String location = AppLocalizations.of(Get.context!).card_firestore('location');
static String weather = AppLocalizations.of(Get.context!).card_firestore('weather');
static String rating = AppLocalizations.of(Get.context!).card_firestore('rating');
static String average = AppLocalizations.of(Get.context!).card_firestore('average');
static String total = AppLocalizations.of(Get.context!).card_firestore('total');
static String submit = AppLocalizations.of(Get.context!).card_firestore('submit');
static String totalRatings = AppLocalizations.of(Get.context!).card_firestore('totalRatings');
static String addComment = AppLocalizations.of(Get.context!).card_firestore('addComment');
static String submitComment = AppLocalizations.of(Get.context!).card_firestore('submitComment');

// search
static String searchTitle1 = AppLocalizations.of(Get.context!).search('searchTitle1');
static String notFound = AppLocalizations.of(Get.context!).search('notFound');


// profile
static String profileTitle1 = AppLocalizations.of(Get.context!).search('profileTitle1');
static String dob = AppLocalizations.of(Get.context!).search('dob');
static String save = AppLocalizations.of(Get.context!).search('save');

// surveyMood

}

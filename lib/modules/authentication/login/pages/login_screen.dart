import 'package:app_catarsis/utils/constants/image_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_catarsis/utils/services/auth_service/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'signup_screen.dart';
import '../widgets/form_container.dart';
import 'package:app_catarsis/utils/constants/text_strings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app_catarsis/utils/helpers/toast.dart';
import 'package:app_catarsis/utils/constants/colors.dart';
import 'package:app_catarsis/utils/constants/sizes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: AppSizes.md),
              Image(
                width: HelperFunctions.screenWidth() * 0.6,
                height: HelperFunctions.screenHeight() * 0.3,
                image: AssetImage(AppImage.logo),
                fit: BoxFit.contain,
              ),
              Text(
                AppText.login,
                style: TextStyle(
                    fontSize: AppSizes.fontSizeLg,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              SizedBox(height: AppSizes.md),
              FormContainerWidget(
                controller: _emailController,
                hintText: AppText.email,
                isPasswordField: false,
              ),
              SizedBox(
                height: AppSizes.sm,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: AppText.password,
                isPasswordField: true,
              ),
              SizedBox(
                height: AppSizes.md,
              ),
              GestureDetector(
                onTap: () {
                  _signIn();
                },
                child: Container(
                  width: double.infinity,
                  height: AppSizes.buttonLogin,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigning
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            AppText.login,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  _signInWithGoogle();
                },
                child: Container(
                  width: double.infinity,
                  height: AppSizes.buttonLogin,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppText.loginGoogle, // "Sign in with Google"
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppText.dontHaveAcc), // "Don't have an account?"
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      AppText.signUp, // "Sign Up"
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )));
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });
  
    try {
      String email = _emailController.text;
      String password = _passwordController.text;
  
      User? user = await _auth.signInWithEmailAndPassword(email, password);
  
      if (user != null) {
        showToast(message: "User is successfully signed in");
        Get.toNamed('/home');
      }
    } catch (e) {
      showToast(message: "Authentication failed: ${e.toString()}");} finally {
      setState(() {
        _isSigning = false;
      });
    }
  }
  
  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
  
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
  
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
        Get.toNamed('/home');
      }
    } catch (e) {
      showToast(message: "Google Sign-In failed: ${e.toString()}");
    }
  }
}

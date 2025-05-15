import 'package:firebase_auth/firebase_auth.dart';

import '../../helpers/toast.dart';
import '../session/shared_preferences.dart';

class FirebaseAuthService {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final AuthenticationStorageService _storage = AuthenticationStorageService();

      Future<User?> signInWithEmailAndPassword(String email, String password) async {
        try {
          UserCredential credential = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          // Save credentials on successful login
          await _storage.saveCredentials(
            email: email,
            password: password,
            authType: "email",
          );
          return credential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found' || e.code == 'wrong-password') {
            showToast(message: 'Invalid email or password.');
          } else {
            showToast(message: 'An error occurred: ${e.code}');
          }
        }
        return null;
      }


      Future<void> signOut() async {
        await _auth.signOut();
        await _storage.clearCredentials();
      }

      Future<User?> signUpWithEmailAndPassword(String email, String password) async {
        try {
          UserCredential credential = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          return credential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            showToast(message: 'The email address is already in use.');
          } else {
            showToast(message: 'An error occurred: ${e.code}');
          }
        }
        return null;
      }


      Future<User?> autoLogin() async {
        if (await _storage.isLoggedIn()) {
          final credentials = await _storage.getCredentials();
          if (credentials['authType'] == 'email' &&
              credentials['email'] != null &&
              credentials['password'] != null) {
            return signInWithEmailAndPassword(
              credentials['email']!,
              credentials['password']!,
            );
          }
        }
        return null;
      }
    }


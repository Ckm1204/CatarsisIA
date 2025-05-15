// lib/blocs/auth/auth_event.dart
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
class AppStarted extends AuthEvent {}


class AuthUserChanged extends AuthEvent {
  final User? user;
  AuthUserChanged(this.user);
}

import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationStorageService {
  static const String _emailKey = "user_email";
  static const String _passwordKey = "user_password";
  static const String _authTypeKey = "auth_type";
  static const String _isLoggedInKey = "is_logged_in";

  // Save credentials
  Future<void> saveCredentials({
    required String email,
    String? password,
    required String authType, // "email" or "google"
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    if (password != null) {
      await prefs.setString(_passwordKey, password);
    }
    await prefs.setString(_authTypeKey, authType);
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get stored credentials
  Future<Map<String, String?>> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_emailKey),
      'password': prefs.getString(_passwordKey),
      'authType': prefs.getString(_authTypeKey),
    };
  }

  // Clear stored credentials
  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_passwordKey);
    await prefs.remove(_authTypeKey);
    await prefs.setBool(_isLoggedInKey, false);
  }
}


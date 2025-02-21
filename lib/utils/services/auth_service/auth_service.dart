

/***
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static const String _tokenKey = "auth_token";
  final String loginUrl = 'http://10.0.2.2:8081/auth/login';

  /// Guarda el token JWT en SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Obtiene el token almacenado en SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Elimina el token (logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Verifica si el token es válido y no ha expirado
  bool isTokenValid(String token) {
    return !JwtDecoder.isExpired(token);
  }

  /// Extrae el ID del usuario del token JWT
  String? getUserId(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken["sub"]?.toString(); // "sub" contiene el ID del usuario
  }

  /// Extrae el nombre del usuario del token JWT
  String? getUserName(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken["name"]?.toString(); // "name" contiene el nombre del usuario
  }

  /// Extrae el nombre del usuario o rol del token JWT
  String? getUserRole(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken["authorities"]?.toString(); // "authorities" contiene el rol del usuario
  }

  /// Método para iniciar sesión
  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        print('Failed to login: ${response.statusCode} ${response.reasonPhrase}');
        return null;
      }
    } on SocketException catch (e) {
      print('Network error: $e');
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }


  bool isValid(String token) {
    return !JwtDecoder.isExpired(token);
  }
}
    ***/
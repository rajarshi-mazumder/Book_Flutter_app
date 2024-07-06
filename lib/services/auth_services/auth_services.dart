import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse(
        'http://10.0.2.2:5000/login'); // Replace with your backend URL

    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$email:$password'))}',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final userData = data['user_data'];
      // Save the token in local storage or use it for subsequent requests
      await saveAuthToken(token: token);
      print('Login successful. user data: $userData');
      return {"signin_status": true, "user_data": userData};
    } else {
      print('Login failed. Status code: ${response.statusCode}');
      return {"signin_status": false};
    }
  }

  static Future<bool> register(
      String name, String email, String password) async {
    final url = Uri.parse(
        'http://10.0.2.2:5000/register'); // Replace with your backend URL

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      // Save the token in local storage or use it for subsequent requests
      await saveAuthToken(token: token);
      print('Registration successful. Token: $token');
      return true;
    } else {
      if (kDebugMode) {
        print("User creation failed: ${response.body}");
      }
      return false;
    }
  }

  static Future<Map<String, dynamic>?> silentLogin() async {
    final url = Uri.parse(
        'http://10.0.2.2:5000/silent_login'); // Replace with your backend URL
    final token = await storage.read(key: 'jwt_token');

    if (token == null) {
      return null;
    }

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Silent login failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Silent login failed. Error: $e');
    }
    return null;
  }

  static logout() async {
    await storage.delete(key: 'jwt_token');
  }

  static saveAuthToken({required String token}) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }
}

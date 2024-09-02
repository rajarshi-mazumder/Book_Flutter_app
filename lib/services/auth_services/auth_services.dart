import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// const baseurl = "http://10.0.2.2:5000";
const baseurl = "http://43.206.213.88:5000";

class AuthService {
  static var logger = Logger(
    printer: PrettyPrinter(),
  );
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  /// logs in the user by calling login() endpoint,
  /// using email and password in the auth headers
  /// After logging in, it saves the token received, and returns the user_data
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('$baseurl/login'); // Replace with your backend URL

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
      final appData = data['app_data'];

      // Save the token in local storage or use it for subsequent requests
      await saveAuthToken(token: token);

      return {
        "signin_status": true,
        "user_data": userData,
        "app_data": appData
      };
    } else {
      logger.e("login failed ${response.statusCode}");
      return {"signin_status": false};
    }
  }

  /// registers the user by calling register() endpoint,
  /// using name email and password in the request body
  /// After registering , it saves the token received, and returns the user_data
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final url = Uri.parse('$baseurl/register'); // Replace with your backend URL

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
      final userData = data['user_data'];
      final appData = data['app_data'];
      // Save the token in local storage or use it for subsequent requests
      await saveAuthToken(token: token);

      return {
        "signup_status": true,
        "user_data": userData,
        "app_data": appData
      };
    } else {
      logger.e("sign up failed");
      return {"signup_status": false};
    }
  }

  /// uses the saved token to log the user in
  /// if token is null, returns null
  /// if token is not null, it returns user_data
  static Future<Map<String, dynamic>?> silentLogin() async {
    final url =
        Uri.parse('$baseurl/silent_login'); // Replace with your backend URL
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
        final data = jsonDecode(response.body);
        final userData = data['user_data'];
        final appData = data['app_data'];

        return {"user_data": userData, "app_data": appData};
      } else {
        logger.e('Silent login failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Silent login failed. Error: $e');
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

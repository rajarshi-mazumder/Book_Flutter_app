import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final Dio dio = Dio();
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<void> login(String email, String password) async {
    final String url =
        'http://127.0.0.1:5000/login'; // Replace with your backend URL

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: <String, String>{
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$email:$password'))}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];
        // Save the token in local storage
        await storage.write(key: 'jwt_token', value: token);
        print('Login successful. Token: $token');
      } else {
        print('Login failed. Status code: ${response.statusCode}');
        print('Response body: ${response.data}');
      }
    } catch (e) {
      print('Login failed. Error: $e');
    }
  }
}

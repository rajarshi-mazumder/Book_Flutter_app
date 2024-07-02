import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:5000';

  static Future<http.Response?> login() async {
    final url = Uri.parse('$baseUrl/login');
    if (!kIsWeb) {
      if (await canLaunchUrl(Uri.parse(url.toString()))) {
        await launchUrl(Uri.parse(url.toString()));
        print(" I AM HERE");
      } else {
        throw 'Could not launch $url';
      }
    } else {
      // return http.get(Uri.parse(url.toString()));
      html.window.location.href = url.toString();
    }
  }

  static Future<Map<String, dynamic>?> getProfile() async {
    final url = Uri.parse('$baseUrl/profile');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<void> logout() async {
    final url = Uri.parse('$baseUrl/logout');
    await http.get(url, headers: {'Accept': 'application/json'});
  }
}

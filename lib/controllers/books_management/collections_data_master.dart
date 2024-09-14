import 'dart:convert';

import 'package:book_frontend/services/connection_services/connection_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CollectionsDataMaster {
  // static const baseurl = "http://10.0.2.2:5000";
  // static const baseurl = "http://43.206.213.88:5000";

  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>?> getCollections() async {
    final token = await storage.read(key: 'jwt_token');
    final url = Uri.parse("$baseUrl/collections");

    final response = await http
        .get(url, headers: <String, String>{'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {"collection_data": data["collection_data"]};
    }
    return null;
  }
}

import 'dart:convert';

import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class BooksDataMaster {
  // static const baseurl = "http://10.0.2.2:5000";
  static const baseurl = "http://43.206.213.88:5000";

  static final FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>?> getBooks(
      {required UserProvider userProvider,
      required int booksPaginationNumber}) async {
    final url = Uri.parse("$baseurl/books?page=$booksPaginationNumber");
    final token = await storage.read(key: 'jwt_token');

    final response = await http
        .get(url, headers: <String, String>{'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {"books": data["books"]};
    }
  }

  static Future<Map<String, dynamic>?> getBookDetails(
      {required UserProvider userProvider, required int bookId}) async {
    final url = Uri.parse("$baseurl/books/$bookId/details");
    final token = await storage.read(key: 'jwt_token');

    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["book_data"];
    }
  }
}

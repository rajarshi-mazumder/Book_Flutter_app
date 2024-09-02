import 'dart:convert';

import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:http/http.dart' as http;

class CategoriesDataMaster {
  // static const baseurl = "http://10.0.2.2:5000";
  static const baseurl = "http://43.206.213.88:5000";

  static Future<List?> getCategories(
      {required UserProvider userProvider}) async {
    final url = Uri.parse("$baseurl/categories");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["categories"];
    }
  }
}

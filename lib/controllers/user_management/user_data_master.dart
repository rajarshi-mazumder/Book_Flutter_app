import 'dart:convert';

import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/app_user.dart';
import 'package:http/http.dart' as http;

class UserDataMaster {
  static const baseurl = "http://10.0.2.2:5000";

  static addUserBooksStarted({required AppUser user}) async {
    final url = Uri.parse("$baseurl/users/${user.id}/books_started");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'books_started': user.booksStarted
            ?.map((e) => e["book_id"].runtimeType == int
                ? e["book_id"]
                : int.parse(e["book_id"]))
            .toList(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
    } else {
      print("Unable to save books_started");
    }
  }
}

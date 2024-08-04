import 'package:book_frontend/services/cache_services/user_cache_services.dart';

import '../books/book.dart';
import '../books/category.dart';

// default data
List<Map<String, dynamic>> defaultInterestedCategories = [
  {"category_id": "1", "date_interested": DateTime.now},
  {"category_id": "2", "date_interested": DateTime.now},
];

class AppUser {
  String id;
  String name;
  String email;
  bool? admin;
  List<Map<String, dynamic>>? interestedCategories;
  List<Book>? booksRead;
  List<Map<String, dynamic>>? booksStarted;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.admin,
    this.interestedCategories,
    this.booksRead,
    this.booksStarted,
  });

  // fromMap factory constructor
  factory AppUser.fromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>>? tempBooksStarted =
        UserCacheServices().readUserBooksStarted();
    List<Map<String, dynamic>>? tempInterestedCategories =
        UserCacheServices().readUserInterestedCategories();

    return AppUser(
      id: map['id'].toString(),
      name: map['name'],
      email: map['email'],
      admin: map['admin'],
      interestedCategories:
          (tempInterestedCategories == null || tempInterestedCategories.isEmpty)
              ? defaultInterestedCategories
              : tempInterestedCategories,
      booksRead: map['booksRead'] != null
          ? List<Book>.from(map['booksRead'].map((x) => Book.fromMap(x)))
          : null,
      booksStarted: tempBooksStarted,
    );
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'id': int.parse(id),
      'name': name,
      'email': email,
      'admin': admin,
      'interestedCategories': interestedCategories,
      'booksRead': booksRead != null
          ? List<dynamic>.from(booksRead!.map((x) => x.toMap()))
          : null,
      'books_started': booksStarted,
    };
  }
}

import 'book.dart';
import 'category.dart';

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
    List<Map<String, dynamic>>? tempBooksStarted = [];
    map["books_started"]
        .map((x) => tempBooksStarted.add(x as Map<String, dynamic>))
        .toList();

  List<Map<String, dynamic>>? tempInterestedCategories = [];
    map["interested_categories"]
        .map((x) => tempInterestedCategories.add(x as Map<String, dynamic>))
        .toList();
  
    return AppUser(
      id: map['id'].toString(),
      name: map['name'],
      email: map['email'],
      admin: map['admin'],
      interestedCategories: tempInterestedCategories,
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

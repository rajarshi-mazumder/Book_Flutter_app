import 'book.dart';
import 'category.dart';

class AppUser {
  String id;
  String name;
  String email;
  bool? admin;
  List<Category>? interestedCategories;
  List<Book>? booksRead;
  List<Book>? booksStarted;

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
    return AppUser(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      admin: map['admin'],
      interestedCategories: map['interestedCategories'] != null
          ? List<Category>.from(
              map['interestedCategories'].map((x) => Category.fromMap(x)))
          : null,
      booksRead: map['booksRead'] != null
          ? List<Book>.from(map['booksRead'].map((x) => Book.fromMap(x)))
          : null,
      booksStarted: map['booksStarted'] != null
          ? List<Book>.from(map['booksStarted'].map((x) => Book.fromMap(x)))
          : null,
    );
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'admin': admin,
      'interestedCategories': interestedCategories != null
          ? List<dynamic>.from(interestedCategories!.map((x) => x.toMap()))
          : null,
      'booksRead': booksRead != null
          ? List<dynamic>.from(booksRead!.map((x) => x.toMap()))
          : null,
      'booksStarted': booksStarted != null
          ? List<dynamic>.from(booksStarted!.map((x) => x.toMap()))
          : null,
    };
  }
}

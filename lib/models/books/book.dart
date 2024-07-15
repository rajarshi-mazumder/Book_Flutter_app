import 'package:book_frontend/models/books/book_details.dart';

import 'author.dart';
import 'category.dart';

class Book {
  String bookId;
  String title;
  String description;
  String? coverImgPath;
  List<Category>? categories;
  Author? author;
  BookDetails? bookDetails;
  Book({
    required this.bookId,
    required this.title,
    required this.description,
    this.categories,
    this.coverImgPath,
    this.author,
    this.bookDetails,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      bookId: map['id'].toString(),
      title: map['title'],
      description: map['description'],
      coverImgPath: map['coverImgPath'],
      categories: map['categories'] != null
          ? List<Category>.from(
              map['categories'].map((x) => Category.fromMap(x)))
          : null,
      author: map['author'] != null ? Author.fromMap(map['author']) : null,
    );
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'title': title,
      'description': description,
      'coverImgPath': coverImgPath,
      'categories': categories != null
          ? List<dynamic>.from(categories!.map((x) => x.toMap()))
          : null,
      'author': author != null ? author!.toMap() : null,
    };
  }
}

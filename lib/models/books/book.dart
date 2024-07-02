import 'author.dart';
import 'category.dart';

class Book {
  String bookId;
  String title;
  String description;
  String? coverImgPath;
  List<Category>? categories;
  Author? author;
  Book({
    required this.bookId,
    required this.title,
    required this.description,
    this.categories,
    this.coverImgPath,
    this.author,
  });
}

import 'package:hive/hive.dart';
import 'author.dart';
import 'category.dart';
import 'book_details.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(0)
  String bookId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String? coverImgPath;

  @HiveField(4)
  List<Category>? categories;

  @HiveField(5)
  Author? author;

  @HiveField(6)
  BookDetails? bookDetails;

  @HiveField(7)
  String? detailsHash;

  Book({
    required this.bookId,
    required this.title,
    required this.description,
    this.categories,
    this.coverImgPath,
    this.author,
    this.bookDetails,
    this.detailsHash,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      bookId: map['id'].toString(),
      title: map['title'],
      description: map['description'],
      coverImgPath: map['cover_img_path'],
      categories: map['categories'] != null
          ? List<Category>.from(
              map['categories'].map((x) => Category.fromMap(x)))
          : null,
      author: map['author'] != null ? Author.fromMap(map['author']) : null,
      detailsHash: map['details_hash'],
    );
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'book_id': bookId,
      'title': title,
      'description': description,
      'cover_img_path': coverImgPath,
      'categories': categories != null
          ? List<dynamic>.from(categories!.map((x) => x.toMap()))
          : null,
      'author': author != null ? author!.toMap() : null,
    };
  }
}

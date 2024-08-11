import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';

import 'package:hive/hive.dart';
import 'category.dart';

part 'collection.g.dart';

@HiveType(typeId: 3) // Assign a unique type ID
class Collection {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  String? collectionImgPreSignedUrl;

  @HiveField(3)
  String collectionImgPath;

  @HiveField(4)
  List<Category>? categories = [];

  List<Book>? books = [];

  @HiveField(5)
  String? collectionImgLocalPath;

  Collection(
      {required this.id,
      required this.name,
      required this.description,
      required this.collectionImgPath,
      this.categories,
      this.books,
      this.collectionImgPreSignedUrl,
      this.collectionImgLocalPath});

  // Factory constructor to create a Collection from a map
  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
        id: map['id'].toString(),
        name: map['name'],
        description: map['description'],
        collectionImgPath: map['collection_img_path'] ?? '',
        categories: map['categories'] != null
            ? List<Category>.from(
                map['categories'].map((category) => Category.fromMap(category)))
            : [],
        collectionImgPreSignedUrl: map["collection_img_pre_signed_url"]);
  }

  // Method to convert a Collection object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'collection_img_path': collectionImgPath,
      'categories': categories != null
          ? categories!.map((category) => category.toMap()).toList()
          : [],
      'collection_img_pre_signed_url': collectionImgPreSignedUrl,
    };
  }
}

import 'package:book_frontend/models/books/category.dart';

class Collection {
  String id;
  String name;
  String description;
  String collectionImgPath;
  List<Category>? categories = [];

  Collection({
    required this.id,
    required this.name,
    required this.description,
    required this.collectionImgPath,
    this.categories,
  });

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
    );
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
    };
  }
}

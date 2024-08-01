import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  String name;

  @HiveField(1)
  int id;

  Category({this.id = -1, this.name = "Default"});

  // fromMap factory constructor
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
        name: map['category_name'] ?? "Default", id: map['category_id'] ?? 0);
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'category_id': id,
      'category_name': name,
    };
  }
}

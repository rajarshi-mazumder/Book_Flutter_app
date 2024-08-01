import 'package:hive/hive.dart';

part 'author.g.dart';

@HiveType(typeId: 2)
class Author {
  @HiveField(0)
  String name;

  Author({required this.name});

  // fromMap factory constructor
  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      name: map['name'],
    );
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}

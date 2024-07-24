class Category {
  String name;
  int id;
  Category({this.id = -1, this.name = "Default"});

  // fromMap factory constructor
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(name: map['category_name'] ?? "Default", id: map['category_id'] ?? 0);
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'category_id': id,
      'category_name': name,
    };
  }
}

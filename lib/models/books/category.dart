class Category {
  String name;
  int id;
  Category({this.id = -1, this.name = "Default"});

  // fromMap factory constructor
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(name: map['name'] ?? "Default", id: map['id'] ?? 0);
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }
}

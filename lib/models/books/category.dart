class Category {
  String name;
  Category({this.name = "Default"});

  // fromMap factory constructor
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] ?? "Default",
    );
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}

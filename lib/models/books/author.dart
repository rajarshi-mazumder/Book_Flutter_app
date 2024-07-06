class Author {
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

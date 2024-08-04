import 'package:book_frontend/models/books/collection.dart';
import 'package:hive/hive.dart';

class CollectionsCacheServices {
  Box<Collection>? _allCollectionsBox;

  CollectionsCacheServices() {
    _allCollectionsBox = Hive.box("all_collections");
  }

  Future<void> writeAllCollections(
      {required List<Collection> collectionsList}) async {
    // Iterate through the list of books and add each book to the box
    for (var collection in collectionsList) {
      try {
        await _allCollectionsBox?.add(collection);
      } catch (e) {
        print("book ${collection.name} already exists");
      }
    }
    readAllCollections();
  }

  Future<List<Collection>> readAllCollections() async {
    // Retrieve all books from the box and convert them to a list
    List<Collection>? collections = _allCollectionsBox?.values.toList();

    return collections ?? [];
  }

  deleteCollectionsListCache() {
    _allCollectionsBox?.clear();
  }
}

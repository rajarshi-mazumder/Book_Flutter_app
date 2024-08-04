import 'package:book_frontend/controllers/books_management/collections_data_master.dart';
import 'package:book_frontend/models/books/collection.dart';
import 'package:flutter/material.dart';

class CollectionsProvider extends ChangeNotifier {
  List<Collection> _collections = [];

  List<Collection> get collections => _collections;

  initActions() async {
   await getCollections();
    notifyListeners();
  }

  getCollections() async {
    _collections = await downloadCollectionList();
  }
}

Future<List<Collection>> downloadCollectionList() async {
  Map<String, dynamic>? collectionsListData =
      await CollectionsDataMaster.getCollections();

  List<Collection> collectionList = [];
  List? tempCollectionsList = collectionsListData?["collection_data"];

  if (tempCollectionsList != null) {
    for (var element in tempCollectionsList) {
      collectionList.add(Collection.fromMap(element));
    }
  }
  return collectionList;
}

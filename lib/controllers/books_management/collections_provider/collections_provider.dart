import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/collections_data_master.dart';
import 'package:book_frontend/controllers/books_management/collections_provider/collection_manager_mixin.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/collection.dart';
import 'package:book_frontend/services/cache_services/app_cache_services.dart';
import 'package:book_frontend/services/cache_services/collections_cache_services.dart';
import 'package:flutter/material.dart';

class CollectionsProvider extends ChangeNotifier with CollectionManagerMixin {
  List<Collection> _collections = [];

  List<Collection> get collections => _collections;

  initActions(
      {required AppDataProvider appDataProvider,
      required BooksProvider booksProvider}) async {
    await getCollections(appDataProvider: appDataProvider);
    generateBooksListForEachCollection(booksProvider: booksProvider);
    notifyListeners();
  }

  getCollections({required AppDataProvider appDataProvider}) async {
    bool needToDownloadCollectionsList =
        appDataProvider.checkIfShouldFetchCollections();
    if (needToDownloadCollectionsList) {
      print("Need to download collections- downloading and caching");
      _collections = await downloadCollectionList();

      CollectionsCacheServices().deleteCollectionsListCache();
      CollectionsCacheServices()
          .writeAllCollections(collectionsList: collections)
          .then((_) {
        AppCacheServices().writeLastCollectionsListVersion(
            collectionsListVersion: appDataProvider.lastCollectionsListVersion);
      });
    } else {
      print("No need to download collections- reading from cache");
      _collections = await CollectionsCacheServices().readAllCollections();
    }
  }

  generateBooksListForEachCollection({required BooksProvider booksProvider}) {
    for (int i = 0; i < collections.length; i++) {
      List<Book> bookListForCollection =
          getBookForCollection(collections[i], booksProvider.booksList);
      collections[i].books = bookListForCollection;
    }
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

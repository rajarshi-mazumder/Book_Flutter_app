import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/collections_data_master.dart';
import 'package:book_frontend/controllers/books_management/collections_provider/collection_manager_mixin.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/collection.dart';
import 'package:book_frontend/services/cache_services/app_cache_services.dart';
import 'package:book_frontend/services/cache_services/collections_cache_services.dart';
import 'package:flutter/material.dart';

class CollectionsProvider extends ChangeNotifier with CollectionManagerMixin {
  List<Collection> _collections = [];
  List<Collection> _recommendedCollections = [];

  List<Collection> get collections => _collections;

  List<Collection> get recommendedCollections => _recommendedCollections;

  initActions({
    required AppDataProvider appDataProvider,
    required BooksProvider booksProvider,
    required UserProvider userProvider,
  }) async {
    await getCollections(appDataProvider: appDataProvider);
    generateBooksListForEachCollection(booksProvider: booksProvider);
    generateRecommendedCollectionsList(userProvider: userProvider);
    sortCollectionsList(userProvider: userProvider);
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

  generateRecommendedCollectionsList({required UserProvider userProvider}) {
    _recommendedCollections = generateRecommendedCollections(
        userProvider.user?.interestedCategories, _collections);
    notifyListeners();
  }

  sortCollectionsList({required UserProvider userProvider}) {
    if (userProvider.user?.interestedCategories == null) {
      return;
    }
    _collections = sortCollectionsByUserInterest(
        collections, userProvider.user!.interestedCategories!);
    notifyListeners();
  }
}

import 'package:book_frontend/services/cache_services/app_cache_services.dart';
import 'package:flutter/cupertino.dart';

class AppDataProvider extends ChangeNotifier {
  String? _lastBooksListVersion;

  String? _lastCategoriesListVersion;

  String? _lastCollectionsListVersion;

  String? get lastBooksListVersion => _lastBooksListVersion;

  String? get lastCategoriesListVersion => _lastCategoriesListVersion;

  String? get lastCollectionsListVersion => _lastCollectionsListVersion;

  // books list version
  updateLastBooksListVersion({required String newBooksListVersion}) {
    _lastBooksListVersion = newBooksListVersion;
    notifyListeners();
  }

  bool checkIfShouldFetchBooks() {
    return (AppCacheServices().readLastBooksVersion() == null ||
        AppCacheServices().readLastBooksVersion() != lastBooksListVersion);
  }

  // categories list version
  updateLastCategoriesListVersion({required String newCategoriesListVersion}) {
    _lastCategoriesListVersion = newCategoriesListVersion;
    notifyListeners();
  }

  bool checkIfShouldFetchCategories() {
    return (AppCacheServices().readLastCategoriesVersion() == null ||
        AppCacheServices().readLastCategoriesVersion() !=
            lastCategoriesListVersion);
  }

  // collections list version
  updateLastCollectionsListVersion(
      {required String newCollectionsListVersion}) {
    _lastCollectionsListVersion = newCollectionsListVersion;
    notifyListeners();
  }

  bool checkIfShouldFetchCollections() {
    return (AppCacheServices().readLastCollectionsVersion() == null ||
        AppCacheServices().readLastCollectionsVersion() !=
            lastCollectionsListVersion);
  }
}

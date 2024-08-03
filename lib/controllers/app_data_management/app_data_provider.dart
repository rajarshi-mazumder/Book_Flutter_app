import 'package:book_frontend/services/cache_services/app_cache_services.dart';
import 'package:flutter/cupertino.dart';

class AppDataProvider extends ChangeNotifier {
  String? _lastBooksListVersion;

  String? _lastCategoriesListVersion;

  String? get lastBooksListVersion => _lastBooksListVersion;

  String? get lastCategoriesListVersion => _lastCategoriesListVersion;

  updateLastBooksListVersion({required String newBooksListVersion}) {
    _lastBooksListVersion = newBooksListVersion;
    notifyListeners();
  }

  bool checkIfShouldFetchBooks() {
    return AppCacheServices().readLastBooksVersion() != lastBooksListVersion;
  }

  updateLastCategoriesListVersion({required String newCategoriesListVersion}) {
    _lastCategoriesListVersion = newCategoriesListVersion;
    notifyListeners();
  }

  bool checkIfShouldFetchCategories() {
    return AppCacheServices().readLastCategoriesVersion() !=
        lastCategoriesListVersion;
  }
}

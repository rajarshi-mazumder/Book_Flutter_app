import 'package:hive_flutter/hive_flutter.dart';

class AppCacheServices {
  Box? _appDataBox;

  AppCacheServices() {
    _appDataBox = Hive.box('app_data');
  }

  // booksList
  writeLastBooksListVersion({String? booksListVersion}) {
    if (booksListVersion != null) {
      _appDataBox?.put('last_books_list_version', booksListVersion);
    }
  }

  String? readLastBooksVersion() {
    return _appDataBox?.get("last_books_list_version");
  }

  // categoriesList
  writeLastCategoriesListVersion({String? categoriesListVersion}) {
    if (categoriesListVersion != null) {
      _appDataBox?.put('last_categories_list_version', categoriesListVersion);
    }
  }

  String? readLastCategoriesVersion() {
    return _appDataBox?.get("last_categories_list_version");
  }

  // delete all data
  deleteAppData() {
    _appDataBox?.delete('last_books_list_version');
    _appDataBox?.delete('last_categories_list_version');
  }
}

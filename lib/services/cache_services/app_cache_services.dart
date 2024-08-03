import 'package:hive_flutter/hive_flutter.dart';

class AppCacheServices {
  Box? _appDataBox;

  AppCacheServices() {
    _appDataBox = Hive.box('app_data');
  }

  writeLastBooksListVersion({String? booksListVersion}) {
    if (booksListVersion != null) {
      _appDataBox?.put('last_books_list_version', booksListVersion);
    }
  }

  String? readLastBooksVersion() {
    return _appDataBox?.get("last_books_list_version");
  }

  deleteAppData() {
    _appDataBox?.delete('last_books_list_version');
  }
}

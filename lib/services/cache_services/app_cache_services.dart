import 'package:hive_flutter/hive_flutter.dart';

// Check if the last books list version is up to date. If not, then fetch books and save the new last books list version.
//
// Also, if it is null, then fetch books and save the new last books list version.

class AppCacheServices {
  Box? _appDataBox;

  String? readLastBooksVersion() {
    return _appDataBox?.get("last_books_list_version");
  }
}

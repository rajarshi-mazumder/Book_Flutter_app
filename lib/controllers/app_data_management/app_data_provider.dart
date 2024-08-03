import 'package:book_frontend/services/cache_services/app_cache_services.dart';
import 'package:flutter/cupertino.dart';

class AppDataProvider extends ChangeNotifier {
  String? _lastBooksListVersion;
  bool _shouldFetchBooks = false;

  String? get lastBooksListVersion => _lastBooksListVersion;

  bool? get shouldFetchBooks => _shouldFetchBooks;

  updateLastBooksListVersion({required String newBooksListVersion}) {
    _lastBooksListVersion = newBooksListVersion;
    notifyListeners();
  }

  bool checkIfShouldFetchBooks() {
    return AppCacheServices().readLastBooksVersion() != lastBooksListVersion;
  }
}

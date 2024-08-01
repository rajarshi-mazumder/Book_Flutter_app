import 'package:flutter/cupertino.dart';

class AppDataProvider extends ChangeNotifier {
  String? _lastBooksListVersion;

  String? get lastBooksListVersion => _lastBooksListVersion;

  updateLastBooksListVersion({required String newBooksListVersion}) {
    _lastBooksListVersion = newBooksListVersion;
    notifyListeners();
  }
}

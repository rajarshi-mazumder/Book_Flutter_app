import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserCacheServices {
  Box? _userDataBox;

  UserCacheServices() {
    _userDataBox = Hive.box('user_data');
  }

  writeUserBooksStarted({required String bookIdToSave}) async {
    // Write the file
    try {
      //read books_started
      List<Map<String, dynamic>>? savedBooksStarted = [];
      final tempSavedBooksStarted = _userDataBox?.get('books_started');
      if (tempSavedBooksStarted != null) {
        for (var t in tempSavedBooksStarted) {
          savedBooksStarted.add(getBookStartedAsMap(t));
        }
      }

      for (Map<String, dynamic> bookData in savedBooksStarted!) {
        if (bookData["book_id"] == bookIdToSave) return;
      }

      savedBooksStarted
          .add({"book_id": bookIdToSave, "started_date": DateTime.now()});

      _userDataBox!.put('books_started', savedBooksStarted);
    } catch (e) {
      if (kDebugMode) {
        print("Error saving book started $e");
      }
    }
  }

  List<Map<String, dynamic>>? readUserBooksStarted() {
    try {
      List<Map<String, dynamic>>? savedBooksStarted = [];
      final tempSavedBooksStarted = _userDataBox?.get('books_started');

      if (tempSavedBooksStarted != null) {
        for (var t in tempSavedBooksStarted) {
          savedBooksStarted.add(getBookStartedAsMap(t));
        }
      }

      return savedBooksStarted;
    } catch (e) {
      print("Could not read saved books");
      return null;
    }
  }

  Map<String, dynamic> getBookStartedAsMap(final bookStartedDynamicData) {
    return {
      "book_id": bookStartedDynamicData["book_id"],
      "started_date": bookStartedDynamicData["started_date"]
    };
  }
}

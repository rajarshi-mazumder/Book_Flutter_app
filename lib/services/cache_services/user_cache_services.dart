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

  writeUserInterestedCategories({required String categoryIdToSave}) {
    try {
      List<Map<String, dynamic>>? savedInterestedCategories = [];
      final tempSavedInterestedCategories =
          _userDataBox?.get('interested_categories');

      if (tempSavedInterestedCategories != null) {
        for (var t in tempSavedInterestedCategories) {
          savedInterestedCategories.add(Map<String, dynamic>.from(t));
        }
      }

      for (Map<String, dynamic> categoryData in savedInterestedCategories) {
        if (categoryData["category_id"] == categoryIdToSave) return;
      }

      savedInterestedCategories.add({
        "category_id": categoryIdToSave,
        "interested_date": DateTime.now().toIso8601String()
      });

      _userDataBox!.put('interested_categories', savedInterestedCategories);
    } catch (e) {
      print("Unable to save interested category $e");
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

  List<Map<String, dynamic>>? readUserInterestedCategories() {
    try {
      List<Map<String, dynamic>>? savedInterestedCategories = [];
      final tempSavedInterestedCategories =
          _userDataBox?.get('interested_categories');

      if (tempSavedInterestedCategories != null) {
        for (var t in tempSavedInterestedCategories) {
          savedInterestedCategories.add(getInterestedCategoryAsMap(t));
        }
      }

      return savedInterestedCategories;
    } catch (e) {
      print("Could not read interested categories");
      return null;
    }
  }

  Map<String, dynamic> getBookStartedAsMap(final bookStartedDynamicData) {
    return {
      "book_id": bookStartedDynamicData["book_id"],
      "started_date": bookStartedDynamicData["started_date"]
    };
  }

  Map<String, dynamic> getInterestedCategoryAsMap(
      final interestedCategoryDynamicData) {
    return {
      "category_id": interestedCategoryDynamicData["category_id"],
      "interested_date": interestedCategoryDynamicData["interested_date"]
    };
  }

  deleteUserStoredData() {
    _userDataBox?.delete('interested_categories');
    _userDataBox?.delete('books_started');
  }
}

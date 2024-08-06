import 'dart:async';

import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:book_frontend/controllers/books_management/book_provider/book_details_mixin.dart';
import 'package:book_frontend/controllers/books_management/book_utilities/sort_utilities.dart';
import 'package:book_frontend/controllers/books_management/books_data_master.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/models/books/collection.dart';
import 'package:book_frontend/services/cache_services/book_cache_services.dart';
import 'package:flutter/material.dart';

import 'book_getter_mixin.dart';

class BooksProvider extends ChangeNotifier
    with BookGetterMixin, BookDetailsMixin {
  List<Book> _booksList = [];

  List<Book> get booksList => _booksList;

  List<Book> _recommendedBooks = [];

  bool hasNext = true;

  List<Book> get recommendedBooks => _recommendedBooks;

  static final StreamController _booksFetchedStreamController =
      StreamController.broadcast();

  static Stream get booksFetchedStreamController =>
      _booksFetchedStreamController.stream;

  initActions(
      {required AppDataProvider appDataProvider,
      required UserProvider userProvider}) async {
    _booksList = await getBooks(
        appDataProvider: appDataProvider, userProvider: userProvider);
    sortBooks(booksStarted: userProvider.user?.booksStarted);
    if (userProvider.user != null &&
        userProvider.user!.interestedCategories != null) {
      await getRecommendedBooks(
          interestedCategories: userProvider.user!.interestedCategories!);
    }
    _booksFetchedStreamController.add(null);
    notifyListeners();
  }

  getRecommendedBooks(
      {required List<Map<String, dynamic>> interestedCategories}) {
    _recommendedBooks = sortBooksByRecommendation(
        booksList: booksList, interestedCategories: interestedCategories);
    notifyListeners();
  }

  void sortBooks({List<Map<String, dynamic>>? booksStarted}) {
    _booksList = sortBooksByRelevance(
        booksStarted: booksStarted, bookListToSort: _booksList);
    notifyListeners();
  }
}

import 'dart:async';

import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:book_frontend/controllers/books_management/book_provider/book_details_mixin.dart';
import 'package:book_frontend/controllers/books_management/book_utilities/sort_utilities.dart';
import 'package:book_frontend/controllers/books_management/books_data_master.dart';
import 'package:book_frontend/controllers/s3_management/s3_management.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/models/books/collection.dart';
import 'package:book_frontend/services/cache_services/book_cache_services.dart';
import 'package:flutter/material.dart';
import 'package:book_frontend/controllers/s3_management/s3_image_getter_mixin.dart';
import 'book_getter_mixin.dart';
import 'package:path_provider/path_provider.dart';

class BooksProvider extends ChangeNotifier
    with BookGetterMixin, BookDetailsMixin, S3ImageGetterMixin {
  List<Book> _booksList = [];

  List<Book> get booksList => _booksList;

  List<Book> _recommendedBooks = [];

  bool hasNext = true;

  List<Book> get recommendedBooks => _recommendedBooks;

  static Future<String> coverImageBaseLocalPath() async {
    // final directory = await getApplicationDocumentsDirectory();
    final directory = await getExternalStorageDirectory();
    String filePath = '${directory?.path}/book_cover_images';
    return filePath;
  }

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

  Future<String?> getBookImage({required String bookId}) async {
    for (Book b in _booksList) {
      if (b.bookId == bookId) {
        if (b.coverImgLocalPath == null) {
          print("Book ${b.title} coverImgLocal is null");
          if (b.coverImgPath == null) {
            return null;
          }
          String basePath = await coverImageBaseLocalPath();
          String savePath = "$basePath/${b.bookId}.jpg";
          String? preSignedUrl;
          if (b.coverImgPath != null) {
            preSignedUrl = await getPreSignedUrl(fileName: b.coverImgPath!);
          }
          String? localFilePath = await fetchS3Object(
              imgPath: b.coverImgPath!,
              savePath: savePath,
              preSignedUrlStr: preSignedUrl);
          b.coverImgLocalPath = localFilePath;
          if (localFilePath != null) {
            BookCacheServices().updateBookInHive(updatedBook: b);
          }
          return b.coverImgLocalPath;
        } else {
          return b.coverImgLocalPath!;
        }
      }
    }
    return null;
  }
}

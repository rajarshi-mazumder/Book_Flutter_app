import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/books_data_master.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/services/cache_services/app_cache_services.dart';
import 'package:book_frontend/services/cache_services/book_cache_services.dart';
import 'package:flutter/material.dart';

mixin BookGetterMixin on ChangeNotifier {
  int _booksPaginationNumber = 1;

  int get booksPaginationNumber => _booksPaginationNumber;

  Future<List<Book>> getBooks(
      {required AppDataProvider appDataProvider,
      required UserProvider userProvider}) async {
    List<Book> booksList = [];
    bool needToDownloadBookslist = appDataProvider.checkIfShouldFetchBooks();

    // if (!hasNext) {
    //   return;
    // }
    if (needToDownloadBookslist) {
      print("Need to download books- downloading and caching");

      booksList = await downloadBooksList(
          userProvider: userProvider,
          booksPaginationNumber: booksPaginationNumber);

      // delete existing bookList cache and write new cache
      BookCacheServices().deleteBooksListCache();
      BookCacheServices().writeAllBooks(booksList: booksList).then((_) {
        AppCacheServices().writeLastBooksListVersion(
            booksListVersion: appDataProvider.lastBooksListVersion);
      });
    } else {
      print("No need to download books- reading from cache");

      booksList = await BookCacheServices().readAllBooks();
    }
    return booksList;
  }

  Future<List<Book>> downloadBooksList(
      {required UserProvider userProvider,
      required int booksPaginationNumber}) async {
    List<Book> booksList = [];
    Map<String, dynamic>? booksListData = await BooksDataMaster.getBooks(
        userProvider: userProvider,
        booksPaginationNumber: booksPaginationNumber);

    List? tempbooksList = booksListData?["books"];
    // hasNext = booksListData?["has_next"];

    if (tempbooksList != null) {
      for (var element in tempbooksList) {
        booksList.add(Book.fromMap(element));
      }
      _booksPaginationNumber += 1;
    }
    return booksList;
  }
}

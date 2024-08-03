import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/books_data_master.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:flutter/material.dart';

mixin BookGetterMixin on ChangeNotifier {
  int _booksPaginationNumber = 1;

  int get booksPaginationNumber => _booksPaginationNumber;

  Future<void> getBooks(
      {required UserProvider userProvider,
      required List<Book> booksList}) async {
    // if (!hasNext) {
    //   return;
    // }
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
  }
}

import 'package:book_frontend/controllers/books_management/books_data_master.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:flutter/material.dart';

class BooksProvider extends ChangeNotifier {
  List<Book> _booksList = [];

  List<Book> get booksList => _booksList;

  getBooks({required UserProvider userProvider}) async {
    List? booksList =
        await BooksDataMaster.getBooks(userProvider: userProvider);
    booksList?.forEach((element) {
      _booksList.add(Book.fromMap(element));
    });

    notifyListeners();
  }

  Future<Map<String, dynamic>?> getBookDetails(
      {required UserProvider userProvider, required int bookId}) async {
    Map<String, dynamic>? bookDataMap = await BooksDataMaster.getBookDetails(
        userProvider: userProvider, bookId: bookId);

    for (Book b in _booksList) {
      if (b.bookId == bookId.toString()) {
        List<Map<String, dynamic>> chapters = [];
        bookDataMap?["book_details"]["book_chapters"]
            .forEach((e) => chapters.add(e as Map<String, dynamic>));

        print(chapters);
        b.bookDetails =
            BookDetails(bookId: bookId.toString(), chapters: chapters);
        break;
      }
    }
    notifyListeners();
  }
}

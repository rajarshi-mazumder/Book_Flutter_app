import 'package:book_frontend/controllers/books_management/books_data_master.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:book_frontend/services/cache_services/cache_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BooksProvider extends ChangeNotifier {
  List<Book> _booksList = [];

  List<Book> get booksList => _booksList;

  getBooks({required UserProvider userProvider}) async {
    _booksList = [];
    List? booksList =
        await BooksDataMaster.getBooks(userProvider: userProvider);
    booksList?.forEach((element) {
      _booksList.add(Book.fromMap(element));
    });

    notifyListeners();
  }

  /// gets the book's details either from storage if already stored,
  /// if not then get it from API and then store it
  Future<Map<String, dynamic>?> getBookDetails(
      {required UserProvider userProvider, required Book book}) async {
    // read book if its stored in cache
    Map<String, dynamic>? bookDetails =
        await readBookDetailsFromStorage(book: book);

    // if book is not stored, then get books using BooksDataMaster.getBookDetails()
    // and then store it in cache
    if (bookDetails?["needToDownload"] == true) {
      if (kDebugMode) {
        print("Need to download book ${book.bookId}");
      }
      Map<String, dynamic>? bookDataMap = await BooksDataMaster.getBookDetails(
          userProvider: userProvider, bookId: int.parse(book.bookId));

      BookDetails? bookDetailsToSave = setBookDetailsInProvider(
          bookId: book.bookId,
          bookChapters: bookDataMap?["book_details"]["book_chapters"]);

      writeBookDetailsIntoStorage(bookDetails: bookDetailsToSave!, book: book);
    }
    // if book is in stored cache, then set provider variable to stored book
    else {
      setBookDetailsInProvider(
          bookId: book.bookId, bookChapters: bookDetails?["chapters"]);
    }
  }

  /// sets the book's details in the book object in the _booksList in the provider
  BookDetails? setBookDetailsInProvider(
      {required String bookId, required List? bookChapters}) {
    for (Book b in _booksList) {
      if (b.bookId == bookId.toString()) {
        List<Map<String, dynamic>> chapters = [];

        bookChapters?.forEach((e) => chapters.add(e as Map<String, dynamic>));

        b.bookDetails =
            BookDetails(bookId: bookId.toString(), chapters: chapters);
        notifyListeners();
        return b.bookDetails;
      }
    }
  }

  // writes the book into storage
  writeBookDetailsIntoStorage(
      {required BookDetails bookDetails, required Book book}) {
    CacheServices().writeBookChapters(bookDetails: bookDetails, book: book);
  }

  // reads the book from storage
  Future<Map<String, dynamic>?> readBookDetailsFromStorage(
      {required Book book}) async {
    Map<String, dynamic>? bookDetails =
        await CacheServices().readBookChapters(book: book);
    return bookDetails;
  }
}

import 'package:book_frontend/controllers/books_management/books_data_master.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:book_frontend/services/cache_services/cache_services.dart';
import 'package:flutter/material.dart';

mixin BookDetailsMixin on ChangeNotifier {
  /// gets the book's details either from storage if already stored,
  /// if not then get it from API and then store it
  Future<Map<String, dynamic>?> getBookDetails(
      {required List<Book> booksList,
      required UserProvider userProvider,
      required Book book}) async {
    // read book if its stored in cache
    Map<String, dynamic>? bookDetails =
        await readBookDetailsFromStorage(book: book);

    // if book is not stored, then get books using BooksDataMaster.getBookDetails()
    // and then store it in cache
    if (bookDetails?["needToDownload"] == true) {
      print("Need to download book ${book.bookId}");

      Map<String, dynamic>? bookDataMap = await BooksDataMaster.getBookDetails(
          userProvider: userProvider, bookId: int.parse(book.bookId));

      if (bookDataMap != null && bookDataMap["book_details"] != null) {
        BookDetails? bookDetailsToSave = setBookDetailsInProvider(
            booksList: booksList,
            bookId: book.bookId,
            bookChapters: bookDataMap?["book_details"]["book_chapters"]);
        writeBookDetailsIntoStorage(
            bookDetails: bookDetailsToSave!, book: book);
      }
    }
    // if book is in stored cache, then set provider variable to stored book
    else {
      setBookDetailsInProvider(
          booksList: booksList,
          bookId: book.bookId,
          bookChapters: bookDetails?["chapters"]);
    }

    return null;
  }

  // reads the book from storage
  Future<Map<String, dynamic>?> readBookDetailsFromStorage(
      {required Book book}) async {
    Map<String, dynamic>? bookDetails =
        await CacheServices().readBookChapters(book: book);
    return bookDetails;
  }

  /// sets the book's details in the book object in the _booksList in the provider
  BookDetails? setBookDetailsInProvider(
      {required List<Book> booksList,
      required String bookId,
      required List? bookChapters}) {
    for (Book b in booksList) {
      if (b.bookId == bookId.toString()) {
        List<Map<String, dynamic>> chapters = [];

        bookChapters?.forEach((e) => chapters.add(e as Map<String, dynamic>));

        b.bookDetails =
            BookDetails(bookId: bookId.toString(), chapters: chapters);
        notifyListeners();
        return b.bookDetails;
      }
    }
    return null;
  }

  // writes the book into storage
  writeBookDetailsIntoStorage(
      {required BookDetails bookDetails, required Book book}) {
    CacheServices().writeBookChapters(bookDetails: bookDetails, book: book);
  }
}

import 'package:book_frontend/controllers/books_management/book_utilities/sort_utilities.dart';
import 'package:book_frontend/controllers/books_management/books_data_master.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/services/cache_services/cache_services.dart';
import 'package:flutter/material.dart';

class BooksProvider extends ChangeNotifier {
  List<Book> _booksList = [];
  List<Book> _recommendedBooks = [];

  int _booksPaginationNumber = 1;
  bool hasNext = true;

  List<Book> get booksList => _booksList;

  List<Book> get recommendedBooks => _recommendedBooks;

  int get booksPaginationNumber => _booksPaginationNumber;

  initActions({required UserProvider userProvider}) async {
    await getBooks(userProvider: userProvider);
    if (userProvider.user != null &&
        userProvider.user!.interestedCategories != null) {
      await getRecommendedBooks(
          interestedCategories: userProvider.user!.interestedCategories!);
    }
  }

  Future<void> getBooks({required UserProvider userProvider}) async {
    if (!hasNext) {
      return;
    }
    Map<String, dynamic>? booksListData = await BooksDataMaster.getBooks(
        userProvider: userProvider,
        booksPaginationNumber: booksPaginationNumber);

    List? booksList = booksListData?["books"];
    hasNext = booksListData?["has_next"];

    if (booksList != null) {
      for (var element in booksList) {
        _booksList.add(Book.fromMap(element));
      }
      _booksPaginationNumber += 1;
      sortBooks(booksStarted: userProvider.user?.booksStarted);
      notifyListeners();
    }
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
      print("Need to download book ${book.bookId}");

      Map<String, dynamic>? bookDataMap = await BooksDataMaster.getBookDetails(
          userProvider: userProvider, bookId: int.parse(book.bookId));

      if (bookDataMap != null && bookDataMap!["book_details"] != null) {
        BookDetails? bookDetailsToSave = setBookDetailsInProvider(
            bookId: book.bookId,
            bookChapters: bookDataMap?["book_details"]["book_chapters"]);
        writeBookDetailsIntoStorage(
            bookDetails: bookDetailsToSave!, book: book);
      }
    }
    // if book is in stored cache, then set provider variable to stored book
    else {
      setBookDetailsInProvider(
          bookId: book.bookId, bookChapters: bookDetails?["chapters"]);
    }

    return null;
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
    return null;
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

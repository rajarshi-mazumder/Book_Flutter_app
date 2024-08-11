import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookCacheServices {
  Box? _bookDataBox;
  Box<Book>? _allBooksBox;

  BookCacheServices() {
    _bookDataBox = Hive.box('books_data');
    _allBooksBox = Hive.box('all_books');
  }

  Future<void> writeAllBooks({required List<Book> booksList}) async {
    // Iterate through the list of books and add each book to the box
    for (var book in booksList) {
      try {
        await _allBooksBox?.add(book);
      } catch (e) {
        print("book ${book.title} already exists");
      }
    }
    readAllBooks();
  }

  Future<void> updateBookInHive({required Book updatedBook}) async {
    try {
      // Find the book by its unique identifier (bookId)
      final bookKey = _allBooksBox?.keys.firstWhere(
        (key) {
          final book = _allBooksBox?.get(key);
          return book?.bookId == updatedBook.bookId;
        },
        orElse: () => null,
      );

      // If the book exists in Hive, update it
      if (bookKey != null) {
        await _allBooksBox?.put(bookKey, updatedBook);
        print(
            "Book '${updatedBook.title} ${updatedBook.coverImgLocalPath}' updated successfully in Hive.");
      } else {
        print("Book with id '${updatedBook.bookId}' not found.");
      }
    } catch (e) {
      print("Error updating book '${updatedBook.title}': $e");
    }
  }

  Future<List<Book>> readAllBooks() async {
    // Retrieve all books from the box and convert them to a list
    List<Book>? books = _allBooksBox?.values.toList();

    return books ?? [];
  }

  writeBookChapters(
      {required BookDetails bookDetails, required Book book}) async {
    // Write the file
    try {
      _bookDataBox!.put('book_${bookDetails.bookId}', bookDetails.chapters);
      _bookDataBox!
          .put('book_${bookDetails.bookId}_details_hash', book.detailsHash);
    } catch (e) {
      print("Error writing book $e");
    }
  }

  Future<Map<String, dynamic>?> readBookChapters({required Book book}) async {
    List<Map<String, dynamic>> chapters = [];
    bool isBookHashMatches = false;
    try {
      isBookHashMatches = checkIfBookHashMatches(book: book);
      if (isBookHashMatches) {
        final contents = _bookDataBox?.get('book_${book.bookId}');

        contents.forEach((chapter) {
          chapters.add(Map<String, dynamic>.from(chapter));
        });
      }
    } catch (e) {
      // If encountering an error, return 0
      print("Error reading book at ${book.bookId} $e");
    }
    return {"chapters": chapters, 'needToDownload': !isBookHashMatches};
  }

  bool checkIfBookHashMatches({required Book book}) {
    final savedDetailsHash =
        _bookDataBox?.get('book_${book.bookId}_details_hash');
    print("Saved hash $savedDetailsHash");
    print("Hash from cloud ${book.detailsHash}");
    return savedDetailsHash != null && savedDetailsHash == book.detailsHash;
  }

  deleteBooksListCache() {
    _allBooksBox?.clear();
  }

  deleteAllBookCache({required BooksProvider booksProvider}) {
    deleteBooksListCache();
    _bookDataBox?.clear();

    // for (Book b in booksProvider.booksList) {
    //   _bookDataBox?.delete('book_${b.bookId}');
    // }
  }
}

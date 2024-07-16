import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheServices {
  Box? _bookDataBox;
  CacheServices() {
    _bookDataBox = Hive.box('books_data');
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

  deleteBookChapters({required String bookId}) {
    _bookDataBox?.delete('book_$bookId');
    _bookDataBox?.delete('book_${bookId}_details_hash');
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheServices {
  Box? _bookDataBox;
  CacheServices() {
    _bookDataBox = Hive.box('books_data');
  }
  Future<File?> writeBookChapters({required BookDetails bookDetails}) async {
    // Write the file
    try {
      _bookDataBox!.put('book_${bookDetails.bookId}', bookDetails.chapters);
    } catch (e) {
      print("Error writing book $e");
    }
  }

  Future<Map<String, dynamic>?> readBookChapters(
      {required String bookId}) async {
    try {
      final contents = _bookDataBox?.get('book_$bookId');

      List<Map<String, dynamic>> chapters = [];

      contents.forEach((chapter) {
        chapters.add(Map<String, dynamic>.from(chapter));
      });

      return {"chapters": chapters};
    } catch (e) {
      // If encountering an error, return 0
      print("Error reading book at $bookId $e");
    }
  }
}

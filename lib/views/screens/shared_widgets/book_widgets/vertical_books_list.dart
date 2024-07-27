import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/vertical_book_tile.dart';
import 'package:flutter/material.dart';

class VerticalBooksList extends StatelessWidget {
  VerticalBooksList({super.key, required this.booksList});

  List<Book> booksList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: booksList.map((e) => BookTile(book: e)).toList(),
    );
  }
}

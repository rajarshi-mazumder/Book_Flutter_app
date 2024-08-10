import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/theme/text_themes.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/vertical_book_tile.dart';
import 'package:flutter/material.dart';

class VerticalBooksList extends StatelessWidget {
  const VerticalBooksList({super.key, required this.booksList});

  final List<Book> booksList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: booksList.map((e) => VerticalBookTile(book: e)).toList(),
    );
  }
}

class VerticalBooksListHeader extends StatelessWidget {
  const VerticalBooksListHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    TextTheme appTextTheme = Theme.of(context).textTheme;
    return Text(
      label,
      style: headerLargeStyle(appTextTheme),
    );
  }
}

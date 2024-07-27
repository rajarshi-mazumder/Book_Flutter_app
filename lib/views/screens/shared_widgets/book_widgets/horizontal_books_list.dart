import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/theme/text_themes.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/short_book_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/vertical_book_tile.dart';
import 'package:flutter/material.dart';

class HorizontalBooksList extends StatelessWidget {
  const HorizontalBooksList({super.key, required this.booksList});

  final List<Book> booksList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SHORT_BOOK_TILE_HEIGHT,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: booksList.map((e) => ShortBookTile(book: e)).toList(),
      ),
    );
  }
}

class RecommendedBooksHeader extends StatelessWidget {
  const RecommendedBooksHeader({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme appTextTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 5),
      child: Text(
        "Recommended Books",
        style: headerLargeStyle(appTextTheme),
      ),
    );
  }
}

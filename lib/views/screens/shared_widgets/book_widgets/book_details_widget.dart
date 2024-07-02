import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/book_chapter_page_view.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/book_tile.dart';
import 'package:flutter/material.dart';

class BookDetailsWidget extends StatelessWidget {
  BookDetailsWidget({super.key, required this.book, required this.bookDetails});
  BookDetails bookDetails;
  Book book;
  @override
  Widget build(BuildContext context) {
    TextTheme appTextTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(generalMargin),
          child: Column(
            children: [
              BookTile(
                book: book,
                showDescription: false,
                isTappable: false,
              ),
              Expanded(
                child: BookChapters(bookDetails: bookDetails),
              ),
            ],
          )),
    );
  }
}

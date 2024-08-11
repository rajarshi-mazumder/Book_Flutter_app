import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/vertical_books_list.dart';
import 'package:flutter/material.dart';
import 'package:book_frontend/views/screens/shared_widgets/navigation_widgets/nav_bar.dart';

class BooksListPage extends StatelessWidget {
  const BooksListPage(
      {super.key, required this.booksList, required this.label});

  final List<Book> booksList;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: Container(
        margin: EdgeInsets.all(generalMargin),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VerticalBooksListHeader(label: label),
              VerticalBooksList(booksList: booksList),
            ],
          ),
        ),
      ),
    );
  }
}

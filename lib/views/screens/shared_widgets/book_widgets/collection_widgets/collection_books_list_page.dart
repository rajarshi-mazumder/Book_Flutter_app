import 'package:book_frontend/models/books/collection.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/vertical_books_list.dart';
import 'package:flutter/material.dart';
import 'package:book_frontend/views/screens/shared_widgets/navigation_widgets/nav_bar.dart';

class CollectionBooksListPage extends StatelessWidget {
  CollectionBooksListPage({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Navbar(),
        body: SingleChildScrollView(child: VerticalBooksList(booksList: collection.books ?? [])));
  }
}

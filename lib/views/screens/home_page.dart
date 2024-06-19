import 'package:book_frontend/data/books_data.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/books_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> booksList = sampleBooks;
  List<Book> filteredBooksList = [];

  filterBooksByCategory({required Category categoryToFilterBy}) {
    setState(() {
      filteredBooksList = sampleBooks.where((book) {
        for (Category cat in book.categories!) {
          if (cat.name == categoryToFilterBy.name) return true;
        }
        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BooksList(
                booksList: filteredBooksList.isNotEmpty
                    ? filteredBooksList
                    : booksList),
          ],
        ),
      ),
    );
  }
}

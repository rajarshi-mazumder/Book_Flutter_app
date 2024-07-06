import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/data/books_data.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/books_list.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/navigation_widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  resetFilteredBooks() {
    setState(() {
      filteredBooksList = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: Navbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Welcome ${userProvider.user}"),
            Container(
              height: 40,
              margin: EdgeInsets.all(generalMargin),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: generalMargin),
                      child: GestureDetector(
                        child: CategoryTile(category: Category(name: "All")),
                        onTap: () {
                          resetFilteredBooks();
                        },
                      )),
                  ...categoryMap.entries
                      .map((e) => Container(
                          margin: EdgeInsets.only(right: generalMargin),
                          child: GestureDetector(
                            child: CategoryTile(category: e.value),
                            onTap: () {
                              print(e.value.name);
                              filterBooksByCategory(
                                  categoryToFilterBy: e.value);
                            },
                          )))
                      .toList()
                ],
              ),
            ),
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

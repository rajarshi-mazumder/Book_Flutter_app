import 'package:book_frontend/controllers/books_management/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider.dart';
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
  List<Book> filteredBooksList = [];

  filterBooksByCategory(
      {required BooksProvider booksProvider,
      required Category categoryToFilterBy}) {
    setState(() {
      filteredBooksList = booksProvider.booksList.where((book) {
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

  fetchCategories(
      {required UserProvider userProvider,
      required CategoriesProvider categoriesProvider}) {
    categoriesProvider.getCategories(userProvider: userProvider);
  }

  fetchBooks(
      {required UserProvider userProvider,
      required BooksProvider booksProvider}) {
    booksProvider.getBooks(userProvider: userProvider);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      CategoriesProvider categoriesProvider =
          Provider.of<CategoriesProvider>(context, listen: false);

      BooksProvider booksProvider =
          Provider.of<BooksProvider>(context, listen: false);

      fetchCategories(
          userProvider: userProvider, categoriesProvider: categoriesProvider);

      fetchBooks(userProvider: userProvider, booksProvider: booksProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    CategoriesProvider categoriesProvider =
        Provider.of<CategoriesProvider>(context);
    BooksProvider booksProvider = Provider.of<BooksProvider>(context);

    List<Category> categories = categoriesProvider.categoriesList;

    return Scaffold(
      appBar: Navbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                "Welcome ${userProvider.user?.name}, ${userProvider.user?.email} "),
            Text(
                '${userProvider.user?.booksStarted?.map((e) => e["book_id"]).toList()}'),
            Container(
              height: 40,
              margin: EdgeInsets.all(generalMargin),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: generalMargin),
                      child: GestureDetector(
                        child: CategoryTile(
                            category: Category(name: "All", id: -1)),
                        onTap: () {
                          resetFilteredBooks();
                        },
                      )),
                  ...categories
                      .map((e) => Container(
                          margin: EdgeInsets.only(right: generalMargin),
                          child: GestureDetector(
                            child: CategoryTile(category: e),
                            onTap: () {
                              filterBooksByCategory(
                                  booksProvider: booksProvider,
                                  categoryToFilterBy: e);
                            },
                          )))
                      .toList()
                ],
              ),
            ),
            BooksList(
                booksList: filteredBooksList.isNotEmpty
                    ? filteredBooksList
                    : booksProvider.booksList),
          ],
        ),
      ),
    );
  }
}

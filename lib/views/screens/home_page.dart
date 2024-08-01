import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:book_frontend/controllers/books_management/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/data/books_data.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/short_book_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/vertical_book_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/category_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/horizontal_books_list.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/vertical_books_list.dart';
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
  final ScrollController _scrollController = ScrollController();
  String? _lastBooksListVersion;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      AppDataProvider appDataProvider =
          Provider.of<AppDataProvider>(context, listen: false);

      _lastBooksListVersion = appDataProvider.lastBooksListVersion;

      CategoriesProvider categoriesProvider =
          Provider.of<CategoriesProvider>(context, listen: false);

      categoriesProvider.initActions(userProvider: userProvider);
      BooksProvider booksProvider =
          Provider.of<BooksProvider>(context, listen: false);

      booksProvider.initActions(userProvider: userProvider);

      // _scrollController.addListener(() {
      //   if (_scrollController.position.atEdge) {
      //     if (_scrollController.position.pixels != 0) {
      //       // User has scrolled to the bottom
      //       UserProvider userProvider =
      //           Provider.of<UserProvider>(context, listen: false);
      //       BooksProvider booksProvider =
      //           Provider.of<BooksProvider>(context, listen: false);
      //       booksProvider.initActions(userProvider: userProvider);
      //     }
      //   }
      // });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Welcome ${userProvider.user?.name}, ${userProvider.user?.email} "),
            Text(
                '${userProvider.user?.booksStarted?.map((e) => e["book_id"]).toList()}'),
            Text(
                '${userProvider.user?.interestedCategories?.map((e) => e["category_id"]).toList()}'),
            Text(_lastBooksListVersion.toString()),
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
            RecommendedBooksHeader(),
            HorizontalBooksList(booksList: booksProvider.recommendedBooks),
            VerticalBooksList(
                booksList: filteredBooksList.isNotEmpty
                    ? filteredBooksList
                    : booksProvider.booksList),
          ],
        ),
      ),
    );
  }
}

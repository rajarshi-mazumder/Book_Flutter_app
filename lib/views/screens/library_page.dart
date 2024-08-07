import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/category_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/horizontal_books_list.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/vertical_books_list.dart';
import 'package:book_frontend/views/screens/shared_widgets/navigation_widgets/bottom_nav_bar.dart';
import 'package:book_frontend/views/screens/shared_widgets/navigation_widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Book> filteredBooksList = [];
  final ScrollController _scrollController = ScrollController();

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
  Widget build(BuildContext context) {
    CategoriesProvider categoriesProvider =
        Provider.of<CategoriesProvider>(context);
    UserProvider userProvider = context.watch<UserProvider>();
    BooksProvider booksProvider = Provider.of<BooksProvider>(context);

    List<Category> categories = categoriesProvider.categoriesList;
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        HorizontalBooksList(
          booksList: booksProvider.booksList
              .sublist(0, userProvider.user?.booksStarted?.length),
          label: "Your Learning",
        ),
        Container(
          height: 40,
          margin: EdgeInsets.all(generalMargin),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                  margin: EdgeInsets.only(right: generalMargin),
                  child: GestureDetector(
                    child:
                        CategoryTile(category: Category(name: "All", id: -1)),
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
        VerticalBooksList(
            booksList: filteredBooksList.isNotEmpty
                ? filteredBooksList
                : booksProvider.booksList),
        const SizedBox(height: 80)
      ],
    ));
  }
}

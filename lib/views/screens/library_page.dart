import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/category_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/horizontal_books_list.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/utility_functions/filter_books_by_category.dart';
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
  Category? selectedCategory;

  filterBooksListByCategory(
      {required BooksProvider booksProvider,
      required Category categoryToFilterBy}) {
    setState(() {
      filteredBooksList = filterBooksByCategory(
          booksList: booksProvider.booksList,
          categoryToFilterBy: categoryToFilterBy);
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
        if (userProvider.user?.booksStarted != null &&
            userProvider.user!.booksStarted!.isNotEmpty)
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
                          setState(() {
                            selectedCategory = e;
                          });
                          filterBooksListByCategory(
                              booksProvider: booksProvider,
                              categoryToFilterBy: e);
                        },
                      )))
                  .toList()
            ],
          ),
        ),
        Text(filteredBooksList.isNotEmpty
            ? "Showing results for: ${selectedCategory?.name}:"
            : "Showing all books"),
        VerticalBooksList(
            booksList: filteredBooksList.isNotEmpty
                ? filteredBooksList
                : booksProvider.booksList),
        const SizedBox(height: 80)
      ],
    ));
  }
}

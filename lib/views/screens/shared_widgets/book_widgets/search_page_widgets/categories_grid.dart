import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/books_list_page.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/category_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/utility_functions/filter_books_by_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key, required this.categoriesList});

  final List<Category> categoriesList;

  navigateToBooksListPage(
      {required BuildContext context,
      required BooksProvider booksProvider,
      required Category categoryToFilterBy}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BooksListPage(
                booksList: filterBooksByCategory(
                    booksList: booksProvider.booksList,
                    categoryToFilterBy: categoryToFilterBy),
                label: "Showing results for: ${categoryToFilterBy.name}")));
  }

  @override
  Widget build(BuildContext context) {
    BooksProvider booksProvider = context.watch<BooksProvider>();
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...categoriesList
                  .take(categoriesList.length > 4
                      ? (categoriesList.length / 2).ceil()
                      : categoriesList.length)
                  .map((e) => Container(
                      margin: EdgeInsets.only(right: generalMargin),
                      child: GestureDetector(
                        child: CategoryTile(category: e),
                        onTap: () {
                          navigateToBooksListPage(
                              context: context,
                              booksProvider: booksProvider,
                              categoryToFilterBy: e);
                        },
                      )))
                  .toList(),
            ],
          ),
        ),
        SizedBox(height: generalMargin),
        if (categoriesList.length >
            4) // Only show the second row if there are more than 4 categories
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...categoriesList
                    .skip((categoriesList.length / 2).ceil())
                    .map((e) => Container(
                        margin: EdgeInsets.only(right: generalMargin),
                        child: GestureDetector(
                          child: CategoryTile(category: e),
                          onTap: () {
                            navigateToBooksListPage(
                                context: context,
                                booksProvider: booksProvider,
                                categoryToFilterBy: e);
                          },
                        )))
                    .toList(),
              ],
            ),
          ),
      ],
    );
  }
}

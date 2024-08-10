import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_provider.dart';
import 'package:book_frontend/controllers/books_management/collections_provider/collections_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/app_logic_classes/search_result.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/category_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/horizontal_categories_list.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/collection_widgets/horizontal_collections_list.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/horizontal_books_list.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/search_widgets/search_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Category> interestedCategories = [];
  SearchResult? searchResult;
  String? searchKeyword;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    interestedCategories = userProvider.user?.interestedCategoriesList ?? [];
    BooksProvider booksProvider = context.watch<BooksProvider>();
    CategoriesProvider categoriesProvider = context.watch<CategoriesProvider>();
    CollectionsProvider collectionsProvider =
        context.watch<CollectionsProvider>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(generalMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CategoriesListHeader(label: "My favorite categories"),
              Container(
                margin: EdgeInsets.symmetric(vertical: generalMargin),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...interestedCategories
                              .take(interestedCategories.length > 4
                                  ? (interestedCategories.length / 2).ceil()
                                  : interestedCategories.length)
                              .map((e) => Container(
                                  margin: EdgeInsets.only(right: generalMargin),
                                  child: GestureDetector(
                                    child: CategoryTile(category: e),
                                    onTap: () {},
                                  )))
                              .toList(),
                        ],
                      ),
                    ),
                    SizedBox(height: generalMargin),
                    if (interestedCategories.length >
                        4) // Only show the second row if there are more than 4 categories
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...interestedCategories
                                .skip((interestedCategories.length / 2).ceil())
                                .map((e) => Container(
                                    margin:
                                        EdgeInsets.only(right: generalMargin),
                                    child: GestureDetector(
                                      child: CategoryTile(category: e),
                                      onTap: () {},
                                    )))
                                .toList(),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SearchFormWidget(onSearch: (val) {
                setState(() {
                  searchKeyword = val;
                  searchResult = search(
                      val,
                      booksProvider.booksList,
                      categoriesProvider.categoriesList,
                      collectionsProvider.collections);
                });
              }),
              if (searchKeyword != null && searchKeyword!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (searchResult?.matchedCategories != null &&
                        searchResult!.matchedCategories.isNotEmpty)
                      HorizontalCategoriesList(
                        categories: searchResult!.matchedCategories,
                        label: "Matched Categories",
                        showCategoriesListHeader: true,
                      ),
                    if (searchResult?.matchedBooks != null &&
                        searchResult!.matchedBooks.isNotEmpty)
                      HorizontalBooksList(
                          booksList: searchResult!.matchedBooks,
                          label: "Matched books"),
                    if (searchResult?.matchedCategories != null &&
                        searchResult!.matchedCategories.isNotEmpty)
                      HorizontalCollectionsList(
                          collections: searchResult!.matchedCollections,
                          label: "Matched Collections"),
                  ],
                ),
              const SizedBox(height: 80)
            ],
          ),
        ),
      ),
    );
  }
}

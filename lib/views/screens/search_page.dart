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
              Container(
                height: 40,
                margin: EdgeInsets.symmetric(vertical: generalMargin),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...interestedCategories
                        .map((e) => Container(
                            margin: EdgeInsets.only(right: generalMargin),
                            child: GestureDetector(
                              child: CategoryTile(category: e),
                              onTap: () {},
                            )))
                        .toList()
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
                          label: "Categories"),
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
            ],
          ),
        ),
      ),
    );
  }
}

class SearchFormWidget extends StatefulWidget {
  final Function(String) onSearch;

  const SearchFormWidget({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchFormWidgetState createState() => _SearchFormWidgetState();
}

class _SearchFormWidgetState extends State<SearchFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: generalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter keyword',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter a keyword';
              //   }
              //   return null;
              // },
              onChanged: (val) {
                if (_formKey.currentState!.validate()) {
                  widget.onSearch(_searchController.text);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSearch(_searchController.text);
                }
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}

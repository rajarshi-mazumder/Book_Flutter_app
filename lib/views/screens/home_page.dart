import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_provider.dart';
import 'package:book_frontend/controllers/books_management/collections_provider/collections_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/data/books_data.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/models/books/collection.dart';
import 'package:book_frontend/services/cache_services/app_cache_services.dart';
import 'package:book_frontend/services/cache_services/book_cache_services.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/theme_constants.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/collection_widgets/collection_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/collection_widgets/horizontal_collections_list.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/short_book_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/vertical_book_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/category_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/horizontal_books_list.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/vertical_books_list.dart';
import 'package:book_frontend/views/screens/shared_widgets/navigation_widgets/bottom_nav_bar.dart';
import 'package:book_frontend/views/screens/shared_widgets/navigation_widgets/nav_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
  String? _lastCategoriesListVersion;
  String? _lastCollectionsListVersion;

  int _bottomNavIndex = 0;

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

      CategoriesProvider categoriesProvider =
          Provider.of<CategoriesProvider>(context, listen: false);

      BooksProvider booksProvider =
          Provider.of<BooksProvider>(context, listen: false);

      CollectionsProvider collectionsProvider =
          Provider.of<CollectionsProvider>(context, listen: false);

      _lastBooksListVersion = appDataProvider.lastBooksListVersion;
      _lastCategoriesListVersion = appDataProvider.lastCategoriesListVersion;
      _lastCollectionsListVersion = appDataProvider.lastCollectionsListVersion;

      categoriesProvider.initActions(
          appDataProvider: appDataProvider, userProvider: userProvider);

      booksProvider.initActions(
          appDataProvider: appDataProvider, userProvider: userProvider);

      BooksProvider.booksFetchedStreamController.listen((_) {
        collectionsProvider.initActions(
            appDataProvider: appDataProvider,
            booksProvider: booksProvider,
            userProvider: userProvider);
      });
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
    CollectionsProvider collectionsProvider =
        Provider.of<CollectionsProvider>(context);

    List<Category> categories = categoriesProvider.categoriesList;

    return SingleChildScrollView(
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
              ' ${userProvider.user?.interestedCategories?.map((e) => e["category_id"]).toList()}'),
          Row(
            children: [
              Text(
                  'Cloud Books List version: ${_lastBooksListVersion.toString()}'),
              const SizedBox(width: 10),
              Text(
                  'Cached Books List version: ${AppCacheServices().readLastBooksVersion()}')
            ],
          ),
          Row(
            children: [
              Text(
                  'Cloud Categories version: ${_lastCategoriesListVersion.toString()}'),
              const SizedBox(width: 10),
              Text(
                  'Cached Categories version: ${AppCacheServices().readLastCategoriesVersion()}')
            ],
          ),
          Row(
            children: [
              Text(
                  'Cloud Collections version: ${_lastCollectionsListVersion.toString()}'),
              const SizedBox(width: 10),
              Text(
                  'Cached Collections version: ${AppCacheServices().readLastCollectionsVersion()}')
            ],
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
          HorizontalBooksList(
            booksList: booksProvider.recommendedBooks,
            label: "Recommended Books",
          ),
          HorizontalCollectionsList(
            collections: collectionsProvider.recommendedCollections,
            label: "Recommended Collections",
          ),
          HorizontalCollectionsList(
            collections: collectionsProvider.collections,
            label: "All Collections",
          ),
          VerticalBooksList(
              booksList: filteredBooksList.isNotEmpty
                  ? filteredBooksList
                  : booksProvider.booksList),
        ],
      ),
    );
  }
}

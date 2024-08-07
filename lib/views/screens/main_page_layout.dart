import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_provider.dart';
import 'package:book_frontend/controllers/books_management/collections_provider/collections_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/theme/theme_constants.dart';
import 'package:book_frontend/views/screens/home_page.dart';
import 'package:book_frontend/views/screens/library_page.dart';
import 'package:book_frontend/views/screens/shared_widgets/navigation_widgets/bottom_nav_bar.dart';
import 'package:book_frontend/views/screens/shared_widgets/navigation_widgets/nav_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPageLayout extends StatefulWidget {
  const MainPageLayout({super.key});

  @override
  State<MainPageLayout> createState() => _MainPageLayoutState();
}

class _MainPageLayoutState extends State<MainPageLayout> {
  // ui navigation variables
  final PageController _pageController = PageController();
  int _bottomNavIndex = 0;

  // data logic varibles

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
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _bottomNavIndex = index;
              });
            },
            children: [
              HomePage(), // Your page widget
              Container(), // Your page widget
              LibraryPage(), // Your page widget
            ],
          ),
          Positioned(
              bottom: -25,
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                // color: primaryColor,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.black,
                            Colors.black,
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0),
                          ])),
                    ),
                    BottomNavBar(
                      pageController: _pageController,
                      bottomNavIndex: _bottomNavIndex,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

import 'package:book_frontend/theme/theme_constants.dart';
import 'package:book_frontend/views/screens/home_page.dart';
import 'package:book_frontend/views/screens/library_page.dart';
import 'package:book_frontend/views/screens/shared_widgets/navigation_widgets/bottom_nav_bar.dart';
import 'package:book_frontend/views/screens/shared_widgets/navigation_widgets/nav_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainPageLayout extends StatefulWidget {
  const MainPageLayout({super.key});

  @override
  State<MainPageLayout> createState() => _MainPageLayoutState();
}

class _MainPageLayoutState extends State<MainPageLayout> {
  final PageController _pageController = PageController();
  int _bottomNavIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
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
              LibraryPage(), // Your page widget
              Container(), // Your page widget
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

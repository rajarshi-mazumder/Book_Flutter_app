import 'package:book_frontend/theme/theme_constants.dart';
import 'package:book_frontend/views/screens/home_page.dart';
import 'package:book_frontend/views/screens/library_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar(
      {super.key, this.bottomNavIndex = 0, required this.pageController});

  int bottomNavIndex = 0;
  PageController pageController;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void onNavItemTapped(int index) {
    setState(() {
      widget.bottomNavIndex = index;
    });
    widget.pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: widget.bottomNavIndex,
      // height: 50,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: primaryColor,
      color: bottomNavBarColor,
      animationDuration: const Duration(milliseconds: 300),
      items: const [
        Icon(Icons.explore), // (3)
        Icon(Icons.search), // (3)
        Icon(Icons.bookmark), // (3)
      ],

      onTap: onNavItemTapped, // (4)
    );
  }
}

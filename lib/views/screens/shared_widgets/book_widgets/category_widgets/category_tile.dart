import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/text_themes.dart';
import 'package:book_frontend/theme/theme_constants.dart';
import 'package:flutter/material.dart';

const double CATEGORY_TILE_HEIGHT = 36;

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    TextTheme appTextTheme = Theme.of(context).textTheme;
    return Container(
        padding: EdgeInsets.all(generalPadding),
        height: CATEGORY_TILE_HEIGHT,
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(smallBorderRadius))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(category.name, style: categoryNameStyle(appTextTheme)),
          ],
        ));
  }
}

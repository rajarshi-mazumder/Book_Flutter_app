import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/theme_constants.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  CategoryTile({super.key, required this.category});
  Category category;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(generalPadding),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius:
                BorderRadius.all(Radius.circular(generalBorderRadius))),
        child: Text(category.name));
  }
}

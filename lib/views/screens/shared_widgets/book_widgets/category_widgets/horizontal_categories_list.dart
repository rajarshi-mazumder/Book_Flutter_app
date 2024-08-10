import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/models/books/collection.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/text_themes.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/category_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/collection_widgets/collection_tile.dart';
import 'package:flutter/material.dart';

class HorizontalCategoriesList extends StatelessWidget {
  const HorizontalCategoriesList(
      {super.key, required this.categories, required this.label});

  final List<Category> categories;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: categories
                .map((e) => Container(
                    margin: EdgeInsets.all(generalMargin),
                    child: CategoryTile(category: e)))
                .toList(),
          ),
        )
      ],
    );
  }
}

class CategoriesListHeader extends StatelessWidget {
  const CategoriesListHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    TextTheme appTextTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 5),
      child: Text(
        label,
        style: headerLargeStyle(appTextTheme),
      ),
    );
  }
}

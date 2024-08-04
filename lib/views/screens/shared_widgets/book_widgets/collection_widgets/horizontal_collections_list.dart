import 'package:book_frontend/models/books/collection.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/text_themes.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/collection_widgets/collection_tile.dart';
import 'package:flutter/material.dart';

class HorizontalCollectionsList extends StatelessWidget {
  const HorizontalCollectionsList({super.key, required this.collections});

  final List<Collection> collections;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: collectionTileHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: collections
            .map((e) => Container(
                margin: EdgeInsets.all(generalMargin),
                child: CollectionTile(collection: e)))
            .toList(),
      ),
    );
  }
}

class CollectionsListHeader extends StatelessWidget {
  const CollectionsListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme appTextTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 5),
      child: Text(
        "Collections",
        style: headerLargeStyle(appTextTheme),
      ),
    );
  }
}

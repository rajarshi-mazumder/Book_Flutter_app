import 'package:book_frontend/models/books/collection.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/collection_widgets/collection_books_list_page.dart';
import 'package:book_frontend/views/screens/shared_widgets/utility_widgets/error_image_widget.dart';
import 'package:flutter/material.dart';

double collectionTileHeight = 200;
double collectionTileWidth = 150;

class CollectionTile extends StatelessWidget {
  const CollectionTile({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CollectionBooksListPage(collection: collection)));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(generalBorderRadius)),
        child: SizedBox(
          height: collectionTileHeight,
          width: collectionTileWidth,
          child: Image.network(
            collection.collectionImgPath ?? "",
            errorBuilder: (context, object, stackTrace) =>
                const ErrorImageWidget(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

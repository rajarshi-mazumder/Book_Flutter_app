import 'dart:io';

import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/collections_provider/collections_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/collection.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/theme_constants.dart';
import 'package:book_frontend/views/screens/shared_widgets/utility_widgets/error_image_widget.dart';
import 'package:book_frontend/views/screens/shared_widgets/utility_widgets/loading_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double COLLECTION_TILE_WIDTH = 150;
const double COLLECTION_TILE_HEIGHT = 200;

class CollectionTileImgWidget extends StatefulWidget {
  const CollectionTileImgWidget({super.key, required this.collection});

  final Collection collection;

  @override
  State<CollectionTileImgWidget> createState() =>
      _CollectionTileImgWidgetState();
}

class _CollectionTileImgWidgetState extends State<CollectionTileImgWidget> {
  @override
  Widget build(BuildContext context) {
    CollectionsProvider collectionsProvider =
        context.watch<CollectionsProvider>();
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(generalBorderRadius)),
      child: Container(
        width: COLLECTION_TILE_WIDTH,
        height: COLLECTION_TILE_HEIGHT,
        color: Colors.black12,
        child: FutureBuilder<String?>(
          future: collectionsProvider.getCollectionImage(
              collectionId: widget.collection.id),
          builder: (context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.data == null) {
              return LoadingIcon();
            } else {
              print("MY FILE ${snapshot.data}");
              File file = File(snapshot.data!);
              file.exists().then((val) {
                print("FILE EXISTS $val");
              });
              return Image.file(
                file,
                // errorBuilder: (context, object, stackTrace) =>
                //     const ErrorImageWidget(),
                fit: BoxFit.cover,
              );
            }
          },
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/theme_constants.dart';
import 'package:book_frontend/views/screens/shared_widgets/utility_widgets/error_image_widget.dart';
import 'package:book_frontend/views/screens/shared_widgets/utility_widgets/loading_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double BOOK_TILE_WIDTH = 150;
const double BOOK_TILE_HEIGHT = 200;

class BookTileImgWidget extends StatefulWidget {
  const BookTileImgWidget({super.key, required this.book});

  final Book book;

  @override
  State<BookTileImgWidget> createState() => _BookTileImgWidgetState();
}

class _BookTileImgWidgetState extends State<BookTileImgWidget> {
  @override
  Widget build(BuildContext context) {
    BooksProvider booksProvider = context.watch<BooksProvider>();
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(generalBorderRadius)),
      child: Container(
        width: BOOK_TILE_WIDTH,
        height: BOOK_TILE_HEIGHT,
        color: Colors.black12,
        child: FutureBuilder<String?>(
          future: booksProvider.getBookImage(bookId: widget.book.bookId),
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

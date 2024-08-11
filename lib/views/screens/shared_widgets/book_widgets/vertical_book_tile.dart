import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/services/cache_services/user_cache_services.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/text_themes.dart';
import 'package:book_frontend/views/screens/book_pages/book_details_page.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/book_tile_widgets/book_tile_img_widget.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/category_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/utility_functions/update_user_books_started.dart';
import 'package:book_frontend/views/screens/shared_widgets/utility_widgets/error_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double BOOK_COVER_WIDTH = 150;
const double BOOK_COVER_HEIGHT = 200;

//ignore: must_be_immutable
class VerticalBookTile extends StatelessWidget {
  VerticalBookTile(
      {super.key,
      required this.book,
      this.isTappable = true,
      this.showDescription = true});

  final Book book;
  bool isTappable;
  final bool showDescription;

  @override
  Widget build(BuildContext context) {
    TextTheme appTextTheme = Theme.of(context).textTheme;
    UserProvider userProvider = context.watch<UserProvider>();
    BooksProvider booksProvider = context.watch<BooksProvider>();
    CategoriesProvider categoriesProvider = context.watch<CategoriesProvider>();

    return GestureDetector(
      onTap: () {
        if (isTappable) {
          updateUserBooksStarted(
              userProvider: userProvider,
              booksProvider: booksProvider,
              categoriesProvider: categoriesProvider,
              bookToUpdate: book);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      BookDetailsPage(bookId: book.bookId, book: book)));
        }
      },
      child: Container(
        height: 200,
        margin: EdgeInsets.all(generalMargin),
        padding: EdgeInsets.all(generalPadding),
        child: Row(children: [
          BookTileImgWidget(book: book),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  book.title,
                  style: bookNameStyle(appTextTheme),
                ),
                const SizedBox(height: 10),
                Text(
                  book.author?.name ?? "anonymous",
                  style: prominentTextStyle(appTextTheme),
                ),
                const SizedBox(height: 10),
                if (showDescription)
                  Expanded(
                      child: Text(
                    book.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                const SizedBox(height: 10),
                if (book.categories != null)
                  SizedBox(
                    height: CATEGORY_TILE_HEIGHT,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: book.categories!
                          .map((e) => Container(
                                margin: EdgeInsets.only(right: generalMargin),
                                child: CategoryTile(category: e),
                              ))
                          .toList(),
                    ),
                  )
              ],
            ),
          )
        ]),
      ),
    );
  }
}

import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/services/cache_services/user_cache_services.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/text_themes.dart';
import 'package:book_frontend/theme/theme_constants.dart';
import 'package:book_frontend/views/screens/book_pages/book_details_page.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/category_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/short_category_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/utility_functions/update_user_books_started.dart';
import 'package:book_frontend/views/screens/shared_widgets/utility_widgets/error_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double SHORT_BOOK_TILE_WIDTH = 150;
const double SHORT_BOOK_TILE_HEIGHT = 200;

//ignore: must_be_immutable
class ShortBookTile extends StatelessWidget {
  ShortBookTile(
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
        height: SHORT_BOOK_TILE_HEIGHT,
        width: SHORT_BOOK_TILE_WIDTH,
        margin: EdgeInsets.all(generalMargin),
        child: Stack(children: [
          ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(generalBorderRadius)),
            child: Container(
              width: SHORT_BOOK_TILE_WIDTH,
              height: SHORT_BOOK_TILE_HEIGHT,
              color: primaryColor,
              child: Image.network(
                book.coverImgPath ?? "",
                errorBuilder: (context, object, stackTrace) =>
                    const ErrorImageWidget(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(generalBorderRadius)),
              child: Container(
                width: SHORT_BOOK_TILE_WIDTH,
                height: SHORT_BOOK_TILE_HEIGHT / 2,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0.8)
                    ])),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: generalMargin, horizontal: generalMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (book.categories != null)
                  SizedBox(
                    height: SHORT_CATEGORY_TILE_HEIGHT,
                    child: Row(
                      children: [
                        book.categories!
                            .map((e) => Container(
                                  margin: EdgeInsets.only(right: generalMargin),
                                  child: ShortCategoryTile(category: e),
                                ))
                            .toList()
                            .first
                      ],
                    ),
                  ),
                Text(
                  book.title,
                  style: bookNameStyle(appTextTheme),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

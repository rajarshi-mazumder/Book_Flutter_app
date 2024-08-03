import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/services/cache_services/user_cache_services.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/text_themes.dart';
import 'package:book_frontend/views/screens/book_details_page.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/category_tile.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/short_category_tile.dart';
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
    bool checkIfBookExistsInBooksStarted({required UserProvider userProvider}) {
      if (userProvider.user!.booksStarted != null) {
        return userProvider.user!.booksStarted!
            .where((element) => element["book_id"].toString() == book.bookId)
            .isNotEmpty;
      } else {
        return false;
      }
    }

    return GestureDetector(
      onTap: () {
        if (isTappable) {
          if (!checkIfBookExistsInBooksStarted(userProvider: userProvider)) {
            UserCacheServices()
                .writeUserBooksStarted(bookIdToSave: book.bookId);
            userProvider.addUserBooksStarted(
                book: book, booksProvider: booksProvider);
            userProvider.addUserInterestedCategories(
                book: book,
                booksProvider: booksProvider,
                categoriesProvider: categoriesProvider);
          }

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
            child: SizedBox(
              width: SHORT_BOOK_TILE_WIDTH,
              height: SHORT_BOOK_TILE_HEIGHT,
              child: Image.network(
                book.coverImgPath ?? "",
                errorBuilder: (context, object, stackTrace) => Image.network(
                  "https://i0.wp.com/picjumbo.com/wp-content/uploads/violet-colorful-sunset-sky-on-the-beach-free-photo.jpeg?w=600&quality=80",
                  fit: BoxFit.cover,
                ),
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

import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/services/cache_services/user_cache_services.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/text_themes.dart';
import 'package:book_frontend/views/screens/book_details_page.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/category_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double BOOK_COVER_WIDTH = 150;
double BOOK_COVER_HEIGHT = 200;

//ignore: must_be_immutable
class BookTile extends StatelessWidget {
  BookTile(
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
        height: 200,
        margin: EdgeInsets.all(generalMargin),
        padding: EdgeInsets.all(generalPadding),
        child: Row(children: [
          ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(generalBorderRadius)),
            child: SizedBox(
              width: BOOK_COVER_WIDTH,
              height: BOOK_COVER_HEIGHT,
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

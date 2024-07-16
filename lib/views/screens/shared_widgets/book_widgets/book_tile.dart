import 'package:book_frontend/controllers/books_management/books_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/text_themes.dart';
import 'package:book_frontend/views/screens/book_details_page.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double BOOK_COVER_WIDTH = 150;
double BOOK_COVER_HEIGHT = 200;

class BookTile extends StatelessWidget {
  BookTile(
      {super.key,
      required this.book,
      this.isTappable = true,
      this.showDescription = true});
  Book book;
  bool isTappable;
  bool showDescription;
  @override
  Widget build(BuildContext context) {
    TextTheme appTextTheme = Theme.of(context).textTheme;
    UserProvider userProvider = context.watch<UserProvider>();
    BooksProvider booksProvider = context.watch<BooksProvider>();
    bool checkIfBookExistsInBooksStarted({required UserProvider userProvider}) {
      if (userProvider.user! != null &&
          userProvider.user!.booksStarted != null) {
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
            userProvider.addUserBooksStarted(
                bookId: book.bookId, booksProvider: booksProvider);
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
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )),
                if (book.categories != null)
                  Container(
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

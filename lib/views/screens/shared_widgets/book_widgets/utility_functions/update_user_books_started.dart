import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/services/cache_services/user_cache_services.dart';

bool checkIfBookExistsInBooksStarted(
    {required UserProvider userProvider, required Book book}) {
  if (userProvider.user!.booksStarted != null) {
    return userProvider.user!.booksStarted!
        .where((element) => element["book_id"].toString() == book.bookId)
        .isNotEmpty;
  } else {
    return false;
  }
}

updateUserBooksStarted({
  required UserProvider userProvider,
  required BooksProvider booksProvider,
  required CategoriesProvider categoriesProvider,
  required Book bookToUpdate,
}) {
  if (!checkIfBookExistsInBooksStarted(
      userProvider: userProvider, book: bookToUpdate)) {
    UserCacheServices()
        .writeUserBooksStarted(bookIdToSave: bookToUpdate.bookId);
    userProvider.addUserBooksStarted(
        book: bookToUpdate, booksProvider: booksProvider);
    userProvider.updateUserInterestedCategories(
        book: bookToUpdate,
        booksProvider: booksProvider,
        categoriesProvider: categoriesProvider);
  }
}

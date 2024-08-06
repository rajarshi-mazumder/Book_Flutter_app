import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:intl/intl.dart';

List<Book> sortBooksByRelevance(
    {List<Map<String, dynamic>>? booksStarted,
    required List<Book> bookListToSort}) {
  final dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");

  if (booksStarted != null) {
    bookListToSort.sort((a, b) {
      Map<String, dynamic>? aStarted = booksStarted.firstWhere(
          (book) => book['book_id'].toString() == a.bookId,
          orElse: () => {});
      Map<String, dynamic>? bStarted = booksStarted?.firstWhere(
          (book) => book['book_id'].toString() == b.bookId,
          orElse: () => {});

      if (aStarted!.isNotEmpty && bStarted!.isEmpty) {
        return -1; // a is started, b is not
      } else if (aStarted.isEmpty && bStarted!.isNotEmpty) {
        return 1; // b is started, a is not
      } else if (aStarted!.isNotEmpty && bStarted!.isNotEmpty) {
        DateTime aDate = aStarted['started_date'].runtimeType == String
            ? dateFormat.parse(aStarted['started_date'])
            : aStarted['started_date'];
        DateTime bDate = bStarted['started_date'].runtimeType == String
            ? dateFormat.parse(bStarted['started_date'])
            : bStarted['started_date'];
        return bDate.compareTo(aDate); // More recently started comes first
      } else {
        return 0; // Neither are started
      }
    });
  }
  return bookListToSort;
}

List<Category> sortCategoriesByRelevance(
    {List<Map<String, dynamic>>? categoriesInterested,
    required List<Category> categoriesList}) {
  if (categoriesInterested != null) {
    categoriesList.sort((a, b) {
      Map<String, dynamic>? aCat = categoriesInterested.firstWhere(
          (category) => int.parse(category['category_id']) == a.id,
          orElse: () => {});
      Map<String, dynamic>? bCat = categoriesInterested.firstWhere(
          (category) => int.parse(category['category_id']) == b.id,
          orElse: () => {});

      if (aCat.isNotEmpty && bCat.isNotEmpty) {
        return -1;
      } else if (aCat.isEmpty && bCat.isNotEmpty) {
        return 1;
      } else {
        return 0;
      }
    });
  }
  return categoriesList;
}

List<Book> sortBooksByRecommendation({
  required List<Book> booksList,
  required List<Map<String, dynamic>> interestedCategories,
}) {
  List<Book> recommendedBooks = [];

  for (Book book in booksList) {
    if (book.categories != null) {
      for (Category bookCategory in book.categories!) {
        if (interestedCategories
            .any((cat) => int.parse(cat["category_id"]) == bookCategory.id)) {
          recommendedBooks.add(book);
          break; // Stop checking other categories for this book
        }
      }
    }
  }
  return recommendedBooks;
}

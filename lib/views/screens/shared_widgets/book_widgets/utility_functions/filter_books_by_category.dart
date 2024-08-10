import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';

List<Book> filterBooksByCategory(
    {required List<Book> booksList, required Category categoryToFilterBy}) {
  List<Book> filteredBooksList = [];

  filteredBooksList = booksList.where((book) {
    for (Category cat in book.categories!) {
      if (cat.name == categoryToFilterBy.name) return true;
    }
    return false;
  }).toList();
  return filteredBooksList;
}

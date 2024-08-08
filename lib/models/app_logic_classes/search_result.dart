import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/models/books/collection.dart';

class SearchResult {
  List<Book> matchedBooks;
  List<Category> matchedCategories;
  List<Collection> matchedCollections;

  SearchResult({
    required this.matchedBooks,
    required this.matchedCategories,
    required this.matchedCollections,
  });
}

SearchResult search(
  String keyword,
  List<Book> books,
  List<Category> categories,
  List<Collection> collections,
) {
  keyword = keyword.toLowerCase();
  List<Book> matchedBooks = books.where((book) {
    return book.title.toLowerCase().contains(keyword) ||
        book.description.toLowerCase().contains(keyword) ||
        (book.author != null &&
            book.author!.name.toLowerCase().contains(keyword));
  }).toList();

  List<Category> matchedCategories = categories.where((category) {
    return category.name.toLowerCase().contains(keyword);
  }).toList();

  List<Collection> matchedCollections = collections.where((collection) {
    return collection.name.toLowerCase().contains(keyword) ||
        collection.description.toLowerCase().contains(keyword);
  }).toList();

  return SearchResult(
    matchedBooks: matchedBooks,
    matchedCategories: matchedCategories,
    matchedCollections: matchedCollections,
  );
}

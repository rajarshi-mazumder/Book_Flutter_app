import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/services/cache_services/app_cache_services.dart';
import 'package:book_frontend/services/cache_services/book_cache_services.dart';
import 'package:book_frontend/services/cache_services/user_cache_services.dart';

deleteAllCachedData({required BooksProvider booksProvider}) {
  AppCacheServices().deleteAppData();
  BookCacheServices().deleteAllBookCache(booksProvider: booksProvider);
  UserCacheServices().deleteUserStoredData();
}

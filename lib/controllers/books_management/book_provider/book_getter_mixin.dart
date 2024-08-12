import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/books_data_master.dart';
import 'package:book_frontend/controllers/s3_management/s3_image_getter_mixin.dart';
import 'package:book_frontend/controllers/s3_management/s3_management.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/services/cache_services/app_cache_services.dart';
import 'package:book_frontend/services/cache_services/book_cache_services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

mixin BookGetterMixin on ChangeNotifier {
  int _booksPaginationNumber = 1;

  int get booksPaginationNumber => _booksPaginationNumber;

  static Future<String> coverImageBaseLocalPath() async {
    // final directory = await getApplicationDocumentsDirectory();
    final directory = await getExternalStorageDirectory();
    String filePath = '${directory?.path}/book_cover_images';
    return filePath;
  }

  Future<List<Book>> getBooks(
      {required AppDataProvider appDataProvider,
      required UserProvider userProvider}) async {
    List<Book> booksList = [];
    bool needToDownloadBookslist = appDataProvider.checkIfShouldFetchBooks();

    // if (!hasNext) {
    //   return;
    // }
    if (needToDownloadBookslist) {
      print("Need to download books- downloading and caching");

      booksList = await downloadBooksList(
          userProvider: userProvider,
          booksPaginationNumber: booksPaginationNumber);

      if (booksList.isNotEmpty) {
        // delete existing bookList cache and write new cache
        BookCacheServices().deleteBooksListCache();
        BookCacheServices().writeAllBooks(booksList: booksList).then((_) {
          AppCacheServices().writeLastBooksListVersion(
              booksListVersion: appDataProvider.lastBooksListVersion);
        });
      } else {
        print("Books list is empty");
      }
    } else {
      print("No need to download books- reading from cache");

      booksList = await BookCacheServices().readAllBooks();
    }
    return booksList;
  }

  Future<List<Book>> downloadBooksList(
      {required UserProvider userProvider,
      required int booksPaginationNumber}) async {
    List<Book> booksList = [];
    Map<String, dynamic>? booksListData = await BooksDataMaster.getBooks(
        userProvider: userProvider,
        booksPaginationNumber: booksPaginationNumber);

    List? tempbooksList = booksListData?["books"];
    // hasNext = booksListData?["has_next"];

    if (tempbooksList != null) {
      for (var element in tempbooksList) {
        booksList.add(Book.fromMap(element));
      }
      _booksPaginationNumber += 1;
    }
    return booksList;
  }

  Future<String?> getImageForBook(
      {required List<Book> booksList, required String bookId}) async {
    for (Book b in booksList) {
      if (b.bookId == bookId) {
        if (b.coverImgLocalPath == null) {
          if (b.coverImgPath == null) {
            return null;
          }
          String basePath = await coverImageBaseLocalPath();
          String savePath = "$basePath/${b.bookId}.jpg";
          String? preSignedUrl;
          if (b.coverImgPath != null) {
            preSignedUrl = await getPreSignedUrl(fileName: b.coverImgPath!);
          }
          String? localFilePath = await fetchS3Object(
              imgPath: b.coverImgPath!,
              savePath: savePath,
              preSignedUrlStr: preSignedUrl);
          b.coverImgLocalPath = localFilePath;
          if (localFilePath != null) {
            BookCacheServices().updateBookInHive(updatedBook: b);
          }
          return b.coverImgLocalPath;
        } else {
          return b.coverImgLocalPath;
        }
      }
    }
    return null;
  }
}

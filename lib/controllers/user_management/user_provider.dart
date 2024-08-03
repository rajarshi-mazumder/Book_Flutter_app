import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_provider.dart';
import 'package:book_frontend/data/book_chapters/LOTR_3.dart';
import 'package:book_frontend/models/books/app_user.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/services/auth_services/auth_services.dart';
import 'package:book_frontend/services/cache_services/user_cache_services.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;
  Map<String, dynamic>? _userMap;
  AppUser? _user;

  bool get isLoggedIn => _isLoggedIn;

  String? get token => _token;

  Map<String, dynamic>? get userMap => _userMap;

  AppUser? get user => _user;

  /// registers user and gets the token and user_data
  /// by calling AuthServices.register()
  Future<Map<String, dynamic>?> register(
      String name, String email, String password) async {
    Map<String, dynamic> signUpData =
        await AuthService.register(name, email, password);

    bool isRegistered = signUpData["signup_status"];

    if (isRegistered) {
      _userMap = signUpData["user_data"];
      _token = await AuthService.getToken();
      Map<String, dynamic>? appData = signUpData["app_data"];

      _isLoggedIn = true;
      notifyListeners();
      setUser();
      return appData;
    }
    return null;
  }

  /// logs the user in, and gets the token and user_data
  /// by calling AuthServices.login()
  Future<Map<String, dynamic>?> login(String email, String password) async {
    Map<String, dynamic> signInData = await AuthService.login(email, password);
    bool isLoggedIn = signInData["signin_status"];

    if (isLoggedIn) {
      _userMap = signInData["user_data"];
      _token = await AuthService.getToken();
      Map<String, dynamic>? appData = signInData?["app_data"];

      _isLoggedIn = true;
      notifyListeners();
      setUser();
      return appData;
    }
    return null;
  }

  /// silently logs in the user by calling AuthService.silentLogin()
  Future<Map<String, dynamic>?> silentLogin() async {
    Map<String, dynamic>? silentSignInData = await AuthService.silentLogin();
    _userMap = silentSignInData?["user_data"];
    Map<String, dynamic>? appData = silentSignInData?["app_data"];

    if (_userMap != null) {
      _isLoggedIn = true;
      notifyListeners();
    }
    setUser();
    return appData;
  }

  Future<void> logout() async {
    await AuthService.logout();
    _isLoggedIn = false;
    _token = null;
    _userMap = null;
    notifyListeners();
    setUser();
  }

  // adds books to books started in storage, and sorts the books provider
  addUserBooksStarted(
      {required Book book, required BooksProvider booksProvider}) {
    user?.booksStarted
        ?.add({"book_id": book.bookId, "started_date": DateTime.now()});

    booksProvider.sortBooks(booksStarted: user?.booksStarted);

    if (user != null) {
      UserCacheServices().writeUserBooksStarted(bookIdToSave: book.bookId);
    }

    notifyListeners();
  }

  // adds category to interested categories after checking if category already exists
  // in list of interested categories or not
  // also sorts the categoriesList in categories provider
  addUserInterestedCategories(
      {required Book book,
      required BooksProvider booksProvider,
      required CategoriesProvider categoriesProvider}) {
    if (book.categories != null) {
      for (Category cat in book.categories!) {
        bool flag = false;
        if (user!.interestedCategories != null) {
          for (var c in user!.interestedCategories!) {
            if (c["category_id"] == cat.id.toString()) {
              flag = true;
              break;
            }
          }
        }

        if (!flag) {
          user?.interestedCategories
              ?.add({"category_id": cat.id, "interested_date": DateTime.now()});
          categoriesProvider.sortCategories(
              categoriesInterested: user?.interestedCategories);
          UserCacheServices().writeUserInterestedCategories(
              categoryIdToSave: cat.id.toString());
          notifyListeners();
        }
      }
    }
  }

  setUser() {
    _user = _userMap != null ? AppUser.fromMap(_userMap!) : null;
    notifyListeners();
  }
}

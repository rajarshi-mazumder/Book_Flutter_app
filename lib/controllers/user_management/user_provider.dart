import 'package:book_frontend/controllers/books_management/books_provider.dart';
import 'package:book_frontend/controllers/user_management/user_data_master.dart';
import 'package:book_frontend/models/books/app_user.dart';
import 'package:book_frontend/services/auth_services/auth_services.dart';
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
  Future<void> register(String name, String email, String password) async {
    Map<String, dynamic> signUpData =
        await AuthService.register(name, email, password);

    bool isRegistered = signUpData["signup_status"];

    if (isRegistered) {
      _userMap = signUpData["user_data"];
      _token = await AuthService.getToken();
      _isLoggedIn = true;
      notifyListeners();
      setUser();
    }
  }

  /// logs the user in, and gets the token and user_data
  /// by calling AuthServices.login()
  Future<void> login(String email, String password) async {
    Map<String, dynamic> signInData = await AuthService.login(email, password);
    bool isLoggedIn = signInData["signin_status"];

    if (isLoggedIn) {
      _userMap = signInData["user_data"];
      _token = await AuthService.getToken();
      _isLoggedIn = true;
      notifyListeners();
    }
    setUser();
  }

  /// silently logs in the user by calling AuthService.silentLogin()
  Future<void> silentLogin() async {
    _userMap = await AuthService.silentLogin();
    if (_userMap != null) {
      _isLoggedIn = true;
      notifyListeners();
    }
    setUser();
  }

  Future<void> logout() async {
    await AuthService.logout();
    _isLoggedIn = false;
    _token = null;
    _userMap = null;
    notifyListeners();
    setUser();
  }

  addUserBooksStarted(
      {required String bookId, required BooksProvider booksProvider}) {
    user?.booksStarted
        ?.add({"book_id": bookId, "started_date": DateTime.now()});
    booksProvider.sortBooks(booksStarted: user?.booksStarted);
    notifyListeners();
    if (user != null) UserDataMaster.addUserBooksStarted(user: user!);
  }

  setUser() {
    _user = _userMap != null ? AppUser.fromMap(_userMap!) : null;
    notifyListeners();
  }
}

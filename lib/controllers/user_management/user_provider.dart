import 'package:book_frontend/services/auth_services/auth_services.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;
  Map<String, dynamic>? _user;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;

  Future<void> register(String name, String email, String password) async {
    bool isRegistered = await AuthService.register(name, email, password);
    if (isRegistered) {
      await login(email, password);
    }
  }

  Future<bool> login(String email, String password) async {
    Map<String, dynamic> signInData = await AuthService.login(email, password);
    bool isLoggedIn = signInData["signin_status"];

    if (isLoggedIn) {
      _user = signInData["user_data"];
      _token = await AuthService.getToken();
      _isLoggedIn = true;
      notifyListeners();
    }
    return isLoggedIn;
  }

  Future<void> silentLogin() async {
    _user = await AuthService.silentLogin();
    if (_user != null) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _isLoggedIn = false;
    _token = null;
    _user = null;
    notifyListeners();
  }
}

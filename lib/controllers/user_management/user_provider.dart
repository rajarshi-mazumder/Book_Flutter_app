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
      bool isLoggedIn = await login(email, password);
      if (isLoggedIn) {
        _isLoggedIn = true;
        notifyListeners();
      }
    }
  }

  Future<bool> login(String email, String password) async {
    bool isLoggedIn = await AuthService.login(email, password);
    if (isLoggedIn) {
      _isLoggedIn = true;
      _token = await AuthService.getToken();
      _user = await AuthService.silentLogin();
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

  // void logout() async {
  //   await AuthService.logout();
  //   _isLoggedIn = false;
  //   _token = null;
  //   _user = null;
  //   notifyListeners();
  // }
}

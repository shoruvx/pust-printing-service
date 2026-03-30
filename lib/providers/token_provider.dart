import 'package:flutter/material.dart';

class TokenProvider with ChangeNotifier {
  String _currentToken = '';

  String get currentToken => _currentToken;

  void setToken(String token) {
    _currentToken = token;
    notifyListeners();
  }

  void clearToken() {
    _currentToken = '';
    notifyListeners();
  }
}

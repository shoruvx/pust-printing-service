import 'package:flutter/material.dart';
import '../models/token_model.dart';

class TokenProvider with ChangeNotifier {
  Token? _currentToken;

  Token? get currentToken => _currentToken;

  void setToken(Token token) {
    _currentToken = token;
    notifyListeners();
  }

  void clearToken() {
    _currentToken = null;
    notifyListeners();
  }
}

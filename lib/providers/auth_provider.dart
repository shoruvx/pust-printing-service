import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  String _userId;
  bool _isAuthenticated = false;

  String get userId => _userId;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    // Add login logic here
    _userId = 'someUserId'; // Replace with actual user ID
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    // Add logout logic here
    _userId = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
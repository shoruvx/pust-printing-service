import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String _name = '';
  String _email = '';

  String get name => _name;
  String get email => _email;

  void updateProfile({required String name, required String email}) {
    _name = name;
    _email = email;
    notifyListeners();
  }

  void clearProfile() {
    _name = '';
    _email = '';
    notifyListeners();
  }
}

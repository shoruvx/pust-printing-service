import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> signup(String username, String password) async {
    // Implement your signup logic here
    // Store user credentials securely
    await _storage.write(key: 'username', value: username);
    await _storage.write(key: 'password', value: password);
    print('User signed up: $username');
  }

  Future<void> login(String username, String password) async {
    // Implement your login logic here
    // Check user credentials
    String? storedUsername = await _storage.read(key: 'username');
    String? storedPassword = await _storage.read(key: 'password');
    if (storedUsername == username && storedPassword == password) {
      print('User logged in: $username');
      // Proceed to set session or token
    } else {
      print('Login failed for user: $username');
    }
  }

  Future<void> logout() async {
    // Implement your logout logic here
    print('User logged out');
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'password');
  }

  Future<bool> isUserLoggedIn() async {
    // Implement session management logic here
    String? username = await _storage.read(key: 'username');
    return username != null;
  }
}
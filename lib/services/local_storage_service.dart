import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> storeToken(String token) async {
    await _prefs.setString('user_token', token);
  }

  static String? getToken() {
    return _prefs.getString('user_token');
  }

  static Future<void> storePreference(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String? getPreference(String key) {
    return _prefs.getString(key);
  }

  static Future<void> cacheData(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String? getCachedData(String key) {
    return _prefs.getString(key);
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }
}
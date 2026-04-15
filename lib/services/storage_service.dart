import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class StorageService {
  static const String _usersKey = 'users';
  static const String _sessionKey = 'current_user_id';
  static const String _ordersKey = 'orders';
  static const String _notificationsKey = 'notifications';
  static const String _tokenCountKey = 'token_count';
  static const String _tokenDateKey = 'token_date';
  static const String _profilePicKey = 'profile_pic';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // --- Users & Session ---
  
  Future<void> saveUser(AppUser user) async {
    final Map<String, dynamic> users = _getAllUsersMap();
    users[user.rollNumber] = user.toJson();
    await _prefs.setString(_usersKey, jsonEncode(users));
  }

  AppUser? getUser(String rollNumber) {
    final users = _getAllUsersMap();
    if (users.containsKey(rollNumber)) {
      return AppUser.fromJson(users[rollNumber]);
    }
    return null;
  }

  AppUser? getUserById(String id) {
    final users = _getAllUsersMap().values.where((u) => u['id'] == id);
    if (users.isNotEmpty) {
      return AppUser.fromJson(users.first);
    }
    return null;
  }

  Map<String, dynamic> _getAllUsersMap() {
    final String? usersStr = _prefs.getString(_usersKey);
    if (usersStr != null) {
      return jsonDecode(usersStr) as Map<String, dynamic>;
    }
    return {};
  }

  Future<void> saveSession(String userId) async {
    await _prefs.setString(_sessionKey, userId);
  }

  Future<void> clearSession() async {
    await _prefs.remove(_sessionKey);
  }

  String? getSessionUserId() {
    return _prefs.getString(_sessionKey);
  }

  // --- Profile Picture ---

  Future<void> saveProfilePicture(String userId, String path) async {
    await _prefs.setString('${_profilePicKey}_$userId', path);
  }

  String? getProfilePicture(String userId) {
    return _prefs.getString('${_profilePicKey}_$userId');
  }

  // --- Token Generation ---
  
  Future<String> generateDailyToken() async {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final storedDateStr = _prefs.getString(_tokenDateKey) ?? '';
    
    int currentCount = 1;
    if (todayStr == storedDateStr) {
      currentCount = (_prefs.getInt(_tokenCountKey) ?? 0) + 1;
    }
    
    await _prefs.setString(_tokenDateKey, todayStr);
    await _prefs.setInt(_tokenCountKey, currentCount);
    
    return TokenGenerator.generate(currentCount);
  }

  // --- Orders ---
  
  Future<void> saveOrder(PrintOrder order) async {
    final orders = getOrders();
    // remove if exists
    orders.removeWhere((o) => o.id == order.id);
    orders.add(order);
    await _prefs.setString(_ordersKey, jsonEncode(orders.map((o) => o.toJson()).toList()));
  }

  Future<void> deleteOrder(String orderId) async {
    final orders = getOrders();
    orders.removeWhere((o) => o.id == orderId);
    await _prefs.setString(_ordersKey, jsonEncode(orders.map((o) => o.toJson()).toList()));
    // Decrement today's token count so the slot is freed
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final storedDateStr = _prefs.getString(_tokenDateKey) ?? '';
    if (todayStr == storedDateStr) {
      final current = _prefs.getInt(_tokenCountKey) ?? 1;
      if (current > 0) await _prefs.setInt(_tokenCountKey, current - 1);
    }
  }

  List<PrintOrder> getOrders() {
    final String? ordersStr = _prefs.getString(_ordersKey);
    if (ordersStr != null) {
      final List<dynamic> ordersJson = jsonDecode(ordersStr);
      return ordersJson.map((json) => PrintOrder.fromJson(json)).toList();
    }
    return [];
  }

  // --- Notifications ---
  
  Future<void> saveNotification(AppNotification notification) async {
    final notifications = getNotifications();
    notifications.add(notification);
    await _prefs.setString(_notificationsKey, jsonEncode(notifications.map((n) => n.toJson()).toList()));
  }

  List<AppNotification> getNotifications() {
    final String? notifsStr = _prefs.getString(_notificationsKey);
    if (notifsStr != null) {
      final List<dynamic> notifsJson = jsonDecode(notifsStr);
      return notifsJson.map((json) => AppNotification.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> updateNotifications(List<AppNotification> notifications) async {
    await _prefs.setString(_notificationsKey, jsonEncode(notifications.map((n) => n.toJson()).toList()));
  }

  Future<void> clearAllOrders() async {
    await _prefs.remove(_ordersKey);
    await _prefs.remove(_notificationsKey);
  }
}

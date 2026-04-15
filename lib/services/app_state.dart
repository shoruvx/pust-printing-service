import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import 'storage_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storageService;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  
  List<PrintOrder> _orders = [];
  List<PrintOrder> get orders => _orders.where((o) => o.userId == _currentUser?.id).toList();
  
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications.where((n) => n.userId == _currentUser?.id).toList();
  int get unreadPills => notifications.where((n) => !n.isRead).length;

  String? get profilePicturePath => _currentUser == null
      ? null
      : _storageService.getProfilePicture(_currentUser!.id);

  AppState(this._storageService) {
    _initSession();
  }

  bool _isAuthResolved = false;
  bool get isAuthResolved => _isAuthResolved;

  Future<void> _initSession() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if(doc.exists) {
           _currentUser = AppUser.fromJson(doc.data()!);
           await _storageService.saveSession(_currentUser!.id);
           _loadUserData();
        }
      } else {
        _currentUser = null;
        _orders = [];
        _notifications = [];
      }
      _isAuthResolved = true;
      notifyListeners();
    });
  }

  void _loadUserData() {
    _orders = _storageService.getOrders();
    _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _notifications = _storageService.getNotifications();
    _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // --- Auth ---

  Future<String?> login(String rollNumber, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final email = '$rollNumber@pust.student.bd';
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      // The authStateChanges listener handles the success callback
      
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message ?? "Invalid roll number or password";
    } catch(e) {
      _isLoading = false;
      notifyListeners();
      return "Unable to securely login at this time.";
    }
  }

  Future<String?> forgotPassword(String rollNumber) async {
    try {
      final email = '$rollNumber@pust.student.bd';
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> register(AppUser user) async {
    _isLoading = true;
    notifyListeners();
    try {
        final email = '${user.rollNumber}@pust.student.bd';
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: user.passwordHash,
        );
        
        final firebaseUser = AppUser(
          id: cred.user!.uid, // Use Firebase global UID
          fullName: user.fullName,
          rollNumber: user.rollNumber,
          registrationNumber: user.registrationNumber,
          phone: user.phone,
          passwordHash: user.passwordHash,
          memberSince: DateTime.now(),
        );
        
        await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set(firebaseUser.toJson()).timeout(const Duration(seconds: 5));
        
        // Log out immediately so the user can log in manually as requested
        await FirebaseAuth.instance.signOut();
        
        // Listener handles successful injection
        _isLoading = false;
        notifyListeners();
        return null;
    } on FirebaseAuthException catch (e) {
        _isLoading = false;
        notifyListeners();
        return e.message;
    } catch(e) {
        _isLoading = false;
        notifyListeners();
        return "Unable to securely register at this time.";
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await _storageService.clearSession();
    _currentUser = null;
    _orders = [];
    _notifications = [];
    notifyListeners();
  }

  // --- Orders ---

  Future<void> placeOrder(List<PrintFile> files) async {
    if (_currentUser == null) return;
    _isLoading = true;
    notifyListeners();
    
    // Calculate total
    double total = files.fold(0.0, (sum, item) => sum + item.cost);
    
    // Gen Token
    final token = await _storageService.generateDailyToken();
    
    final order = PrintOrder(
      id: const Uuid().v4(),
      userId: _currentUser!.id,
      token: token,
      files: files,
      totalPrice: total,
      createdAt: DateTime.now(),
      status: OrderStatus.pending,
    );
    
    await _storageService.saveOrder(order);
    
    // Automatically create a notification
    final notif = AppNotification(
      id: const Uuid().v4(),
      userId: _currentUser!.id,
      title: "Order Placed",
      message: "Your printing order placed successfully. Token: $token. Status: Pending.",
      createdAt: DateTime.now(),
      orderToken: token,
    );
    await _storageService.saveNotification(notif);
    
    _loadUserData();
    
    _isLoading = false;
    notifyListeners();

    _simulateOrderProgress(order);
  }

  void _simulateOrderProgress(PrintOrder order) async {
    final statusSequence = [
      OrderStatus.printing,
      OrderStatus.readyForPickup,
      OrderStatus.delivered
    ];
    
    for (int i = 0; i < statusSequence.length; i++) {
      await Future.delayed(const Duration(seconds: 8));
      
      final orders = _storageService.getOrders();
      final idx = orders.indexWhere((o) => o.id == order.id);
      
      if(idx != -1) {
         final o = orders[idx];
         final status = statusSequence[i];
         final updatedOrder = PrintOrder(
            id: o.id, userId: o.userId, token: o.token, files: o.files, totalPrice: o.totalPrice, createdAt: o.createdAt,
            status: status
         );
         await _storageService.saveOrder(updatedOrder);
         
         if (status == OrderStatus.delivered) {
           await _storageService.saveNotification(AppNotification(
             id: const Uuid().v4(),
             userId: o.userId,
             title: "Order Delivered",
             message: "Your order ${o.token} has been delivered! Thank you.",
             createdAt: DateTime.now(),
             orderToken: o.token,
           ));
         }
         
         _loadUserData();
         notifyListeners();
      }
    }
  }

  // --- Notifications ---
  
  Future<void> markNotificationsRead() async {
    bool changed = false;
    for (var n in _notifications) {
      if (n.userId == _currentUser?.id && !n.isRead) {
        n.isRead = true;
        changed = true;
      }
    }
    if (changed) {
      await _storageService.updateNotifications(_notifications);
      notifyListeners();
    }
  }

  Future<void> clearAllNotifications() async {
    _notifications.removeWhere((n) => n.userId == _currentUser?.id);
    await _storageService.updateNotifications(_notifications);
    notifyListeners();
  }

  Future<void> cancelOrder(String orderId) async {
    final orders = _storageService.getOrders();
    final idx = orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final o = orders[idx];
    // Only allow cancel if still pending
    if (o.status != OrderStatus.pending) return;
    // Delete the order entirely and free the token slot
    await _storageService.deleteOrder(orderId);
    _loadUserData();
    notifyListeners();
  }

  Future<void> updateProfilePicture(String path) async {
    if (_currentUser == null) return;
    await _storageService.saveProfilePicture(_currentUser!.id, path);
    notifyListeners();
  }
}

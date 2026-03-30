import 'package:flutter/material.dart';

// Import screens here when they are created
// import 'package:pust_printing_service/screens/auth/login_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String createOrder = '/create-order';
  static const String orderList = '/order-list';
  static const String orderDetail = '/order-detail';
  static const String orderHistory = '/order-history';
  static const String trackOrder = '/track-order';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => Container(), // Placeholder
      login: (context) => Container(), // Placeholder
      signup: (context) => Container(), // Placeholder
      home: (context) => Container(), // Placeholder
      createOrder: (context) => Container(), // Placeholder
      orderList: (context) => Container(), // Placeholder
      orderDetail: (context) => Container(), // Placeholder
      orderHistory: (context) => Container(), // Placeholder
      trackOrder: (context) => Container(), // Placeholder
      profile: (context) => Container(), // Placeholder
      editProfile: (context) => Container(), // Placeholder
      settings: (context) => Container(), // Placeholder
    };
  }
}
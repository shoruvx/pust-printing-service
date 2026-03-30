import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  // List to hold orders
  List<Order> _orders = [];

  // Function to create a new order
  void createOrder(Order order) {
    _orders.add(order);
    notifyListeners(); // Notify listeners about the change
  }

  // Function to track an order by its ID
  Order? trackOrder(String orderId) {
    final matches = _orders.where((order) => order.id == orderId);
    return matches.isEmpty ? null : matches.first;
  }

  // Function to view all orders
  List<Order> viewOrders() {
    return [..._orders]; // Return a copy of the order list
  }
}

// Order model class
class Order {
  final String id;
  final String description;
  final DateTime dateCreated;

  Order({required this.id, required this.description}) : dateCreated = DateTime.now();
}
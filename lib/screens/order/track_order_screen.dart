import 'package:flutter/material.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId;
  final String status;
  final String estimatedDelivery;

  TrackOrderScreen({required this.orderId, required this.status, required this.estimatedDelivery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: \$orderId', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Status: \$status', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Estimated Delivery: \$estimatedDelivery', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
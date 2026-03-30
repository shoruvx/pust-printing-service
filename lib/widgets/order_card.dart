import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String token;
  final String status;
  final String date;

  OrderCard({required this.token, required this.status, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Order Token: $token'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Status: $status'),
            Text('Date: $date'),
          ],
        ),
      ),
    );
  }
}
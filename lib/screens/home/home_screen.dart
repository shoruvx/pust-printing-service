import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Recent Orders Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Recent Orders',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Mock recent orders
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Order #${index + 1}'),
                  subtitle: Text('Order details here...'),
                );
              },
            ),
            // Quick Stats Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Quick Stats',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('Total Orders'),
                    Text('100', style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Pending'),
                    Text('15', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
            // Navigation Options Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Navigation Options',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to orders page
              },
              child: Text('View All Orders'),
            ),
          ],
        ),
      ),
    );
  }
}

// Add this file to the main.dart file to display this HomeScreen

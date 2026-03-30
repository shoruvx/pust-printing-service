import 'package:flutter/material.dart';

class CreateOrderScreen extends StatefulWidget {
  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  String? selectedFile;
  Map<String, dynamic> printSettings = {
    'color': 'Black & White',
    'doubleSided': false,
  };

  void submitOrder() {
    // Handle order submission logic here
    print('File: $selectedFile, Print Settings: $printSettings');
    // Normally you'd send this data to your backend for processing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Order')), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Select a file to print:'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement file selection logic here
              },
              child: Text('Choose File'),
            ),
            SizedBox(height: 20),
            Text('Print Settings:'),
            Row(
              children: <Widget>[
                Text('Color:'),
                DropdownButton<String>(
                  value: printSettings['color'],
                  items: <String>['Black & White', 'Color'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      printSettings['color'] = newValue;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text('Double Sided:'),
                Switch(
                  value: printSettings['doubleSided'],
                  onChanged: (bool value) {
                    setState(() {
                      printSettings['doubleSided'] = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitOrder,
              child: Text('Submit Order'),
            ),
          ],
        ),
      ),
    );
  }
}
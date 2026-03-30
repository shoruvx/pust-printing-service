import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController rollNumberController = TextEditingController();
  final TextEditingController registrationNumberController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: rollNumberController,
              decoration: InputDecoration(labelText: 'Roll Number'),
            ),
            TextField(
              controller: registrationNumberController,
              decoration: InputDecoration(labelText: 'Registration Number'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle sign up logic here
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
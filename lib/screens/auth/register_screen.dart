import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../services/app_state.dart';
import '../../models/models.dart';
import '../../widgets/common.dart';
import '../home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _rollNumber = '';
  String _regNumber = '';
  String _phone = '';
  String _password = '';
  String _errorMsg = '';
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() { _isLoading = true; _errorMsg = ''; });
      
      final user = AppUser(
        id: const Uuid().v4(),
        fullName: _fullName,
        rollNumber: _rollNumber,
        registrationNumber: _regNumber,
        phone: _phone,
        passwordHash: _password, // Unsecured for lab
        memberSince: DateTime.now(),
      );
      
      final error = await context.read<AppState>().register(user);
      
      if (!mounted) return;
      setState(() { _isLoading = false; });
      
      if (error == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registration Successful! Please login with your new account.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        setState(() { _errorMsg = error; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                if (_errorMsg.isNotEmpty) ErrorBanner(message: _errorMsg),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  onSaved: (val) => _fullName = val!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Roll Number', prefixIcon: Icon(Icons.numbers)),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  onSaved: (val) => _rollNumber = val!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Registration Number', prefixIcon: Icon(Icons.confirmation_number)),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  onSaved: (val) => _regNumber = val!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone)),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  onSaved: (val) => _phone = val!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.password)),
                  obscureText: true,
                  validator: (val) => val == null || val.length < 6 ? 'Min 6 chars' : null,
                  onSaved: (val) => _password = val!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.password_rounded)),
                  obscureText: true,
                  validator: (val) => val == null || val != _passwordController.text ? 'Passwords do not match' : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading ? const CircularProgressIndicator() : const Text('Register', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

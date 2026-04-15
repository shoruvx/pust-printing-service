import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../widgets/common.dart';
import '../home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _rollNumber = '';
  String _password = '';
  String _errorMsg = '';
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() { _isLoading = true; _errorMsg = ''; });
      
      final error = await context.read<AppState>().login(_rollNumber, _password);
      
      if (!mounted) return;
      setState(() { _isLoading = false; });
      
      if (error == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        setState(() { _errorMsg = error; });
      }
    }
  }

  void _showForgotPasswordDialog() {
    final curRoll = _rollNumber.isNotEmpty ? _rollNumber : '';
    final ctrl = TextEditingController(text: curRoll);
    showDialog(context: context, builder: (ctx) {
      return AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Roll Number'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () async {
              if (ctrl.text.isEmpty) return;
              Navigator.pop(ctx);
              setState(() { _isLoading = true; });
              final err = await context.read<AppState>().forgotPassword(ctrl.text.trim());
              setState(() { _isLoading = false; });
              if (err == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset mechanism linked to Firebase successfully!')));
              } else {
                setState(() => _errorMsg = err);
              }
            },
            child: const Text('Send Reset Link')
          )
        ]
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.3), blurRadius: 20, spreadRadius: 5),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.network('https://upload.wikimedia.org/wikipedia/en/1/16/PUST_Logo.png', fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (_errorMsg.isNotEmpty) ErrorBanner(message: _errorMsg),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Roll Number',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  onSaved: (val) => _rollNumber = val!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.password),
                  ),
                  obscureText: true,
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  onSaved: (val) => _password = val!.trim(),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading ? const CircularProgressIndicator() : const Text('Login', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: Text("Forgot Password?", style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text("Don't have an account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

class TokenScreen extends StatefulWidget {
  final String token;
  const TokenScreen({Key? key, required this.token}) : super(key: key);

  @override
  _TokenScreenState createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Placed')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text('Your order has been placed successfully!', textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
              const SizedBox(height: 32),
              const Text('Your Token Number Is:', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.token,
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 4),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.token));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Token copied to clipboard')));
                        },
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 64),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (r) => false,
                    );
                  },
                  child: const Text('Back to Dashboard', style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

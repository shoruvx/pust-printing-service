import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import 'home_screen.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _checkAuthAndNavigate();
    });
  }

  void _checkAuthAndNavigate() {
    final appState = context.read<AppState>();
    if (appState.isAuthResolved) {
      _navigate(appState);
    } else {
      appState.addListener(_authListener);
    }
  }

  void _authListener() {
    final appState = context.read<AppState>();
    if (appState.isAuthResolved) {
      appState.removeListener(_authListener);
      _navigate(appState);
    }
  }

  void _navigate(AppState appState) {
    if (!mounted) return;
    if (appState.currentUser != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5C0000), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: ScaleTransition(
              scale: _animation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 40,
                          spreadRadius: 15,
                        )
                      ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.network('https://upload.wikimedia.org/wikipedia/en/1/16/PUST_Logo.png', fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFF228B22)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Text(
                      'PUST Printing\nService',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42, 
                        fontWeight: FontWeight.w900, 
                        letterSpacing: -0.5,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Student Printing Made Easy', 
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

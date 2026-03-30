import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_routes.dart';
import 'config/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'providers/token_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PustPrintingServiceApp());
}

class PustPrintingServiceApp extends StatelessWidget {
  const PustPrintingServiceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => TokenProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'PUST Printing Service',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isLoggedIn) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
        routes: AppRoutes.routes,
      ),
    );
  }
}

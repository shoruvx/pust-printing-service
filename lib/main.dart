import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/storage_service.dart';
import 'services/app_state.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize storage service
  final storageService = await StorageService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState(storageService)),
      ],
      child: const PrintQueueApp(),
    ),
  );
}

class PrintQueueApp extends StatelessWidget {
  const PrintQueueApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrintQueue',
      theme: AppTheme.darkTheme, // Use the new dark theme
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
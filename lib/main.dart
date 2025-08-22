import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tix_now/app.dart';
import 'package:tix_now/core/services/data_seed_service.dart';
import 'package:tix_now/features/auth/presentation/pages/login_page.dart';
import 'package:tix_now/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:tix_now/features/auth/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize sample data
  await DatabaseInitializer.initializeDatabase();

  runApp(const App());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

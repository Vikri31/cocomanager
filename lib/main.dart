import 'package:cocomanager/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'screens/loading_screen.dart'; // Import file loading
// Import file home

void main() {
  runApp(const CocoManagerApp());
}

class CocoManagerApp extends StatelessWidget {
  const CocoManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coco Manager',
      // 1. Tentukan halaman mana yang muncul pertama kali
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}

import "dart:async"; // Import untuk Timer
import "package:flutter/material.dart";

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // 2. Logika Timer: Pindah ke Home setelah 3 detik
    Timer(const Duration(seconds: 2), () {
      // Menggunakan pushReplacement agar Splash Screen dihapus dari tumpukan (stack)
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'prikitiw',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
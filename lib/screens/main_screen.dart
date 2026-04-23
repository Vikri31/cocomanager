import 'package:flutter/material.dart';
import 'package:cocomanager/screens/home_screen.dart';
import 'package:cocomanager/screens/stok_screen.dart';
// import 'package:cocomanager/screens/profil_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  // Variabel untuk mencatat halaman mana yang aktif
  int _currentIndex = 0;

  // DAFTAR HALAMANNYA DI SINI
  final List<Widget> _listHalaman = [
    const HomeScreen(), // Indeks 0
    const StokScreen(), // Indeks 1
    // const ProfilScreen(), // Indeks 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Isi body otomatis berubah sesuai _currentIndex
      body: _listHalaman[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Ganti halaman saat diklik
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stok'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

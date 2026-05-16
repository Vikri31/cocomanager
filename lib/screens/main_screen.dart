import 'package:flutter/material.dart';
import 'package:cocomanager/screens/home_screen.dart';
import 'package:cocomanager/screens/stok_screen.dart';
import 'package:cocomanager/screens/history_screen.dart';
import 'package:cocomanager/screens/analisis_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _historyTabIndex = 0;

  void _onNavigate(int bottomIndex, int tabIndex) {
    setState(() {
      _currentIndex = bottomIndex;
      _historyTabIndex = tabIndex;
    });
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(onNavigate: _onNavigate);
      case 1:
        return const StokScreen();
      case 2:
        return HistoryScreen(initialTab: _historyTabIndex);
      case 3:
        return const AnalisisScreen();
      default:
        return HomeScreen(onNavigate: _onNavigate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analisis'),
        ],
      ),
    );
  }
}

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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF006D5B),
            unselectedItemColor: Colors.grey.shade400,
            showUnselectedLabels: true,
            elevation: 0,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.inventory_2_rounded), label: 'Stock'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'History'),
              BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Analisis'),
            ],
          ),
        ),
      ),
    );
  }
}

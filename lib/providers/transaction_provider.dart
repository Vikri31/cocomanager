import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';
import '../database/database_helper.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  int _defaultSellingPrice = 5000;
  int get currentDefaultSellingPrice => _defaultSellingPrice;

  DateTime? _selectedDateFilter;
  DateTime? get selectedDateFilter => _selectedDateFilter;

  void setSelectedDateFilter(DateTime? date) {
    _selectedDateFilter = date;
    notifyListeners();
  }

  List<TransactionModel> get purchases => 
      _transactions.where((t) => t.type == 'pembelian').toList();
      
  List<TransactionModel> get sales => 
      _transactions.where((t) => t.type == 'penjualan').toList();

  int get currentStockKelapa {
    int bought = purchases.fold(0, (sum, t) => sum + t.amount);
    int sold = sales.where((t) => t.category == 'kelapa').fold(0, (sum, t) => sum + t.amount);
    return bought - sold;
  }

  int get todayIncome {
    final now = DateTime.now();
    return sales.where((t) {
      return t.date.year == now.year && t.date.month == now.month && t.date.day == now.day;
    }).fold(0, (sum, t) => sum + t.price);
  }

  int get todaySalesAmount {
    final now = DateTime.now();
    return sales.where((t) {
      return t.category == 'kelapa' && t.date.year == now.year && t.date.month == now.month && t.date.day == now.day;
    }).fold(0, (sum, t) => sum + t.amount);
  }

  List<TransactionModel> get todaySalesTransactions {
    final now = DateTime.now();
    var list = sales.where((t) {
      return t.category == 'kelapa' && t.date.year == now.year && t.date.month == now.month && t.date.day == now.day;
    }).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  List<TransactionModel> get filteredDailySales {
    final targetDate = _selectedDateFilter ?? DateTime.now();
    var list = sales.where((t) {
      return t.category == 'kelapa' && t.date.year == targetDate.year && t.date.month == targetDate.month && t.date.day == targetDate.day;
    }).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Map<int, int> get todayHourlySales {
    final now = DateTime.now();
    Map<int, int> hourly = {};
    for (var t in sales.where((t) => t.category == 'kelapa' && t.date.year == now.year && t.date.month == now.month && t.date.day == now.day)) {
      int hour = t.date.hour;
      hourly[hour] = (hourly[hour] ?? 0) + t.amount;
    }
    return hourly;
  }

  int get currentMonthIncome {
    final now = DateTime.now();
    return sales.where((t) => t.date.year == now.year && t.date.month == now.month).fold(0, (sum, t) => sum + t.price);
  }

  int get currentMonthExpense {
    final now = DateTime.now();
    return purchases.where((t) => t.date.year == now.year && t.date.month == now.month).fold(0, (sum, t) => sum + t.price);
  }

  List<Map<String, dynamic>> get monthlyHistory {
    Map<String, Map<String, dynamic>> grouped = {};
    for (var t in sales) {
      String period = '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}';
      if (!grouped.containsKey(period)) {
        grouped[period] = {'kelapaTerjual': 0, 'pendapatanKotor': 0, 'period': t.date};
      }
      if (t.category == 'kelapa') {
        grouped[period]!['kelapaTerjual'] += t.amount;
      }
      grouped[period]!['pendapatanKotor'] += t.price;
    }
    var list = grouped.values.toList();
    list.sort((a, b) => (b['period'] as DateTime).compareTo(a['period'] as DateTime));
    return list;
  }

  Map<String, double> get salesComposition {
    final now = DateTime.now();
    double kelapaIncome = 0;
    double nonKelapaIncome = 0;
    for (var t in sales.where((t) => t.date.year == now.year && t.date.month == now.month)) {
      if (t.category == 'kelapa') kelapaIncome += t.price;
      else nonKelapaIncome += t.price;
    }
    double total = kelapaIncome + nonKelapaIncome;
    if (total == 0) return {'kelapa': 50.0, 'nonKelapa': 50.0}; 
    return {
      'kelapa': (kelapaIncome / total) * 100,
      'nonKelapa': (nonKelapaIncome / total) * 100,
    };
  }

  List<double> get yearlySalesTrend {
    final now = DateTime.now();
    List<double> trend = List.filled(12, 0.0);
    for (var t in sales.where((t) => t.date.year == now.year && t.category == 'kelapa')) {
      trend[t.date.month - 1] += t.amount;
    }
    return trend;
  }

  Future<void> setDefaultSellingPrice(int price) async {
    _defaultSellingPrice = price;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('defaultSellingPrice', price);
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    _defaultSellingPrice = prefs.getInt('defaultSellingPrice') ?? 5000;
    
    _transactions = await _dbHelper.getTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _dbHelper.insertTransaction(transaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await _dbHelper.deleteTransaction(id);
    await loadTransactions();
  }
}

import "package:flutter/material.dart";
import "package:flutter/material.dart";
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  final Function(int, int)? onNavigate;
  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Mengambil data dari provider
    final String todayIncomeStr = currencyFormat.format(provider.todayIncome);
    final String todaySalesStr = '${provider.todaySalesAmount} Buah';
    final int currentStock = provider.currentStockKelapa;
    final String currentStockStr = '$currentStock Buah';

    // Logika warna stok (< 50 jadi merah)
    final Color stockCardColor = currentStock < 50
        ? Colors.red
        : const Color.fromARGB(255, 42, 184, 147);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        children: [
          if (currentStock < 50)
            Container(
              margin: const EdgeInsets.fromLTRB(28.0, 10.0, 28.0, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Peringatan: Stok kelapa Anda sisa $currentStock butir. Segera lakukan restock!',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // --- RINGKASAN DASHBOARD ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF006D5B), Color(0xFF004D40)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF006D5B).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pendapatan Hari Ini',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          todayIncomeStr,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Terjual',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          todaySalesStr,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: currentStock < 50 ? Colors.red : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sisa Stok',
                          style: TextStyle(
                            color: currentStock < 50
                                ? Colors.white70
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentStockStr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: currentStock < 50
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- CARD 3: GRAFIK TREND (LINE CHART) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trend Penjualan (Butir)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: LineChart(mainData(provider.todayHourlySales)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- SECTION: TRANSAKSI HARI INI ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaksi Hari Ini',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton(
                  onPressed: () {
                    widget.onNavigate?.call(2, 0);
                  },
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
          ),
          ...provider.todaySalesTransactions.take(5).map((t) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 28.0),
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
                child: const Icon(Icons.sell, color: Colors.blueAccent),
              ),
              title: Text(
                '${t.amount} Butir Kelapa',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${t.date.hour.toString().padLeft(2, '0')}:${t.date.minute.toString().padLeft(2, '0')} - ${t.description}',
              ),
              trailing: Text(
                currencyFormat.format(t.price),
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
          if (provider.todaySalesTransactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
              child: Center(child: Text('Belum ada penjualan hari ini')),
            ),
          const SizedBox(height: 80),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickSaleModal(context),
        backgroundColor: const Color(0xFF006D5B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showQuickSaleModal(BuildContext context) {
    final defaultPrice = context
        .read<TransactionProvider>()
        .currentDefaultSellingPrice;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return QuickSaleForm(defaultPrice: defaultPrice);
      },
    );
  }

  // Fungsi pembantu untuk membuat kotak kecil (Sales & Stock)
  Widget _buildSmallCard(String title, String value, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: bgColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIKA GRAFIK (FL_CHART) ---
  LineChartData mainData(Map<int, int> hourlySales) {
    List<FlSpot> spots = [];
    double maxY = 10;

    for (int i = 6; i <= 18; i += 2) {
      int amount = (hourlySales[i] ?? 0) + (hourlySales[i + 1] ?? 0);
      if (amount > maxY) maxY = amount.toDouble();
      spots.add(FlSpot(i.toDouble(), amount.toDouble()));
    }
    maxY = ((maxY / 10).ceil() * 10.0);
    if (maxY == 0) maxY = 10;
    double intervalY = maxY / 5 > 0 ? maxY / 5 : 1;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: intervalY,
        verticalInterval: 2,
        getDrawingHorizontalLine: (value) =>
            const FlLine(color: Colors.black12, strokeWidth: 1),
        getDrawingVerticalLine: (value) =>
            const FlLine(color: Colors.black12, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 2,
            getTitlesWidget: (value, meta) {
              int hour = value.toInt();
              if (hour >= 6 && hour <= 18) {
                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  child: Text(
                    '${hour.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: intervalY,
            getTitlesWidget: (value, meta) =>
                Text('${value.toInt()}', style: const TextStyle(fontSize: 10)),
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 6,
      maxX: 18,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.blueAccent,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false), // Garis saja tanpa background
        ),
      ],
    );
  }
}

class QuickSaleForm extends StatefulWidget {
  final int defaultPrice;
  const QuickSaleForm({super.key, required this.defaultPrice});

  @override
  State<QuickSaleForm> createState() => _QuickSaleFormState();
}

class _QuickSaleFormState extends State<QuickSaleForm> {
  final _formKey = GlobalKey<FormState>();
  final _buyerController = TextEditingController(text: 'Pelanggan');
  final _amountController = TextEditingController();
  final _priceController = TextEditingController();
  late final TextEditingController _pricePerUnitController;

  final _qtyFocusNode = FocusNode();
  final _pricePerUnitFocusNode = FocusNode();
  final _totalPriceFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pricePerUnitController = TextEditingController(
      text: widget.defaultPrice.toString(),
    );
    _amountController.addListener(_calculate);
    _pricePerUnitController.addListener(_calculate);
    _priceController.addListener(_calculate);
  }

  @override
  void dispose() {
    _buyerController.dispose();
    _amountController.dispose();
    _priceController.dispose();
    _pricePerUnitController.dispose();
    _qtyFocusNode.dispose();
    _pricePerUnitFocusNode.dispose();
    _totalPriceFocusNode.dispose();
    super.dispose();
  }

  void _calculate() {
    double qty = double.tryParse(_amountController.text) ?? 0;

    if (_pricePerUnitFocusNode.hasFocus || _qtyFocusNode.hasFocus) {
      double ppu = double.tryParse(_pricePerUnitController.text) ?? 0;
      if (qty > 0 && ppu > 0) {
        String newTotal = (qty * ppu).round().toString();
        if (_priceController.text != newTotal) {
          _priceController.text = newTotal;
        }
      }
    } else if (_totalPriceFocusNode.hasFocus) {
      double total = double.tryParse(_priceController.text) ?? 0;
      if (qty > 0 && total > 0) {
        String newPpu = (total / qty).round().toString();
        if (_pricePerUnitController.text != newPpu) {
          _pricePerUnitController.text = newPpu;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStock = context
        .watch<TransactionProvider>()
        .currentStockKelapa;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Penjualan Cepat',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _buyerController,
                decoration: InputDecoration(
                  labelText: 'Nama Pembeli',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _amountController,
                focusNode: _qtyFocusNode,
                decoration: InputDecoration(
                  labelText: 'Jumlah Kelapa (Butir)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Wajib diisi';
                  final qty = int.tryParse(val);
                  if (qty == null || qty <= 0) return 'Jumlah tidak valid';
                  if (qty > currentStock)
                    return 'Stok tidak cukup! (Sisa: $currentStock)';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _pricePerUnitController,
                      focusNode: _pricePerUnitFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Harga per biji (Rp)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      focusNode: _totalPriceFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Harga Total (Rp)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006D5B),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final transaction = TransactionModel(
                        type: 'penjualan',
                        category: 'kelapa',
                        amount: int.parse(_amountController.text),
                        weight: 0.0,
                        price: int.parse(_priceController.text),
                        description: _buyerController.text,
                        date: DateTime.now(),
                      );
                      context.read<TransactionProvider>().addTransaction(
                        transaction,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Penjualan berhasil dicatat!'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Simpan Penjualan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

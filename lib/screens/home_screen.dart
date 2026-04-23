import "package:flutter/material.dart";
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView(
        children: [
          // --- CARD 1: PENDAPATAN ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Colors.orangeAccent, Colors.deepOrange],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pendapatan hari ini',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rp 210.000',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- CARD 2: PENJUALAN & STOK (ROW) ---
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 5.0,
            ),
            child: Row(
              children: [
                _buildSmallCard('Penjualan hari ini', '14 Buah'),
                const SizedBox(width: 15),
                _buildSmallCard('Sisa stok kelapa', '36 Buah'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- CARD 3: GRAFIK TREND (LINE CHART) ---
          // --- CARD 3: GRAFIK TREND (LINE CHART) ---
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 1,
            ), // Padding luar agar tidak full width
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Warna background
                borderRadius: BorderRadius.circular(
                  15,
                ), // Agar sudutnya melengkung sama seperti kartu lainnya
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  16.0,
                ), // Padding dalam untuk isi konten
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
                    SizedBox(height: 200, child: LineChart(mainData())),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi ketika tombol ditekan (misal: buka form tambah data)
          print("Tombol tambah ditekan!");
        },
        backgroundColor: Colors.blueAccent, // Warna ungu/biru sesuai desainmu
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Fungsi pembantu untuk membuat kotak kecil (Sales & Stock)
  Widget _buildSmallCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(
            255,
            42,
            184,
            147,
          ), // Warna biru untuk kedua kotak kecil
          // gradient: const LinearGradient(
          //   colors: [Colors.orangeAccent, Colors.deepOrange],
          // ),
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

  // --- LOGIKA GRAFIK (FL_CHART SAMPLE 2) ---
  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 1,
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
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              // Mapping Jam Transaksi
              switch (value.toInt()) {
                case 0:
                  return const Text('07:00', style: TextStyle(fontSize: 10));
                case 2:
                  return const Text('10:00', style: TextStyle(fontSize: 10));
                case 4:
                  return const Text('13:00', style: TextStyle(fontSize: 10));
                case 6:
                  return const Text('16:00', style: TextStyle(fontSize: 10));
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: (value, meta) =>
                Text('${value.toInt()}', style: const TextStyle(fontSize: 10)),
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 7,
      minY: 0,
      maxY: 60,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 20),
            FlSpot(1, 15),
            FlSpot(2, 45),
            FlSpot(3, 30),
            FlSpot(4, 50),
            FlSpot(5, 35),
            FlSpot(6, 40),
          ],
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

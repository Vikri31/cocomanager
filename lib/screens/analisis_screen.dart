import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';

class AnalisisScreen extends StatelessWidget {
  const AnalisisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final income = provider.currentMonthIncome;
    final expense = provider.currentMonthExpense;
    final comp = provider.salesComposition;
    final trend = provider.yearlySalesTrend;

    return Scaffold(
      appBar: AppBar(title: const Text('Analisis')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A73E8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pemasukan bulan ini', style: TextStyle(color: Colors.white, fontSize: 12)),
                      const SizedBox(height: 5),
                      Text(currencyFormat.format(income), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2AB091),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pengeluaran bulan ini', style: TextStyle(color: Colors.white, fontSize: 12)),
                      const SizedBox(height: 5),
                      Text(currencyFormat.format(expense), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          color: const Color(0xFF006D5B),
                          value: comp['kelapa']! == 0 && comp['nonKelapa']! == 0 ? 50 : comp['kelapa'],
                          title: '${comp['kelapa']?.toStringAsFixed(0)}%',
                          radius: 20,
                          titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        PieChartSectionData(
                          color: const Color(0xFFF4A261),
                          value: comp['kelapa']! == 0 && comp['nonKelapa']! == 0 ? 50 : comp['nonKelapa'],
                          title: '${comp['nonKelapa']?.toStringAsFixed(0)}%',
                          radius: 20,
                          titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF006D5B), shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          const Expanded(child: Text('penjualan kelapa', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFF4A261), shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          const Expanded(child: Text('penjualan non-kelapa', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tren Tahunan (Butir)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true, drawVerticalLine: true, getDrawingHorizontalLine: (value) => const FlLine(color: Colors.black12, strokeWidth: 1)),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 2,
                            getTitlesWidget: (value, meta) {
                              const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
                              int index = value.toInt();
                              if (index >= 0 && index < 12) {
                                return SideTitleWidget(
                                  meta: meta,
                                  space: 8,
                                  child: Text(months[index], style: const TextStyle(fontSize: 10)),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 11,
                      minY: 0,
                      lineBarsData: [
                        LineChartBarData(
                          spots: trend.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                          isCurved: true,
                          color: const Color(0xFF7B61FF),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

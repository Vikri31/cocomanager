import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';

class HistoryScreen extends StatelessWidget {
  final int initialTab;
  const HistoryScreen({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final selectedDateStr = provider.selectedDateFilter == null 
        ? 'Hari Ini' 
        : DateFormat('dd MMM yyyy').format(provider.selectedDateFilter!);

    return DefaultTabController(
      key: ValueKey(initialTab),
      length: 2,
      initialIndex: initialTab,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: provider.selectedDateFilter ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (selected != null) {
                  provider.setSelectedDateFilter(selected);
                }
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: selectedDateStr),
              const Tab(text: 'Bulanan'),
            ],
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blueAccent,
          ),
        ),
        body: const TabBarView(
          children: [
            _TodayHistoryTab(),
            _MonthlyHistoryTab(),
          ],
        ),
      ),
    );
  }
}

class _TodayHistoryTab extends StatelessWidget {
  const _TodayHistoryTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final history = provider.filteredDailySales;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    if (history.isEmpty) {
      return const Center(child: Text('Belum ada data penjualan pada tanggal ini'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final t = history[index];
        return Dismissible(
          key: Key(t.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Hapus Transaksi?'),
                content: const Text('Apakah Anda yakin ingin menghapus data penjualan ini? Stok akan otomatis dikembalikan.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true), 
                    child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            if (t.id != null) {
              provider.deleteTransaction(t.id!);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaksi berhasil dihapus')));
            }
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28.0),
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
              child: const Icon(Icons.sell, color: Colors.blueAccent),
            ),
            title: Text('${t.amount} Butir Kelapa', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${t.date.hour.toString().padLeft(2, '0')}:${t.date.minute.toString().padLeft(2, '0')} - ${t.description}'),
            trailing: Text(currencyFormat.format(t.price), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}

class _MonthlyHistoryTab extends StatelessWidget {
  const _MonthlyHistoryTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final history = provider.monthlyHistory;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    if (history.isEmpty) {
      return const Center(child: Text('Belum ada histori bulanan'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final DateTime periodDate = item['period'];
        final String periodStr = DateFormat('MMMM yyyy').format(periodDate);

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('kelapa terjual', style: TextStyle(color: Colors.black, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text('${item['kelapaTerjual']}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('periode', style: TextStyle(color: Colors.black, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(periodStr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('pendapatan kotor', style: TextStyle(color: Color(0xFF1E8E75), fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(currencyFormat.format(item['pendapatanKotor']), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E8E75))),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

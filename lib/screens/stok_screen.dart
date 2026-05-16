import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class StokScreen extends StatefulWidget {
  const StokScreen({super.key});

  @override
  State<StokScreen> createState() => _StokScreenState();
}

class _StokScreenState extends State<StokScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('Stok')),
        body: Column(
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: TabBar(
                labelColor: Colors.blueAccent,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blueAccent,
                tabs: [
                  Tab(text: 'Pembelian'),
                  Tab(text: 'Penjualan'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Pembelian(),
                  Penjualan(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTransactionDialog(context),
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddTransactionForm(),
      ),
    );
  }
}

// ==========================================
// FORM TAMBAH TRANSAKSI
// ==========================================
class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'pembelian';
  String _category = 'kelapa';
  
  final _amountController = TextEditingController();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  final _pricePerUnitController = TextEditingController();
  final _descController = TextEditingController();
  
  final _qtyFocusNode = FocusNode();
  final _pricePerUnitFocusNode = FocusNode();
  final _totalPriceFocusNode = FocusNode();
  
  DateTime _selectedDate = DateTime.now();

  double _modalPrice = 0;

  @override
  void initState() {
    super.initState();
    // Inisialisasi dengan harga jual global
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final defaultPrice = context.read<TransactionProvider>().currentDefaultSellingPrice;
      _pricePerUnitController.text = defaultPrice.toString();
    });

    _amountController.addListener(_calculate);
    _weightController.addListener(_calculate);
    _pricePerUnitController.addListener(_calculate);
    _priceController.addListener(_calculate);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    _pricePerUnitController.dispose();
    _descController.dispose();
    _qtyFocusNode.dispose();
    _pricePerUnitFocusNode.dispose();
    _totalPriceFocusNode.dispose();
    super.dispose();
  }

  void _calculate() {
    double qty = 0;
    if (_category == 'kelapa') {
      qty = double.tryParse(_amountController.text) ?? 0;
    } else {
      qty = double.tryParse(_weightController.text) ?? 0;
    }

    if (_type == 'pembelian') {
      // Untuk pembelian, hitung harga modal saja untuk ditampilkan
      double total = double.tryParse(_priceController.text) ?? 0;
      setState(() {
        _modalPrice = (qty > 0 && total > 0) ? total / qty : 0;
      });
    } else {
      // Untuk penjualan, kalkulasi otomatis dua arah
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tambah Transaksi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Beli'),
                    value: 'pembelian',
                    groupValue: _type,
                    onChanged: (value) => setState(() { _type = value!; _category = 'kelapa'; }),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Jual'),
                    value: 'penjualan',
                    groupValue: _type,
                    onChanged: (value) => setState(() => _type = value!),
                  ),
                ),
              ],
            ),
            if (_type == 'penjualan')
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Jenis Barang'),
                items: const [
                  DropdownMenuItem(value: 'kelapa', child: Text('Kelapa')),
                  DropdownMenuItem(value: 'batok kelapa', child: Text('Batok Kelapa')),
                  DropdownMenuItem(value: 'kulit kelapa', child: Text('Kulit Kelapa')),
                ],
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                    _amountController.clear();
                    _weightController.clear();
                  });
                },
              ),
            if (_category == 'kelapa')
              TextFormField(
                controller: _amountController,
                focusNode: _qtyFocusNode,
                decoration: const InputDecoration(labelText: 'Jumlah (Butir)'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
            if (_category != 'kelapa')
              TextFormField(
                controller: _weightController,
                focusNode: _qtyFocusNode,
                decoration: const InputDecoration(labelText: 'Berat (kg)'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _pricePerUnitController,
                    focusNode: _pricePerUnitFocusNode,
                    decoration: InputDecoration(
                      labelText: _type == 'pembelian' 
                          ? 'Set Harga Jual/${_category == 'kelapa' ? 'biji' : 'kg'} (Rp)' 
                          : 'Harga Jual/${_category == 'kelapa' ? 'biji' : 'kg'} (Rp)'
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _priceController,
                        focusNode: _totalPriceFocusNode,
                        decoration: InputDecoration(
                          labelText: _type == 'pembelian' ? 'Total Harga Beli (Rp)' : 'Total Harga Jual (Rp)'
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                      ),
                      if (_type == 'pembelian' && _modalPrice > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            '(Harga Modal: Rp ${_modalPrice.toStringAsFixed(0)}/${_category == 'kelapa' ? 'butir' : 'kg'})',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(labelText: _type == 'pembelian' ? 'Lokasi / Keterangan' : 'Keterangan'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tanggal: ${DateFormat('dd MMM yyyy').format(_selectedDate)}'),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                  child: const Text('Pilih Tanggal'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Simpan Harga Jual Global jika ini kelapa
      if (_category == 'kelapa' && _pricePerUnitController.text.isNotEmpty) {
        context.read<TransactionProvider>().setDefaultSellingPrice(int.parse(_pricePerUnitController.text));
      }

      final transaction = TransactionModel(
        type: _type,
        category: _category,
        amount: _amountController.text.isNotEmpty ? int.parse(_amountController.text) : 0,
        weight: _weightController.text.isNotEmpty ? double.parse(_weightController.text) : 0.0,
        price: int.parse(_priceController.text),
        description: _descController.text,
        date: _selectedDate,
      );
      context.read<TransactionProvider>().addTransaction(transaction);
      Navigator.pop(context);
    }
  }
}

// ==========================================
// TAB PEMBELIAN
// ==========================================
class Pembelian extends StatelessWidget {
  const Pembelian({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final purchases = provider.purchases;
    final int currentStock = provider.currentStockKelapa;
    
    // Asumsi: Transaksi pembelian terakhir ada di indeks 0 jika diurutkan DESC
    TransactionModel? lastPurchase;
    if (purchases.isNotEmpty) lastPurchase = purchases.first;

    return Column(
      children: [
        // KARTU SISA STOK
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [Color(0xFF2AB091), Color(0xFF1E8E75)],
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('sisa stok', style: TextStyle(color: Colors.white, fontSize: 12)),
                    Text('$currentStock', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lastPurchase?.description ?? 'Belum ada data', style: const TextStyle(color: Colors.white, fontSize: 14)),
                      if (lastPurchase != null)
                        Text(DateFormat('dd MMMM yyyy').format(lastPurchase.date), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(color: Colors.deepPurple, thickness: 5),
        // LIST RIWAYAT PEMBELIAN
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            itemCount: purchases.length,
            itemBuilder: (context, index) {
              final trx = purchases[index];
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
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('stok beli', style: TextStyle(color: Colors.black54, fontSize: 12)),
                        Text('${trx.amount}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ],
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(trx.description, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                          Text(DateFormat('dd MMMM yyyy').format(trx.date), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==========================================
// TAB PENJUALAN
// ==========================================
class Penjualan extends StatelessWidget {
  const Penjualan({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final sales = provider.sales;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final trx = sales[index];
        final bool isKelapa = trx.category == 'kelapa';
        final String labelQty = isKelapa ? 'jumlah' : 'berat (kg)';
        final String valueQty = isKelapa ? '${trx.amount}' : '${trx.weight}';

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
                    Text(labelQty, style: const TextStyle(color: Colors.black, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(valueQty, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trx.category, style: const TextStyle(color: Colors.black, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(DateFormat('dd MMM yyyy').format(trx.date), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('harga jual', style: TextStyle(color: Colors.black, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(currencyFormat.format(trx.price), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 17, 199, 68))),
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

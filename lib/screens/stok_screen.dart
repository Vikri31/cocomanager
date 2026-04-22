import "package:flutter/material.dart";

class StokScreen extends StatefulWidget {
  const StokScreen({super.key});

  @override
  State<StokScreen> createState() => _StokScreenState();
}

class Pembelian extends StatefulWidget {
  const Pembelian({super.key});

  @override
  State<Pembelian> createState() => _PembelianState();
}

class _StokScreenState extends State<StokScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(title: const Text('Stok')),
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    // horizontal: 28.0,
                    vertical: 10.0,
                  ),
                  child: const TabBar(
                    tabs: [
                      // Tab(icon: Icon(Icons.directions_car)),
                      Tab(text: 'Pembelian'),
                      Tab(text: 'Penjualan'),
                    ],
                  ),
                ),
                Expanded(
                  // child: Container(
                  child: const TabBarView(
                    children: [
                      // Center(child: Text('Data Pembelian')),
                      const Pembelian(),
                      Center(child: Text('Data Penjualan')),
                    ],
                  ),

                  // ),
                ),
              ],
            ),
          ),
          //   ),
          // ),

          // TODO: Tambahkan FloatingActionButton untuk menambah stok baru
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Aksi ketika tombol ditekan (misal: buka form tambah data)
              print("Tombol tambah ditekan!");
            },
            backgroundColor:
                Colors.blueAccent, // Warna ungu/biru sesuai desainmu
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _PembelianState extends State<Pembelian> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      children: [
        // ---------------------------------------------------------
        // KARTU 1: SISA STOK (HIJAU/GRADASI)
        // ---------------------------------------------------------
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Color(0xFF2AB091), Color(0xFF1E8E75)], // Hijau-hijauan
            ),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'sisa stok',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    '36',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Pasar Legi',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      '21 Februari 2026',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),
        const Divider(
          color: Colors.deepPurple,
          thickness: 5,
        ), // Garis Ungu Pembatas
        const SizedBox(height: 15),

        // ---------------------------------------------------------
        // KARTU 2: RIWAYAT 1 (PUTIH) - DISINI MULAI KETIK ULANG LAGI
        // ---------------------------------------------------------
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'stok beli',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  Text(
                    '55',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Pasar Legi',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    Text(
                      '16 Februari 2026',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // ---------------------------------------------------------
        // KARTU 3: RIWAYAT 2 (PUTIH) - KETIK ULANG LAGI DAN LAGI
        // ---------------------------------------------------------
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'stok beli',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  Text(
                    '75',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Pasar Legi',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    Text(
                      '11 Februari 2026',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

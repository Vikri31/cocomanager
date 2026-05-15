# Dokumen Desain Kebutuhan Produk (PRD) - CocoManager

**Versi:** 1.0  
**Status:** Draft Desain  
**Proyek:** Aplikasi Manajemen Penjualan & Inventaris Kelapa  

---

## 1. Pendahuluan
CocoManager adalah aplikasi mobile berbasis Flutter yang dirancang khusus untuk mendigitalisasi operasional bisnis retail kelapa. Aplikasi ini fokus pada pencatatan transaksi harian, pemantauan stok secara real-time, dan penyajian data analitik untuk membantu pengambilan keputusan bisnis bagi pemilik (orang tua user).

## 2. Struktur Navigasi Utama
Aplikasi menggunakan **Bottom Navigation Bar** dengan 4 menu utama:
1.  **Home:** Ringkasan performa harian.
2.  **Stock:** Pengelolaan inventaris (Pembelian & Penjualan).
3.  **History:** Akumulasi data bulanan.
4.  **Analisis:** Statistik dan tren performa jangka panjang.

---

## 3. Spesifikasi Fitur per Halaman

### 3.1 Halaman Home (Beranda)
Tujuan: Memberikan gambaran cepat mengenai kondisi bisnis hari ini.
- **Komponen Dashboard (Ringkasan):**
    - **Jumlah Pendapatan:** Total uang masuk dari penjualan hari ini (Rp).
    - **Jumlah Penjualan:** Total butir/unit kelapa yang terjual hari ini.
    - **Sisa Stok:** Jumlah kelapa yang tersedia di gudang saat ini.
    - Jika Sisa Stok < 50 butir, ubah warna Card menjadi merah muda dan tampilkan ikon peringatan di Halaman Home.
- **Visualisasi Data:**
    - **Trend Line Chart:** Grafik fluktuasi penjualan per jam selama satu hari penuh (07:00 - selesai).
- **Log Histori:**
    - Daftar transaksi yang terjadi khusus pada hari berjalan (Waktu, Jumlah, Harga).


### 3.2 Halaman Stock (Pengelolaan Inventaris)
Halaman ini menggunakan **TabBar** untuk memisahkan logika stok masuk dan pencatatan detail barang terjual.

#### A. Tab Pembelian (Stok Masuk)
- **Header Card (Warna Hijau):**
    - Menampilkan sisa stok saat ini (Data dinamis/fluktuatif).
    - Keterangan lokasi pembelian terakhir.
    - Tanggal pembelian terakhir.
- **List Riwayat Pembelian:**
    - Menampilkan riwayat stok yang dibeli sebelumnya.
    - Detail: Jumlah stok beli, lokasi supplier, dan tanggal transaksi.
- **Fitur Tambah Stok (FAB):**
    - Tombol melayang (+) di pojok kanan bawah.
    - **Popup Input:**
        - Input jumlah stok beli (Numeric).
        - Input lokasi pembelian (Text).
        - Input tanggal pembelian (Date Picker).

#### B. Tab Penjualan (Detail Barang Keluar)
- **List Card Penjualan:**
    - Mencatat detail spesifik barang yang keluar.
    - **Atribut Data:**
        - Berat barang (kg).
        - Jenis barang terjual (Dropdown Select: Batok Kelapa, Kulit Kelapa, dsb).
        - Periode tanggal transaksi.
        - Harga jual total (Rp).

### 3.3 Halaman History (Akumulasi Bulanan)
Tujuan: Melacak pencapaian kumulatif dalam satu periode bulan berjalan.
- **Logika Update:** Data terupdate secara otomatis berdasarkan input mingguan.
    - *Contoh:* Minggu I (100) + Minggu II (80) = Tampilan History (180).
- **Informasi Utama:**
    - Total kelapa terjual dalam bulan ini.
    - Periode bulan aktif.
    - Total pendapatan kumulatif bulan ini.

### 3.4 Halaman Analisis
Tujuan: Memberikan wawasan mendalam (Business Intelligence) untuk pemilik.
- **Metrik Utama:**
    - Total pemasukan bulan ini vs bulan lalu.
    - Total volume penjualan bulan ini.
- **Grafik Perbandingan (Pie/Donut Chart):**
    - Perbandingan volume penjualan Kelapa Utama vs Penjualan Non-Kelapa (Batok/Kulit).
- **Grafik Tren Tahunan (Bar/Line Chart):**
    - Tren penjualan dari bulan Januari hingga Desember untuk melihat musim puncak (Peak Season).

---

## 4. Kebutuhan Teknis & UI/UX
- **Framework:** Flutter (Dart).
- **Library Grafik:** `fl_chart` (untuk Line, Bar, dan Pie Chart).
- **Manajemen State:** `StatefulWidget` (Direkomendasikan transisi ke Provider).
- **UI Style:**
    - Card-based design dengan elevasi rendah.
    - Penggunaan Gradient (Orange/Deep Orange untuk finansial, Teal/Green untuk stok).
    - Tipografi tebal (Bold) untuk angka-angka penting.
- **Penyimpanan Data:** Lokal (SQLite).

---

## 5. Alur Data (Data Flow)
1.  **Input Penjualan (Home/Stock):** Mengurangi angka 'Sisa Stok' dan menambah 'Pendapatan Hari Ini'.
2.  **Input Pembelian (Stock Tab):** Menambah angka 'Sisa Stok'.
3.  **Rekap Sejarah:** Setiap transaksi disimpan dengan Timestamp untuk diakumulasikan pada halaman 'History' dan 'Analisis'.

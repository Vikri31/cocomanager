# Dokumen Kebutuhan Produk (PRD) - CocoManager

**Versi:** 2.0 (Update Berdasarkan Perubahan Arsitektur & UI/UX)
**Status:** Aktif
**Proyek:** Aplikasi Manajemen Penjualan & Inventaris Kelapa

---

## 1. Pendahuluan
CocoManager adalah aplikasi mobile berbasis Flutter yang dirancang khusus untuk mendigitalisasi operasional bisnis retail kelapa. Aplikasi ini fokus pada pencatatan transaksi harian, pemantauan stok secara real-time, dan penyajian data analitik untuk membantu pengambilan keputusan bisnis. 

---

## 2. Tujuan Aplikasi (Goals)
Pengembangan aplikasi ini memiliki beberapa tujuan utama yang berfokus pada penyelesaian masalah bisnis secara praktis:
1. **Digitalisasi & Efisiensi Pencatatan:** Menggantikan pembukuan manual menggunakan kertas menjadi sistem digital yang terpusat. Hal ini akan mempercepat proses entri data saat toko sedang sibuk.
2. **Kendali Inventaris yang Akurat:** Memberikan peringatan dini (early warning) dan visibilitas yang transparan mengenai jumlah stok gudang secara *real-time* untuk menghindari skenario kehabisan barang (*out-of-stock*).
3. **Wawasan Bisnis (Business Intelligence):** Menyajikan performa bisnis (pendapatan, produk terlaris, dan tren penjualan bulanan) ke dalam bentuk grafik visual yang mudah dicerna oleh pemilik bisnis (seperti orang tua user), sehingga memudahkan pengambilan keputusan strategis.
4. **Stabilitas dan Kemudahan Penggunaan:** Menghadirkan antarmuka pengguna (UI) yang nyaman di mata, tidak padat (bebas dari *layout gap* yang salah), sangat responsif di berbagai perangkat, serta menjamin data tersinkronisasi tanpa lag.

---

## 3. Fungsi Inti dan Perilaku Aplikasi (Core Functions & Behaviors)
Berikut adalah daftar fungsi utama beserta bagaimana sistem akan berperilaku (behavior) saat berinteraksi dengan pengguna:

### 3.1 Fungsi Manajemen Transaksi (Transaction Management)
- **Fungsi:** Menyediakan formulir untuk mencatat barang keluar (penjualan) beserta atribut berat, jenis barang, dan harga, serta barang masuk (pembelian dari supplier).
- **Perilaku:** Saat pengguna memasukkan transaksi baru, sistem akan langsung melakukan validasi dan pembaruan database secara *background*. Setelah berhasil, total pendapatan hari itu dan angka sisa stok akan langsung ter-update di layar secara instan.

### 3.2 Fungsi Penjualan Cepat (Quick Sale)
- **Fungsi:** Sebuah alat (shortcut) di halaman utama (Home) untuk melakukan transaksi penjualan dalam waktu hitungan detik.
- **Perilaku:** Ketika diakses, sistem secara pintar akan menarik data dari histori transaksi terakhir dan mengisi form harga (*auto-populate pricing*) secara otomatis. Pengguna hanya perlu mengubah jumlah/berat jika diperlukan, sehingga menghemat banyak waktu.

### 3.3 Fungsi Sistem Peringatan Stok (Alert System)
- **Fungsi:** Memonitor batas bawah ketersediaan stok kelapa di gudang.
- **Perilaku:** Aplikasi secara aktif akan mengawasi *Sisa Stok*. Jika angka menyentuh di bawah 50 butir, perilaku antarmuka pada kartu stok akan langsung berubah (beralih ke *background* merah mencolok beserta ikon peringatan) sebagai panggilan tindakan yang mendesak bagi pemilik.

### 3.4 Fungsi Analisis Visual (Visual Analytics)
- **Fungsi:** Merangkum dan memproses raw data (data mentah) penjualan bulanan maupun harian menjadi representasi visual (Grafik Garis / Line Chart dan Grafik Lingkaran / Pie Chart).
- **Perilaku:** Fungsi ini akan menyesuaikan batasan ruang (constraints) secara otomatis. Jadi, saat layar smartphone berukuran kecil, grafik tidak akan meluap (overflow) atau bertumpuk, melainkan tetap proporsional dan interaktif.

### 3.5 Fungsi Sinkronisasi Data Otomatis (State Synchronization)
- **Fungsi:** Mengatur lalu lintas data antar-layar menggunakan arsitektur `Provider`.
- **Perilaku:** Ketika pengguna menambahkan stok di tab "Stock", sistem otomatis mengirimkan sinyal pembaruan (`notifyListeners()`) yang seketika itu juga memperbarui angka stok di halaman "Home", tanpa mengharuskan pengguna melakukan *refresh* atau pindah halaman bolak-balik.

---

## 4. Struktur Navigasi Utama
Aplikasi menggunakan **Bottom Navigation Bar** dengan 4 menu utama:
1.  **Home:** Ringkasan performa harian dan entri penjualan cepat (Quick Sale).
2.  **Stock:** Pengelolaan inventaris (Pembelian & Penjualan) dengan perbaikan form transaksi tanpa aksen warna ungu yang tidak konsisten.
3.  **History:** Akumulasi data historis transaksi secara bulanan.
4.  **Analisis:** Statistik, rasio penjualan kelapa vs non-kelapa, dan tren tahunan.

---

## 5. Kebutuhan Teknis & Arsitektur
- **Framework:** Flutter (Dart).
- **Manajemen State (State Management):** Pola **Provider** digunakan secara penuh.
- **Penyimpanan Data:** **SQLite** digunakan sebagai arsitektur database lokal yang persisten.
- **UI/UX Standar:**
    - Penghapusan warna yang inkonsisten pada komponen (ex: tab warna ungu).
    - Penanganan constraint dan overflow error secara proaktif pada chart.
    - Memanfaatkan warna kontras tinggi (merah) untuk alert kritikal seperti stok rendah.

---

## 6. Alur Data (Data Flow)
1.  **Input:** Pengguna memasukkan transaksi lewat "Quick Sale" (Home) atau form (Stock).
2.  **Pemrosesan State:** Provider memvalidasi input, mengeksekusi operasi database (Insert/Update) melalui fungsi di SQLite Helper.
3.  **Sinkronisasi Real-Time:** Database lokal ter-update -> Provider memicu pembaruan state -> UI di-render ulang secara halus dan seketika.

---

## 7. Batasan Produk (Product Limitations)
Untuk menjaga fokus pengembangan dan efisiensi kinerja aplikasi pada rilis saat ini, ditetapkan beberapa batasan produk sebagai berikut:
1. **Penyimpanan Data Bersifat Lokal (Offline-First):** Seluruh data transaksi dan stok disimpan di memori internal perangkat menggunakan database SQLite. Aplikasi belum memiliki integrasi cloud, sehingga data akan hilang jika aplikasi dihapus atau perangkat mengalami kerusakan fisik.
2. **Operasional Perangkat Tunggal (Single-Device Only):** Aplikasi dirancang untuk digunakan pada satu perangkat saja. Belum mendukung sinkronisasi real-time antar-perangkat (multi-device) untuk pengguna/karyawan yang berbeda secara bersamaan.
3. **Absensi Autentikasi Pengguna (No User Authentication):** Aplikasi tidak dilengkapi dengan sistem login atau pembatasan hak akses (otorisasi). Siapa pun yang membuka aplikasi pada perangkat tersebut memiliki akses penuh ke seluruh fitur dan data keuangan.
4. **Skema Produk Spesifik (Niche-Specific):** Aplikasi ini didesain khusus dengan parameter penjualan kelapa serta produk sampingannya (batok, sabut/kulit, dsb). Tidak direkomendasikan untuk digunakan pada jenis usaha retail umum yang memiliki variasi barang dagangan dinamis di luar industri kelapa.
5. **Ketiadaan Integrasi Eksternal:** Aplikasi belum terintegrasi dengan sistem pembayaran digital (E-wallet/QRIS) maupun printer cetak struk kasir secara langsung.

---

## 8. Saran Pengembangan (Future Development Suggestions)
Berdasarkan batasan produk saat ini, berikut adalah beberapa poin saran yang direkomendasikan untuk pengembangan sistem di masa mendatang:
1. **Migrasi ke Cloud Database (Multi-Device Sync):** Mengintegrasikan sistem dengan database berbasis cloud (seperti Firebase Firestore, Supabase, atau PostgreSQL) agar data tersimpan aman di cloud dan memungkinkan sinkronisasi data antar-perangkat secara real-time untuk pemilik dan karyawan.
2. **Implementasi Autentikasi Keamanan:** Menambahkan fitur otentikasi login pengguna (menggunakan Email/Password, OTP, atau Google Sign-In) serta pembagian peran (Role-Based Access Control) antara Pemilik Toko (Owner) dan Karyawan (Staff).
3. **Ekspor Laporan Keuangan Secara Formal:** Menyediakan fitur untuk mengekspor riwayat transaksi harian, mingguan, dan laporan laba-rugi bulanan ke dalam format PDF atau spreadsheet Excel (.xlsx / .csv) guna mempermudah pelaporan eksternal atau arsip bisnis.
4. **Integrasi Gerbang Pembayaran (Payment Gateway) & Printer Struk:** Menyediakan metode transaksi QRIS/E-Wallet otomatis di dalam aplikasi dan mendukung pencetakan struk fisik menggunakan koneksi Printer Bluetooth Thermal.
5. **Fitur Analisis Prediktif Berbasis Kecerdasan Buatan (AI/ML):** Mengembangkan algoritma prediksi berbasis data historis transaksi untuk memproyeksikan kebutuhan stok kelapa di masa mendatang (*inventory forecasting*) guna menghindari penumpukan atau kekurangan stok menjelang musim puncak (*peak season*).

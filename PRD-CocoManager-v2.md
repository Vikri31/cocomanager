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

## 6. Alur Data (Data Flow)
1.  **Input:** Pengguna memasukkan transaksi lewat "Quick Sale" (Home) atau form (Stock).
2.  **Pemrosesan State:** Provider memvalidasi input, mengeksekusi operasi database (Insert/Update) melalui fungsi di SQLite Helper.
3.  **Sinkronisasi Real-Time:** Database lokal ter-update -> Provider memicu pembaruan state -> UI di-render ulang secara halus dan seketika.

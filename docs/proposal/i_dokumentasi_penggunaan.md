# i. Dokumentasi Cara Penggunaan Perangkat Lunak

---

## i.1 Instalasi Sistem

### i.1.1 Prasyarat Perangkat Keras

Sebelum melakukan instalasi, pastikan perangkat memenuhi spesifikasi minimum berikut:

| Komponen | Spesifikasi Minimum |
|----------|---------------------|
| Sistem Operasi | Android 5.0 (API 21) / iOS 13.0 |
| Prosesor | Octa-core 1,8 GHz (ARM Cortex-A53 atau setara) |
| RAM | 2 GB |
| Penyimpanan | 150 MB ruang kosong |
| Kamera | Kamera depan dengan resolusi minimum 720p |
| Sensor | Giroskop (untuk orientasi kamera) |

Untuk performa inferensi AI yang optimal, sangat dianjurkan menggunakan perangkat dengan prosesor Snapdragon 665 atau lebih tinggi, maupun Helio G85 atau setara, yang memiliki dukungan akselerasi komputasi GPU untuk model *machine learning*.

### i.1.2 Instalasi melalui APK (Android)

Bagi pengguna akhir yang menerima berkas APK distribusi:

1. Unduh berkas `gerakpulih-v1.0.apk` ke perangkat Android.
2. Buka **Pengaturan** → **Keamanan** → Aktifkan opsi **"Instal dari sumber tidak dikenal"** (atau "Instal aplikasi tidak dikenal" pada Android 8.0 ke atas, diaktifkan per-aplikasi pada aplikasi manajer berkas yang digunakan).
3. Buka berkas APK melalui manajer berkas atau notifikasi unduhan.
4. Ketuk **"Instal"** dan tunggu proses selesai.
5. Setelah instalasi selesai, ketuk **"Buka"** untuk memulai aplikasi.

### i.1.3 Instalasi untuk Pengembang (dari Kode Sumber)

Panduan berikut ditujukan untuk pengembang yang ingin menjalankan atau memodifikasi aplikasi dari kode sumber:

**Langkah 1 — Persiapan Lingkungan**

Pastikan perangkat lunak berikut telah terpasang pada komputer pengembang:

```bash
# Ubuntu/Debian — Instalasi Flutter via Snap
sudo apt update && sudo apt install git openjdk-17-jdk -y
sudo snap install flutter --classic

# Verifikasi instalasi
flutter doctor
```

Pastikan semua item pada keluaran `flutter doctor` menunjukkan status `[✓]`. Masalah yang umum ditemui meliputi ketidaktersediaan Android SDK atau lisensi Android yang belum diterima, yang dapat diselesaikan dengan:

```bash
flutter doctor --android-licenses
```

**Langkah 2 — Kloning Repositori**

```bash
git clone https://github.com/Hesyitena/GerakPulih.git
cd GerakPulih/gerakpulih_flutter
```

**Langkah 3 — Instalasi Dependensi**

```bash
flutter pub get
```

Perintah ini akan mengunduh seluruh paket yang terdefinisi pada `pubspec.yaml` ke dalam direktori `.dart_tool/`. Pastikan koneksi internet tersedia saat menjalankan perintah ini.

**Langkah 4 — Menjalankan Aplikasi**

Hubungkan perangkat Android fisik atau jalankan emulator, kemudian:

```bash
# Verifikasi perangkat terdeteksi
flutter devices

# Jalankan aplikasi dalam mode debug
flutter run

# Atau tentukan perangkat target secara eksplisit
flutter run -d <device-id>
```

Untuk performa inferensi AI yang optimal, sangat dianjurkan menggunakan perangkat fisik daripada emulator, karena emulator tidak memiliki akselerasi hardware untuk model *machine learning* dan kamera fisik.

---

## i.2 Cara Akses Aplikasi

### i.2.1 Izin Aplikasi yang Diperlukan

Pada saat pertama kali dijalankan, sistem operasi akan meminta konfirmasi izin akses berikut:

| Izin | Tujuan | Wajib |
|------|--------|-------|
| `CAMERA` | Mengakses kamera untuk deteksi pose *real-time* | Ya |
| `RECORD_AUDIO` | Tidak digunakan; dinonaktifkan pada konfigurasi kamera | Tidak |

Izin kamera merupakan izin yang bersifat **wajib**. Jika pengguna menolak izin ini, fitur sesi latihan tidak akan dapat digunakan. Jika izin telah ditolak sebelumnya, pengguna dapat mengaktifkan ulang melalui **Pengaturan Sistem** → **Aplikasi** → **GerakPulih** → **Izin** → **Kamera** → **Izinkan**.

### i.2.2 Akses Pertama Kali

Saat aplikasi dibuka untuk pertama kalinya, pengguna akan menjalani alur berikut secara berurutan:

1. **Splash Screen**: Menampilkan identitas merek selama kurang lebih dua detik.
2. **Onboarding**: Tiga slide pengenalan fitur yang dapat digeser. Pengguna dapat mengetuk "Lewati" untuk melewatinya atau menyelesaikan semua slide lalu mengetuk "Mulai".
3. **Registrasi Profil**: Pengguna mengisi nama lengkap dan usia, lalu mengetuk "Masuk & Mulai".

Setelah registrasi selesai, aplikasi akan langsung membuka halaman **Beranda** pada setiap kali berikutnya tanpa perlu melewati alur onboarding kembali.

---

## i.3 Panduan Fitur Utama

### i.3.1 Memulai Sesi Latihan

Sesi latihan adalah fitur inti GerakPulih. Terdapat dua cara untuk memulai sesi:

**Cara 1 — Melalui Beranda**:
1. Buka tab **Beranda** (ikon rumah pada navigasi bawah).
2. Pada kartu "Target Hari Ini", ketuk tombol **"Mulai Latihan Sekarang"**.
3. Aplikasi akan langsung membuka sesi latihan untuk gerakan yang direkomendasikan.

**Cara 2 — Melalui Katalog Latihan**:
1. Buka tab **Latihan** (ikon aktivitas pada navigasi bawah).
2. Telusuri katalog atau gunakan kolom pencarian untuk menemukan latihan yang diinginkan.
3. Ketuk kartu latihan yang dipilih untuk membuka sesi.

**Prosedur dalam Sesi Latihan**:
1. Setelah layar kamera terbuka, **posisikan perangkat secara vertikal** pada ketinggian sejajar pinggang atau dada, menghadap ke arah pengguna (jarak ideal: 1,5–2 meter).
2. Pastikan **seluruh tubuh** terlihat dalam bingkai kamera.
3. Amati **kotak umpan balik** di bagian bawah layar:
   - **Hijau — "Posisi sudah benar! Pertahankan."**: Gerakan dilakukan dengan benar.
   - **Kuning — "Hampir benar, sedikit lagi!"**: Gerakan mendekati posisi yang benar.
   - **Merah — pesan koreksi spesifik**: Gerakan memerlukan perbaikan.
4. Ikuti instruksi audio yang diperdengarkan secara otomatis.
5. Amati **penghitung repetisi** di bagian tengah-bawah layar untuk memantau kemajuan.
6. Setelah target repetisi tercapai, sistem akan mengumumkan pencapaian melalui audio.
7. Ketuk tombol **"Stop"** atau **"Keluar"** untuk mengakhiri sesi. Data akan tersimpan secara otomatis.

### i.3.2 Mengelola Sesi yang Sedang Berjalan

| Kontrol | Fungsi |
|---------|--------|
| Tombol **Pause** (ikon jeda, besar, tengah) | Menjeda sesi sementara; deteksi pose dihentikan |
| Tombol **Play** (saat dijeda) | Melanjutkan sesi yang dijeda |
| Tombol **Suara** (ikon speaker, kanan) | Mengaktifkan atau menonaktifkan umpan balik audio |
| Tombol **Stop** (ikon merah, kiri) | Mengakhiri sesi dan menyimpan data |
| Tombol **Keluar** (kiri atas) | Setara dengan Stop; kembali ke halaman sebelumnya |

### i.3.3 Menelusuri Katalog Latihan

1. Buka tab **Latihan**.
2. Untuk menyaring berdasarkan kategori, ketuk chip filter yang tersedia (misalnya "Tubuh Atas" atau "Keseimbangan"). Chip "Semua" menampilkan seluruh latihan tanpa filter.
3. Untuk mencari latihan tertentu, ketuk kolom pencarian di bagian atas dan ketik nama latihan. Daftar akan diperbarui secara otomatis.
4. Ketuk kartu latihan mana pun untuk langsung memulai sesi.

### i.3.4 Memantau Riwayat dan Progres

1. Buka tab **Riwayat**.
2. **Grafik Aktivitas Mingguan** di bagian atas menampilkan jumlah sesi per hari selama 7 hari terakhir. Hari dengan aktivitas ditandai dengan batang berwarna hijau (hari-hari sebelumnya) atau biru (hari ini).
3. **Kartu Statistik** menampilkan total sesi yang telah diselesaikan dan *streak* hari berturut-turut.
4. **Daftar Sesi** di bawahnya menampilkan seluruh riwayat latihan secara kronologis terbalik (terbaru di atas), beserta detail nama latihan, jumlah repetisi, durasi, dan status penyelesaian.

### i.3.5 Membaca Panduan Gerakan

1. Buka tab **Panduan**.
2. Telusuri daftar gerakan yang tersedia.
3. Ketuk item gerakan untuk mengembangkan panel instruksi.
4. Baca instruksi langkah bernomor dengan seksama.
5. Ketuk tombol **"Mulai Latihan"** di dalam panel untuk langsung membuka sesi latihan gerakan tersebut.

### i.3.6 Mengubah Preferensi Aplikasi

1. Buka tab **Setelan**.
2. Untuk mengubah status umpan balik audio, geser *toggle* "Umpan Balik Suara". Status aktif ditandai dengan warna hijau.
3. Untuk mengubah profil pengguna, ketuk tombol **"Keluar / Ubah Profil"**. Tindakan ini akan menghapus data profil yang tersimpan dan mengembalikan aplikasi ke layar registrasi. **Catatan**: Riwayat sesi latihan tidak akan terhapus oleh tindakan ini.

---

## i.4 Skenario Penggunaan Tipikal

### Skenario 1: Rutinitas Pagi Hari (Pengguna Reguler)

> Ibu Sari (62 tahun, pasien pasca-stroke bulan ke-3) membuka GerakPulih setiap pagi setelah sarapan. Aplikasi langsung menampilkan Beranda dengan sapaan personal dan target latihan hari itu: "Angkat Bahu" (3 set, 10 repetisi). Ibu Sari meletakkan ponselnya bersandar di atas meja dan berdiri sejauh 1,5 meter. Ia mengetuk "Mulai Latihan Sekarang" dan mengikuti instruksi suara yang terdengar. Setelah 10 repetisi, sistem mengumumkan "Luar biasa! Target 10 repetisi tercapai!" dan Ibu Sari mengetuk "Stop". Riwayat sesi tersimpan otomatis, streak-nya bertambah menjadi 14 hari.

### Skenario 2: Eksplorasi Latihan Baru (Pengguna yang Ingin Variasi)

> Pak Hendra (55 tahun) ingin mencoba latihan untuk kaki yang belum pernah dilakukan sebelumnya. Ia membuka tab Latihan, mengetuk chip filter "Tubuh Bawah", dan menelusuri pilihan yang ada. Ia menemukan "Ekstensi Lutut", membaca deskripsinya di tab Panduan, lalu memulai sesi melalui tombol "Mulai Latihan" di halaman Panduan tersebut.

### Skenario 3: Peninjauan Progres Mingguan (Pengguna dan Pendamping)

> Setiap Minggu malam, putra Ibu Sari membantu ibunya membuka tab Riwayat. Mereka bersama-sama melihat grafik aktivitas mingguan dan menghitung berapa hari latihan telah dilakukan. Data ini juga dibagikan secara verbal kepada fisioterapis saat sesi kunjungan bulanan sebagai laporan kemajuan.

---

## i.5 Penanganan Error Umum

### E-01: Kamera Tidak Terdeteksi atau Gagal Dibuka

**Gejala**: Layar kamera menampilkan latar hitam atau aplikasi tidak responsif setelah memilih latihan.

**Penyebab yang Mungkin dan Solusi**:
1. **Izin kamera belum diberikan**: Buka **Pengaturan Sistem** → **Aplikasi** → **GerakPulih** → **Izin** → **Kamera** → pilih **"Izinkan"**. Kemudian buka kembali sesi latihan.
2. **Aplikasi kamera lain sedang aktif**: Tutup seluruh aplikasi yang menggunakan kamera (misalnya aplikasi video call), lalu coba kembali.
3. **Masalah perangkat keras**: Restart perangkat dan coba kembali.

### E-02: Pose Tidak Terdeteksi (Umpan Balik "Pastikan tubuh terlihat kamera")

**Gejala**: Overlay kerangka tidak muncul; teks umpan balik menunjukkan pesan error deteksi.

**Solusi**:
1. Pastikan **seluruh tubuh** dari kepala hingga lutut terlihat dalam bingkai kamera.
2. Pastikan **pencahayaan ruangan memadai**; hindari posisi dengan cahaya belakang (*backlight*) yang kuat.
3. Posisikan perangkat pada jarak **1,5 hingga 2,5 meter** dari pengguna.
4. Kenakan **pakaian yang kontras** dengan warna latar belakang untuk memudahkan deteksi.
5. Pastikan **latar belakang tidak terlalu ramai** atau memiliki pola yang kompleks.

### E-03: Umpan Balik Audio Tidak Terdengar

**Gejala**: Tidak ada suara instruksi yang keluar selama sesi latihan.

**Solusi**:
1. Pastikan **volume media** perangkat tidak dalam kondisi sunyi (*mute*) atau sangat rendah.
2. Pastikan opsi "Umpan Balik Suara" di tab **Setelan** dalam kondisi aktif (warna hijau).
3. Selama sesi latihan, pastikan ikon **Suara** pada kontrol bawah menampilkan ikon speaker aktif (bukan ikon *mute*). Jika tidak, ketuk tombol tersebut untuk mengaktifkannya kembali.
4. **Catatan**: Sistem menerapkan *cooldown* tujuh detik antar pesan audio untuk mencegah interupsi yang terlalu sering. Ini adalah perilaku normal, bukan error.

### E-04: Hitungan Repetisi Tidak Bertambah

**Gejala**: Pengguna telah melakukan gerakan sesuai instruksi, namun penghitung repetisi tidak bertambah.

**Solusi**:
1. Pastikan **gerakan dilakukan dalam rentang gerak yang cukup penuh**; gerakan yang terlalu kecil atau parsial mungkin tidak melewati ambang sudut yang ditetapkan.
2. Pastikan ketiga titik sendi yang relevan (misalnya bahu, siku, dan pergelangan tangan untuk latihan lengan) **terlihat jelas** oleh kamera tanpa terhalang pakaian atau objek lain.
3. Amati nilai sudut yang ditampilkan di penghitung; gerakan sudah dihitung ketika sudut melebihi nilai `upAngle` yang ditetapkan untuk latihan tersebut.
4. Coba **perlambat gerakan** agar sistem memiliki waktu yang cukup untuk mendeteksi perubahan sudut.

### E-05: Riwayat Sesi Tidak Tersimpan atau Hilang

**Gejala**: Sesi latihan yang baru diselesaikan tidak muncul di tab Riwayat.

**Penyebab yang Mungkin dan Solusi**:
1. **Sesi diakhiri secara paksa (force close)**: Data hanya tersimpan setelah tombol Stop atau Keluar ditekan secara normal. Jika aplikasi ditutup paksa di tengah sesi, data sesi tersebut tidak akan tersimpan. Pastikan selalu mengakhiri sesi melalui kontrol yang tersedia.
2. **Memori penyimpanan penuh**: Pastikan perangkat memiliki ruang penyimpanan internal yang tersedia. GerakPulih membutuhkan penyimpanan minimal untuk operasi normalnya.
3. **Batasan 100 entri**: Sistem secara otomatis mempertahankan hanya 100 sesi terbaru. Sesi-sesi lama di luar batas ini akan terhapus secara otomatis.

### E-06: Aplikasi Terasa Lambat atau Panas Berlebihan

**Gejala**: Sesi latihan berjalan dengan responsivitas yang rendah; perangkat terasa panas secara tidak normal.

**Solusi**:
1. Tutup seluruh aplikasi lain yang berjalan di latar belakang melalui menu *multitasking* perangkat.
2. Pastikan perangkat tidak dalam kondisi **pengisian daya** saat latihan, karena kondisi ini dapat meningkatkan panas perangkat secara signifikan.
3. Jika masalah berlanjut, restart perangkat sebelum memulai sesi latihan.
4. Perilaku ini adalah normal pada perangkat kelas bawah yang memproses inferensi *machine learning* secara intensif; pertimbangkan untuk menggunakan perangkat dengan spesifikasi yang lebih tinggi.

---

*Dokumen ini merupakan bagian dari proposal teknis GerakPulih untuk GEMASTIK 2026 — Divisi Pengembangan Perangkat Lunak.*

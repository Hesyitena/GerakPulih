# f. Analisis Kebutuhan dan Desain Solusi Perangkat Lunak

---

## f.1 Identifikasi Masalah

Stroke merupakan salah satu penyakit tidak menular dengan beban kesehatan tertinggi di Indonesia. Berdasarkan data Riset Kesehatan Dasar (Riskesdas) 2018, prevalensi stroke pada penduduk usia di atas 15 tahun mencapai 10,9 per 1.000 penduduk, menjadikannya penyebab kematian dan kecacatan nomor satu di tanah air. Pasien pasca-stroke pada umumnya mengalami defisit motorik yang memerlukan program rehabilitasi intensif dan berkelanjutan, di mana fisioterapi merupakan komponen esensial dalam proses pemulihan fungsi gerak.

Permasalahan mendasar yang dihadapi adalah kesenjangan antara kebutuhan terapi yang bersifat kontinyu dengan keterbatasan akses terhadap layanan fisioterapi konvensional. Sejumlah hambatan struktural teridentifikasi sebagai berikut:

1. **Keterbatasan aksesibilitas geografis**: Fasilitas fisioterapi yang memadai terkonsentrasi di pusat kota, sehingga pasien di daerah perdesaan atau terpencil mengalami kesulitan mengakses layanan secara rutin.
2. **Beban biaya rehabilitasi**: Sesi fisioterapi konvensional membutuhkan biaya yang tidak sedikit, sementara frekuensi terapi yang dianjurkan bagi pasien pasca-stroke dapat mencapai tiga hingga lima kali per minggu dalam jangka panjang.
3. **Ketergantungan pada tenaga terapis**: Program latihan mandiri di rumah kerap tidak terlaksana secara optimal karena pasien tidak memiliki mekanisme umpan balik yang memadai untuk menilai kebenaran gerakan yang dilakukan.
4. **Absennya pemantauan progres**: Tanpa sistem pencatatan yang sistematis, pasien maupun tenaga medis tidak dapat memantau perkembangan pemulihan secara objektif dan terukur dari waktu ke waktu.
5. **Rendahnya motivasi dan kepatuhan (adherence)**: Latihan mandiri yang dilakukan tanpa panduan interaktif cenderung mengurangi motivasi pasien, terutama kelompok lansia yang menjadi populasi dominan pasca-stroke.

---

## f.2 Kebutuhan Fungsional

| Kode | Kebutuhan Fungsional | Prioritas |
|------|----------------------|-----------|
| KF-01 | Sistem harus mampu mendeteksi pose tubuh pengguna secara *real-time* menggunakan kamera perangkat | Kritis |
| KF-02 | Sistem harus mampu menghitung sudut sendi tubuh yang relevan dan membandingkannya dengan nilai acuan gerakan yang benar | Kritis |
| KF-03 | Sistem harus menghitung dan mencatat jumlah repetisi yang berhasil diselesaikan oleh pengguna secara otomatis | Kritis |
| KF-04 | Sistem harus memberikan umpan balik audio berbahasa Indonesia secara *real-time* selama sesi latihan berlangsung | Tinggi |
| KF-05 | Sistem harus menampilkan umpan balik visual berupa overlay kerangka tubuh dan indikator warna pada layar kamera | Tinggi |
| KF-06 | Sistem harus menyediakan katalog program latihan yang dapat difilter berdasarkan kategori dan dicari berdasarkan nama | Tinggi |
| KF-07 | Sistem harus menyimpan dan menampilkan riwayat sesi latihan yang telah diselesaikan pengguna | Tinggi |
| KF-08 | Sistem harus menampilkan statistik progres latihan pada dasbor utama (streak harian, total sesi) | Sedang |
| KF-09 | Sistem harus menyediakan halaman panduan berisi instruksi langkah-demi-langkah untuk setiap gerakan latihan | Sedang |
| KF-10 | Sistem harus mendukung proses onboarding profil pengguna pada saat pertama kali digunakan | Sedang |
| KF-11 | Sistem harus menyediakan fitur pengaturan preferensi pengguna, termasuk aktivasi/nonaktivasi suara | Rendah |
| KF-12 | Sistem harus menampilkan visualisasi grafik aktivitas mingguan pada halaman riwayat | Rendah |

---

## f.3 Kebutuhan Non-Fungsional

### f.3.1 Performa
Deteksi pose harus menghasilkan latensi inferensi tidak lebih dari 100 milidetik per *frame* pada perangkat kelas menengah (setara Snapdragon 665 atau lebih tinggi). Frekuensi pemrosesan *frame* ditetapkan pada 12 *frame per second* (fps) untuk menyeimbangkan akurasi inferensi dengan konsumsi daya dan panas perangkat.

### f.3.2 Ketersediaan Luring (*Offline Availability*)
Seluruh fungsionalitas inti, termasuk deteksi pose, umpan balik, dan pencatatan sesi, harus dapat beroperasi tanpa koneksi internet. Hal ini merupakan persyaratan fundamental mengingat profil pengguna yang dapat berada di daerah dengan konektivitas terbatas.

### f.3.3 Privasi dan Keamanan Data
Data visual dari kamera tidak boleh dikirimkan ke server eksternal dalam bentuk apapun. Seluruh komputasi inferensi AI harus dilakukan secara lokal pada perangkat (*on-device processing*). Data profil pengguna dan riwayat sesi disimpan secara lokal menggunakan mekanisme penyimpanan yang terisolasi per-aplikasi.

### f.3.4 Aksesibilitas dan Kemudahan Penggunaan
Antarmuka pengguna harus dirancang dengan mempertimbangkan kelompok lansia sebagai pengguna utama, dengan ukuran tipografi yang terbaca, kontras warna yang memadai, serta elemen interaktif berukuran minimal 48×48 dp sesuai panduan aksesibilitas Material Design. Umpan balik audio menggunakan bahasa Indonesia natural dengan kecepatan bicara 0,8× (lebih lambat dari normal) agar mudah dipahami oleh pengguna lanjut usia.

### f.3.5 Portabilitas
Aplikasi harus dapat dijalankan pada sistem operasi Android minimal versi 5.0 (API Level 21) dan iOS minimal versi 13.0, mencakup mayoritas perangkat yang beredar di pasaran Indonesia.

### f.3.6 Keandalan (*Reliability*)
Sistem harus menangani kondisi posisi tubuh yang tidak terdeteksi dengan memberikan umpan balik yang informatif tanpa menyebabkan *crash* atau *error* yang tidak tertangani. Data sesi yang tersimpan tidak boleh hilang akibat penutupan mendadak aplikasi.

---

## f.4 Karakteristik Pengguna

### f.4.1 Pengguna Primer: Pasien Pasca-Stroke
- **Rentang usia**: Dominan antara 50–75 tahun, dengan sebaran pada kelompok dewasa muda akibat perubahan pola penyakit.
- **Kondisi fisik**: Memiliki keterbatasan mobilitas pada satu atau lebih anggota tubuh; koordinasi gerak yang belum pulih sepenuhnya.
- **Tingkat literasi digital**: Bervariasi dari rendah hingga menengah; umumnya akrab dengan penggunaan smartphone untuk komunikasi dasar.
- **Kebutuhan khusus**: Memerlukan antarmuka yang sederhana, instruksi yang jelas dan ringkas, serta respons sistem yang konsisten dan terprediksi.

### f.4.2 Pengguna Sekunder: Pendamping atau Anggota Keluarga
- **Peran**: Membantu proses konfigurasi awal aplikasi, mendampingi sesi latihan, dan memantau progres pemulihan pasien.
- **Tingkat literasi digital**: Menengah hingga tinggi.

### f.4.3 Pemangku Kepentingan Tersier: Tenaga Medis (Fisioterapis)
- **Peran**: Meresepkan atau merekomendasikan program latihan yang sesuai; memanfaatkan ringkasan progres dari aplikasi sebagai data pendukung evaluasi klinis pada iterasi pengembangan selanjutnya.

---

## f.5 Use Case Utama

### UC-01: Memulai Sesi Latihan Terbimbing AI
**Aktor**: Pengguna (Pasien)  
**Deskripsi**: Pengguna memilih gerakan latihan dari katalog, memposisikan diri di depan kamera, dan menjalankan sesi latihan. Sistem mendeteksi pose, memberikan umpan balik visual dan audio, menghitung repetisi, serta menyimpan hasil sesi secara otomatis.  
**Prekondisi**: Profil pengguna telah terdaftar; izin akses kamera telah diberikan.  
**Alur Utama**: Pilih latihan → Layar kamera aktif → Deteksi pose → Umpan balik → Hitung repetisi → Simpan sesi → Kembali ke beranda.

### UC-02: Menjelajahi Katalog Program Latihan
**Aktor**: Pengguna  
**Deskripsi**: Pengguna menelusuri daftar latihan yang tersedia, melakukan filter berdasarkan kategori (Tubuh Atas, Tubuh Bawah, dsb.), atau melakukan pencarian berdasarkan nama latihan.

### UC-03: Memantau Progres Pemulihan
**Aktor**: Pengguna / Pendamping  
**Deskripsi**: Pengguna mengakses halaman Riwayat untuk melihat daftar sesi latihan yang telah diselesaikan, visualisasi aktivitas mingguan, total sesi, dan streak keberhasilan.

### UC-04: Membaca Panduan Gerakan
**Aktor**: Pengguna / Pendamping  
**Deskripsi**: Pengguna mengakses halaman Panduan yang berisi instruksi teks dan ilustrasi langkah-demi-langkah untuk setiap gerakan latihan.

### UC-05: Konfigurasi Profil dan Preferensi
**Aktor**: Pengguna / Pendamping  
**Deskripsi**: Pengguna memasukkan nama dan usia pada proses onboarding; mengatur preferensi seperti aktivasi suara melalui halaman Setelan.

---

## f.6 Arsitektur Sistem

GerakPulih mengadopsi arsitektur **Offline-First Client-Server** yang memadukan keunggulan komputasi edge (*on-device AI inference*) dengan sentralisasi data berbasis cloud. Sistem ini dirancang untuk mendukung skenario penggunaan klinik (*B2B*) dan sinkronisasi data lintas-perangkat, tanpa mengorbankan privasi, ketersediaan luring, dan latensi rendah pada sisi pengguna (*mobile*).

Arsitektur terdiri dari dua komponen utama: **Aplikasi Mobile (Flutter)** dan **Backend Microservice (Golang)**.

```
┌────────────────────────────────────┐     HTTPS/REST
│   Aplikasi Mobile (Flutter)        │ ◄─────────────────►
│   [Berjalan penuh secara luring    │                    │
│    berbasis Edge-AI inference]     │         ┌──────────┴──────────────┐
└────────────────────────────────────┘         │  Backend — Golang        │
                                               │  ┌─────────────────────┐│
                                               │  │  REST API (Gin/Fiber)││
                                               │  │  Autentikasi (JWT)   ││
                                               │  │  Sinkronisasi Sesi   ││
                                               │  │  Analitik Progres    ││
                                               │  └─────────────────────┘│
                                               │  ┌─────────────────────┐│
                                               │  │  Database            ││
                                               │  │  (PostgreSQL)        ││
                                               │  └─────────────────────┘│
                                               └─────────────────────────┘
                                                          ▲
                                               ┌──────────┴──────────────┐
                                               │  Dashboard Web Terapis  │
                                               │  (Pemantauan Pasien)    │
                                               └─────────────────────────┘
```

Pendekatan ini mempertahankan prinsip *offline-first* pada aplikasi mobile — seluruh fungsionalitas deteksi pose, umpan balik, dan pencatatan sesi lokal beroperasi secara penuh tanpa koneksi. Backend Golang berperan sebagai lapisan sentralisasi dan sinkronisasi yang diaktifkan ketika koneksi internet tersedia (*eventual consistency*).

---

## f.7 Alur Sistem (*System Flow*)

### f.7.1 Alur Onboarding

```
[Aplikasi Dibuka]
      │
      ▼
[Cek StorageService.isOnboarded]
      │
  ┌───┴───────────────┐
[Sudah]            [Belum]
  │                   │
  ▼                   ▼
[HomeScreen]   [SplashScreen → Onboarding → Login → HomeScreen]
```

### f.7.2 Alur Sesi Latihan Aktif

```
[Pengguna Pilih Latihan]
         │
         ▼
[CameraScreen — Inisialisasi]
  ├─ availableCameras() → pilih kamera depan
  ├─ CameraController.initialize()
  └─ PoseDetector(mode: stream)
         │
         ▼
[startImageStream → _processFrame()]
  ├─ Frame throttling: 80ms (~12fps)
  ├─ buildInputImage() — YUV420 → InputImage
  └─ poseDetector.processImage()
         │
         ▼
[_analyzePose(pose)]
  ├─ Ekstraksi 3 landmark (jointA, jointB, jointC)
  ├─ Validasi likelihood ≥ 0.5
  ├─ computeAngle() → sudut sendi (°)
  ├─ Bandingkan dengan upAngle / downAngle
  ├─ updateFeedback() → {good | warning | bad}
  └─ RepCounter: 'down' → 'up' → increment reps
         │
         ▼
[Render UI secara Reaktif]
  ├─ CameraPreview + PosePainter (skeleton overlay)
  ├─ FeedbackBox (warna + teks dinamis)
  ├─ RepCounter (reps/target, sudut sendi)
  └─ TtsService.speak() — umpan balik audio
         │
         ▼
[_finishSession()]
  ├─ Hitung durasi (DateTime.now() - _startTime)
  ├─ Hitung skor (repsCompleted / targetReps)
  ├─ Buat objek Session dan serialisasi ke JSON
  └─ StorageService.saveSession() → Navigator.pop()
```

---

## f.8 Justifikasi Teknologi

### f.8.1 Flutter (Framework Utama)
Flutter dipilih sebagai *framework* utama karena kemampuannya mengkompilasi satu basis kode menjadi aplikasi *native* untuk platform Android dan iOS. Dibandingkan dengan pendekatan *hybrid* berbasis WebView (Ionic, Cordova), Flutter menghasilkan performa UI yang mendekati *native* melalui mesin render Skia/Impeller, yang krusial untuk tampilan kamera *real-time* dan animasi yang halus. Dart sebagai bahasa pemrogramannya mendukung pola asinkron yang diperlukan untuk pemrosesan *image stream* tanpa memblokir *UI thread*.

### f.8.2 Google ML Kit Pose Detection
ML Kit Pose Detection dipilih sebagai mesin AI utama atas dasar pertimbangan berikut:
- **On-device inference**: Model berjalan sepenuhnya pada perangkat tanpa transmisi data ke cloud, menjamin privasi pengguna dan ketersediaan luring.
- **Akurasi tinggi**: Model mampu mendeteksi 33 titik *landmark* tubuh dengan nilai *likelihood* (kepercayaan) untuk setiap titik, memungkinkan validasi kualitas deteksi secara programatik.
- **Mode stream**: Mendukung pemrosesan *image stream* secara berkesinambungan dari kamera, yang optimal untuk kasus penggunaan latihan *real-time*.
- **Tanpa biaya lisensi**: Tersedia sebagai bagian dari ekosistem Google ML Kit tanpa biaya penggunaan.

### f.8.3 Flutter TTS
Perpustakaan `flutter_tts` menyediakan antarmuka lintas-platform untuk mesin *text-to-speech* bawaan sistem operasi. Dukungan bahasa Indonesia (`id-ID`) dengan pilihan suara perempuan yang lebih ramah menjadikannya tepat untuk target pengguna lansia. Mekanisme *cooldown* tujuh detik diimplementasikan untuk mencegah interupsi audio yang terlalu sering.

### f.8.4 SharedPreferences
Untuk volume data yang dikelola (profil pengguna, maksimum 100 entri sesi), SharedPreferences dengan serialisasi JSON memberikan solusi penyimpanan lokal yang ringan tanpa memerlukan ketergantungan pada SQLite atau basis data *embedded* lainnya, sehingga menjaga ukuran distribusi aplikasi tetap minimal.

### f.8.5 Provider (State Management)
Paket `provider` digunakan sebagai solusi manajemen *state* yang proporsional dengan kompleksitas aplikasi saat ini. Dibandingkan solusi yang lebih kompleks seperti BLoC atau Riverpod, `provider` menawarkan kurva pembelajaran yang lebih rendah dan boilerplate yang minimal tanpa mengorbankan kemampuan reaktivitas UI.

### f.8.6 Golang — Lapisan Backend Microservice

Golang (Go) ditetapkan sebagai bahasa implementasi untuk komponen *backend* GerakPulih. Pemilihan Golang didasarkan atas sejumlah keunggulan teknis yang relevan dengan kebutuhan sistem:

- **Konkurensi berbasis goroutine**: Model konkurensi Go menggunakan *goroutines* dan *channels* memungkinkan penanganan ribuan koneksi HTTP secara bersamaan dengan konsumsi memori yang sangat rendah (setiap goroutine hanya mengalokasikan ±2 KB stack awal), dibandingkan dengan model *thread-per-request* pada bahasa lain.
- **Performa tinggi dengan latensi rendah**: Golang dikompilasi menjadi *native binary* tanpa *runtime* virtual machine, menghasilkan waktu respons API yang konsisten rendah — krusial untuk *endpoint* sinkronisasi data sesi yang dipanggil segera setelah pengguna menyelesaikan latihan.
- **Ekosistem HTTP yang matang**: *Framework* seperti **Gin** atau **Fiber** menyediakan *routing* dan *middleware* yang efisien dengan overhead minimal, cocok untuk kebutuhan RESTful API backend microservice.
- **Deployment ringan**: Golang menghasilkan *single binary* yang dapat dideploy langsung ke container Docker tanpa ketergantungan *runtime* eksternal, menyederhanakan proses *CI/CD* dan mengurangi ukuran *Docker image* secara signifikan.
- **Konsistensi dengan paradigma keamanan sistem**: *Type safety* yang ketat pada Golang meminimalkan kelas kesalahan yang umum terjadi pada layanan web (misalnya *null pointer dereference* dan *integer overflow*), mendukung model keamanan data medis yang dibutuhkan.

Dalam arsitektur sistem, Golang menyediakan *endpoint* berikut:

| Endpoint | Metode | Fungsi |
|----------|--------|--------|
| `/api/v1/auth/register` | POST | Registrasi akun pengguna |
| `/api/v1/auth/login` | POST | Autentikasi dan penerbitan JWT |
| `/api/v1/sessions/sync` | POST | Unggah batch riwayat sesi dari perangkat |
| `/api/v1/sessions` | GET | Ambil riwayat sesi dari server |
| `/api/v1/analytics/progress` | GET | Ringkasan progres untuk dashboard terapis |

---

*Dokumen ini merupakan bagian dari proposal teknis GerakPulih untuk GEMASTIK 2026 — Divisi Pengembangan Perangkat Lunak.*

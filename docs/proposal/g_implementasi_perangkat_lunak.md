# g. Implementasi Perangkat Lunak

---

## g.1 Metodologi Pengembangan

GerakPulih dikembangkan menggunakan metodologi **Agile Development** dengan pendekatan iteratif berbasis sprint mingguan. Mengingat konteks kompetisi yang memiliki tenggat waktu yang terstruktur, metodologi ini dikombinasikan dengan prinsip **Mobile-First Development** dan **Rapid Prototyping** untuk memungkinkan validasi desain dan fungsionalitas secara dini.

Siklus pengembangan dibagi ke dalam tiga fase utama:

**Fase 1 — Fondasi dan Arsitektur** (Sprint 1–2): Penetapan arsitektur sistem, pembuatan struktur direktori, konfigurasi dependensi, implementasi tema dan sistem desain, serta pengembangan layanan inti (StorageService, TtsService).

**Fase 2 — Implementasi Fitur Inti** (Sprint 3–5): Pengembangan modul deteksi pose (*CameraScreen*), integrasi Google ML Kit, implementasi algoritma analisis sudut sendi dan penghitungan repetisi, serta pengembangan antarmuka utama (Beranda, Latihan, Riwayat).

**Fase 3 — Penyempurnaan dan Pengujian** (Sprint 6–7): Penghalusan antarmuka pengguna, pengujian pada berbagai perangkat fisik, optimasi performa *frame processing*, dan penyelarasan desain untuk memenuhi standar aksesibilitas.

Seluruh kode sumber dikelola menggunakan sistem kendali versi **Git** dengan model percabangan sederhana (branch `main` untuk rilis stabil, branch fitur untuk pengembangan aktif).

---

## g.2 Struktur Modul

Basis kode GerakPulih diorganisasikan menggunakan struktur direktori berbasis fitur (*feature-based directory structure*) yang memisahkan tanggung jawab setiap komponen secara jelas:

```
lib/
├── main.dart                   # Titik masuk aplikasi; inisialisasi layanan
├── core/
│   ├── theme.dart              # Sistem desain: warna, tipografi, shadow, komponen
│   └── constants.dart          # Konstanta global: kunci storage, string statis
├── models/
│   ├── exercise.dart           # Model data: Exercise, PoseConfig
│   └── session.dart            # Model data: Session (dengan JSON serialization)
├── data/
│   └── exercises_data.dart     # Data statis: katalog latihan dan konfigurasi pose
├── services/
│   ├── storage_service.dart    # Singleton: manajemen SharedPreferences
│   └── tts_service.dart        # Singleton: manajemen Text-to-Speech
├── screens/
│   ├── splash_screen.dart      # Layar inisialisasi dan routing awal
│   ├── onboarding_screen.dart  # Alur pengenalan aplikasi (3 slide)
│   ├── login_screen.dart       # Registrasi profil pengguna
│   ├── home_screen.dart        # Shell navigasi utama (bottom nav)
│   ├── beranda_tab.dart        # Tab Beranda: dasbor dan target harian
│   ├── latihan_tab.dart        # Tab Latihan: katalog dan filter latihan
│   ├── riwayat_tab.dart        # Tab Riwayat: histori sesi dan statistik
│   ├── panduan_tab.dart        # Tab Panduan: instruksi tiap gerakan
│   ├── setelan_tab.dart        # Tab Setelan: profil dan preferensi
│   └── camera_screen.dart      # Layar latihan aktif: kamera + AI + HUD
└── widgets/
    ├── glass_card.dart         # Komponen kartu dengan efek glassmorphism
    ├── exercise_card.dart      # Kartu latihan dalam grid katalog
    └── pose_painter.dart       # CustomPainter untuk overlay skeleton
```

### Deskripsi Modul Kritis

**`camera_screen.dart`** adalah modul paling kompleks dalam sistem, berperan sebagai orkestrator seluruh proses deteksi pose dan umpan balik. Modul ini mengelola siklus hidup kamera, *image stream processing*, inferensi AI, pembaruan UI reaktif, dan persistensi data sesi.

**`pose_painter.dart`** mengimplementasikan `CustomPainter` Flutter untuk merender overlay kerangka tubuh (*skeleton*) secara langsung di atas pratinjau kamera. Proses ini memerlukan transformasi koordinat dari ruang piksel kamera ke ruang piksel layar, mempertimbangkan rasio aspek dan rotasi kamera.

**`storage_service.dart`** mengimplementasikan pola Singleton untuk memastikan satu titik akses tunggal ke lapisan persistensi, mencegah kondisi *race condition* pada operasi baca/tulis data sesi.

---

## g.3 Teknologi yang Digunakan

| Komponen | Teknologi | Versi | Justifikasi |
|----------|-----------|-------|-------------|
| Framework | Flutter | SDK ≥3.0.0 | Cross-platform native, performa UI tinggi |
| Bahasa | Dart | ≥3.0.0 | Null-safety, async/await, isolate |
| AI Engine | google_mlkit_pose_detection | ^0.11.0 | On-device, 33 landmark, stream mode |
| Kamera | camera | ^0.10.5+9 | Akses image stream YUV420 |
| Text-to-Speech | flutter_tts | ^4.0.2 | TTS bahasa Indonesia (id-ID) |
| Penyimpanan | shared_preferences | ^2.2.3 | Penyimpanan lokal ringan |
| Animasi | flutter_animate | ^4.5.0 | Animasi deklaratif berbasis chaining |
| Navigasi | go_router | ^13.2.0 | Navigasi deklaratif berbasis URL |
| State Management | provider | ^6.1.2 | Manajemen state reaktif proporsional |
| Tipografi | google_fonts | ^6.2.1 | Font Inter/Poppins dari Google Fonts |
| Target Platform | Android ≥5.0, iOS ≥13.0 | — | Cakupan perangkat pasar Indonesia |

---

## g.4 Alur Kerja Sistem

### g.4.1 Inisialisasi Aplikasi

Pada titik masuk `main()`, sistem melakukan inisialisasi berurutan (*sequential initialization*) sebelum merender antarmuka apapun:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();   // Buka SharedPreferences
  await TtsService.instance.init();        // Konfigurasi mesin TTS
  SystemChrome.setSystemUIOverlayStyle(…); // Konfigurasi UI sistem
  runApp(const GerakPulihApp());
}
```

Pendekatan *eager initialization* ini memastikan bahwa seluruh layanan siap digunakan sebelum widget pertama dirender, mencegah kondisi *null reference* pada akses layanan di lapisan UI.

### g.4.2 Pipeline Deteksi Pose

Pipeline deteksi pose pada `CameraScreen` terdiri dari empat tahap berurutan yang dieksekusi setiap siklus *frame*:

**Tahap 1 — Akuisisi Frame**: `CameraController` menghasilkan objek `CameraImage` dalam format YUV420 melalui *image stream*. Mekanisme *frame throttling* dengan ambang batas 80 milidetik memastikan hanya satu *frame* yang diproses setiap interval tersebut, mencegah antrean *frame* yang dapat menyebabkan konsumsi memori berlebihan.

**Tahap 2 — Praproses Frame**: Byte dari seluruh *plane* YUV420 (Y, U, V) digabungkan secara sekuensial ke dalam satu `WriteBuffer`. Objek `InputImageMetadata` kemudian dikonstruksi dengan parameter ukuran, rotasi (270°), format piksel, dan *bytes per row* yang tepat untuk memastikan ML Kit menerima data gambar dalam format yang valid.

**Tahap 3 — Inferensi Pose**: `PoseDetector.processImage()` mengembalikan daftar objek `Pose`, di mana setiap `Pose` berisi 33 objek `PoseLandmark` dengan koordinat `(x, y, z)` dan nilai `likelihood`. Sistem mengambil elemen pertama dari daftar tersebut untuk dianalisis lebih lanjut.

**Tahap 4 — Analisis dan Umpan Balik**: Tiga titik *landmark* yang relevan dengan latihan diekstraksi berdasarkan konfigurasi `PoseConfig` yang terdefinisi pada setiap objek `Exercise`. Sudut sendi dihitung menggunakan rumus *dot product* vektor:

```
θ = arccos( (BA⃗ · BC⃗) / (|BA⃗| × |BC⃗|) )
```

di mana B adalah titik vertex (sendi yang diukur, misalnya siku atau lutut), A dan C adalah titik-titik pada segmen tulang yang berdampingan. Nilai sudut kemudian dibandingkan dengan ambang batas `upAngle` dan `downAngle` yang terdefinisi per latihan untuk menentukan status umpan balik dan penghitungan repetisi.

### g.4.3 Mesin Penghitung Repetisi

Penghitungan repetisi diimplementasikan sebagai *finite state machine* (FSM) sederhana dengan dua status: `'down'` dan `'up'`. Transisi dari `'down'` ke `'up'` — yang terjadi ketika sudut melebihi 85% dari `upAngle` — menghasilkan inkrementasi `_reps` dan pemicuan haptic feedback serta respons audio. Transisi balik dari `'up'` ke `'down'` terjadi ketika sudut turun di bawah 120% dari `downAngle`. Desain FSM ini efektif mencegah penghitungan repetisi ganda yang dapat terjadi akibat fluktuasi kecil pada nilai sudut di sekitar ambang batas.

---

## g.5 Integrasi Sistem

### g.5.1 Integrasi Kamera dan ML Kit

Integrasi antara *plugin* kamera Flutter dan Google ML Kit memerlukan konversi format gambar yang hati-hati. Kamera Flutter menghasilkan frame dalam format YUV420 (juga dikenal sebagai YUV_420_888 pada Android), yang merupakan format yang diterima langsung oleh `InputImage` ML Kit. Konfigurasi rotasi 270 derajat ditetapkan untuk mengoreksi orientasi *frame* dari kamera depan perangkat Android, yang secara *default* menghasilkan gambar yang terputar.

### g.5.2 Integrasi Layanan TTS

`TtsService` diimplementasikan sebagai Singleton yang dapat diakses dari seluruh modul. Sistem ini menyediakan dua metode pemanggilan yang berbeda perilakunya:
- `speak(text)`: Menerapkan *cooldown* tujuh detik dan digunakan untuk umpan balik gerakan yang berulang, mencegah interupsi audio yang terlalu frekuens.
- `speakImmediate(text)`: Mengabaikan *cooldown* dan digunakan untuk pengumuman *milestone* (misalnya pencapaian target repetisi) yang memerlukan prioritas tinggi.

### g.5.3 Integrasi Persistensi Data

`StorageService` mengabstraksi operasi `SharedPreferences` di balik antarmuka yang bersih. Data sesi diorganisasikan sebagai *list* objek JSON yang diencode sebagai string tunggal, dengan mekanisme pemotongan otomatis pada entri ke-100 untuk mencegah pertumbuhan data yang tidak terbatas. Kunci-kunci penyimpanan didefinisikan sebagai konstanta statis di `AppStrings` untuk mencegah *typo* yang dapat menyebabkan kegagalan senyap (*silent failure*).

---

## g.6 Performa, Keamanan, dan Skalabilitas

### g.6.1 Optimasi Performa

**Frame Throttling**: Pembatasan pemrosesan frame pada interval 80 milidetik (~12fps) untuk inferensi ML secara signifikan mengurangi beban CPU dibandingkan pemrosesan setiap frame (yang dapat mencapai 30fps atau lebih). Nilai ini dipilih sebagai titik seimbang antara responsivitas deteksi dan efisiensi daya.

**`IndexedStack` untuk Navigasi Tab**: `HomeScreen` menggunakan `IndexedStack` alih-alih `PageView` untuk mempertahankan *state* setiap tab di memori tanpa me-*rebuild* widget setiap kali pengguna berpindah tab, menghindari overhead inisialisasi ulang yang berulang.

**`setState` yang Terlokalisasi**: Pemanggilan `setState()` dalam `CameraScreen` dibatasi hanya pada perubahan data yang benar-benar berdampak pada tampilan (pose, reps, feedback), bukan pada setiap *frame* yang masuk, untuk meminimalkan siklus *rebuild* UI yang tidak perlu.

**Flutter Animate**: Penggunaan pustaka `flutter_animate` untuk animasi masuk (fade, slide) pada elemen UI memanfaatkan *implicit animation* Flutter yang dioptimalkan pada lapisan komposisi GPU, tanpa memerlukan `AnimationController` eksplisit yang lebih berat.

### g.6.2 Keamanan

Model keamanan GerakPulih berpusat pada prinsip **privasi by design** (*privacy by design*):
- **Zero network transmission**: Tidak ada data pengguna — termasuk frame kamera, profil, maupun riwayat sesi — yang ditransmisikan melalui jaringan dalam kondisi apapun.
- **Isolasi penyimpanan**: Data aplikasi tersimpan dalam *sandbox* sistem operasi yang terisolasi, tidak dapat diakses oleh aplikasi lain tanpa akses *root* pada perangkat.
- **Tidak ada autentikasi berbasis server**: Sistem identitas pengguna bersifat lokal sepenuhnya, menghilangkan vektor serangan yang terkait dengan manajemen akun dan transmisi kredensial.

### g.6.3 Skalabilitas

Meskipun versi saat ini beroperasi secara mandiri tanpa *backend*, arsitektur sistem dirancang untuk mendukung evolusi bertahap:
- **Extensibilitas katalog latihan**: Penambahan gerakan baru hanya memerlukan penambahan entri `Exercise` baru pada `exercises_data.dart` dengan konfigurasi `PoseConfig` yang sesuai, tanpa perubahan pada logika deteksi inti.
- **Abstraksi layanan yang bersih**: `StorageService` dan `TtsService` dapat disubstitusi dengan implementasi berbasis *backend* (misalnya Firebase Firestore menggantikan SharedPreferences) tanpa mengubah logika di lapisan UI dan bisnis, berkat pola antarmuka yang terdefinisi dengan jelas.
- **Modularitas layar**: Setiap tab diimplementasikan sebagai `StatefulWidget` independen, memudahkan penambahan fitur baru (misalnya modul konsultasi dokter atau program latihan yang dipersonalisasi) sebagai tab tambahan tanpa mengganggu modul yang sudah ada.

---

*Dokumen ini merupakan bagian dari proposal teknis GerakPulih untuk GEMASTIK 2026 — Divisi Pengembangan Perangkat Lunak.*

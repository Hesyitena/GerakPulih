# GerakPulih — Asisten Fisioterapi Mandiri Pasca-Stroke

**GerakPulih** adalah aplikasi asisten fisioterapi berbasis mobile yang dirancang khusus untuk membantu pasien pasca-stroke dalam menjalani program latihan pemulihan secara mandiri di rumah. Menggunakan teknologi kecerdasan buatan (AI) terbaru, aplikasi ini memberikan bimbingan gerakan yang presisi dan interaktif.

## ✨ Fitur Utama

-   **🤖 Deteksi Pose Real-Time**: Menggunakan model AI berbasis *edge computing* yang melacak 33 titik sendi tubuh pasien secara langsung melalui kamera ponsel tanpa perangkat tambahan.
-   **🔊 Umpan Balik Audio (TTS)**: Memberikan instruksi suara secara *real-time* ("Angkat tangan sedikit lagi", "Bagus!", dll) menyerupai pendampingan terapis pribadi.
-   **📈 Pelacakan Progres Latihan**: Pencatatan otomatis histori latihan, durasi, dan jumlah repetisi untuk memantau kemajuan perkembangan fisik dari waktu ke waktu.
-   **📖 Panduan Interaktif**: Koleksi modul latihan yang disusun khusus untuk pemulihan motorik pasca-stroke dengan instruksi langkah-demi-langkah yang jelas.
-   **💎 Desain Glassmorphism**: Antarmuka pengguna yang premium, modern, dan mudah digunakan oleh lansia dengan tipografi yang jelas dan elemen visual yang menenangkan.

## 🛠️ Teknologi yang Digunakan

| Komponen | Teknologi |
| :--- | :--- |
| **Frontend Framework** | **Flutter** (Target: Android & iOS) |
| **Programming Language** | **Dart** |
| **AI Engine** | **Google ML Kit Pose Detection** |
| **Speech Engine** | **Flutter TTS** |
| **Local Storage** | **Shared Preferences** |
| **UI/UX Library** | Google Fonts, Flutter Animate, Glassmorphism Design |

## 🏗️ Arsitektur Sistem

Aplikasi ini menggunakan pendekatan **Edge Computing**, di mana seluruh perhitungan deteksi pose AI dilakukan langsung pada perangkat (*on-device*). Hal ini menjamin:
1.  **Low Latency**: Feedback diterima pengguna secara instan tanpa delay internet.
2.  **Privacy**: Data rekaman kamera tidak pernah dikirim ke server pusat.
3.  **Offline Capability**: Pasien dapat tetap berlatih meskipun tanpa koneksi internet.

## 🚀 Memulai (Lokal)

1. **Prasyarat**
   - Flutter SDK (v3.0.0+)
   - Android Studio / VS Code
   - Perangkat Android fisik (disarankan untuk performa ML optimal)

2. **Clone Repository**
   ```bash
   git clone https://github.com/Hesyitena/GerakPulih.git
   cd gerakpulih_flutter
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Jalankan Aplikasi**
   ```bash
   flutter run
   ```

---

*Proyek ini dikembangkan untuk partisipasi dalam **GEMASTIK 2026** (Gelaran Mahasiswa Nasional bidang Teknologi Informasi dan Komunikasi).*

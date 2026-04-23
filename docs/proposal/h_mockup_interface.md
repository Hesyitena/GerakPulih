# h. Mockup Interface Perangkat Lunak (Konseptual)

---

## h.1 Prinsip Desain Antarmuka

Antarmuka GerakPulih dirancang berdasarkan tiga pilar utama yang saling melengkapi:

1. **Aksesibilitas untuk Lansia**: Ukuran tipografi minimum 14sp untuk teks konten dan 24sp untuk judul; elemen interaktif berukuran minimal 48×48 dp; kontras warna yang memenuhi standar WCAG AA (rasio kontras ≥ 4,5:1 untuk teks normal).
2. **Glassmorphism Modern**: Penggunaan efek *frosted glass* (blur + transparansi) pada komponen kartu untuk menciptakan hierarki visual yang elegan tanpa kehilangan keterbacaan konten.
3. **Bahasa Visual yang Menenangkan**: Palet warna didominasi oleh hijau toska (`#0DC98C`) sebagai warna primer yang memberi kesan kesehatan dan pemulihan, dikombinasikan dengan biru lembut sebagai aksen, pada latar belakang yang terang dan bersih.

**Palet Warna Utama**:

| Peran | Nama Token | Nilai HEX | Keterangan |
|-------|-----------|-----------|------------|
| Primary | `AppTheme.primary` | `#0DC98C` | Hijau toska — identitas utama |
| Primary Dark | `AppTheme.primaryDark` | `#057A55` | Untuk teks di atas latar primer |
| Secondary | `AppTheme.secondary` | `#5B8AF0` | Biru — aktivitas hari ini |
| Background | `AppTheme.bgColor` | `#F4F7FA` | Abu-abu terang — latar halaman |
| Pose Good | `AppTheme.poseGood` | `#22C55E` | Indikator posisi benar |
| Pose Warn | `AppTheme.poseWarn` | `#F59E0B` | Indikator posisi hampir benar |
| Pose Bad | `AppTheme.poseBad` | `#EF4444` | Indikator posisi salah |

---

## h.2 Daftar Halaman Aplikasi

| No | Nama Layar | Deskripsi Singkat |
|----|------------|-------------------|
| H-01 | Splash Screen | Layar pembuka dengan animasi logo |
| H-02 | Onboarding Screen | Pengenalan fitur aplikasi (3 slide) |
| H-03 | Login / Registrasi Profil | Pengisian data diri pengguna |
| H-04 | Beranda (Home Tab) | Dasbor utama: salam, statistik, target harian |
| H-05 | Latihan (Exercise Tab) | Katalog latihan dengan filter dan pencarian |
| H-06 | Sesi Latihan Aktif (Camera) | Layar kamera + overlay AI + kontrol sesi |
| H-07 | Riwayat (History Tab) | Grafik mingguan, statistik, daftar sesi |
| H-08 | Panduan (Guide Tab) | Instruksi langkah-demi-langkah tiap gerakan |
| H-09 | Setelan (Settings Tab) | Profil pengguna dan preferensi aplikasi |

---

## h.3 Deskripsi Tiap Tampilan

### H-01: Splash Screen

**Tujuan**: Memberikan identitas merek yang kuat saat pertama kali aplikasi dibuka, sekaligus menjalankan proses pengecekan status onboarding di latar belakang.

**Elemen UI Utama**:
- Logo GerakPulih (ikon fisioterapi + tipografi bold) di tengah layar dengan latar gradien hijau-biru.
- Animasi *fade-in* dan *scale-up* pada logo (durasi 600ms).
- Tidak terdapat elemen interaktif; navigasi dilakukan secara otomatis setelah pengecekan status selesai.

**Alur Interaksi**: Otomatis menavigasi ke OnboardingScreen (pengguna baru) atau HomeScreen (pengguna terdaftar) setelah 2 detik.

---

### H-02: Onboarding Screen

**Tujuan**: Memperkenalkan tiga fitur unggulan aplikasi kepada pengguna baru melalui tampilan *carousel* yang intuitif.

**Elemen UI Utama**:
- Tiga slide dengan ilustrasi ikon besar, judul (24sp bold), dan deskripsi (14sp regular).
- **Slide 1**: Deteksi Pose AI — "Kamera pintar yang membimbing gerakan Anda secara real-time."
- **Slide 2**: Umpan Balik Audio — "Instruksi suara berbahasa Indonesia seperti terapis pribadi."
- **Slide 3**: Pantau Progres — "Catat setiap latihan dan lihat kemajuan pemulihan Anda."
- *Page indicator* berupa titik di bagian bawah slide.
- Tombol "Mulai" (CTA) di slide terakhir, dengan opsi "Lewati" di slide awal.

**Alur Interaksi**: Geser horizontal untuk berpindah slide; ketuk "Mulai" untuk melanjutkan ke LoginScreen.

---

### H-03: Login / Registrasi Profil

**Tujuan**: Mengumpulkan informasi profil dasar pengguna (nama dan usia) untuk personalisasi sapaan di dasbor.

**Elemen UI Utama**:
- Header bergradien dengan ikon orang dan teks "Halo! Mari kenalan dulu."
- Dua field input dengan label melayang (*floating label*): **Nama Lengkap** dan **Usia**.
- Validasi *real-time* (field kosong menampilkan pesan error inline).
- Tombol primer "Masuk & Mulai" berukuran penuh (full-width), dinonaktifkan selama field belum terisi dengan benar.
- Desain menggunakan kartu glassmorphism di atas latar bergradien.

**Alur Interaksi**: Isi nama dan usia → Ketuk "Masuk & Mulai" → StorageService menyimpan profil → Navigasi ke HomeScreen.

---

### H-04: Beranda (Home Tab)

**Tujuan**: Halaman utama yang menyambut pengguna, menampilkan statistik progres, dan memudahkan akses cepat ke sesi latihan.

**Elemen UI Utama**:
- **Hero Header Bergradien** (hijau toska → biru): Sapaan personal ("Halo, Budi! 👋"), subtitle motivasi, dan dua chip statistik (*Streak* dan *Total Sesi*).
- **Kartu Target Harian** (glassmorphism): Menampilkan nama latihan yang direkomendasikan, detail set/repetisi, dan tombol CTA "Mulai Latihan Sekarang" berwarna hijau.
- **Bagian Program Latihan**: Daftar tiga latihan unggulan dalam format baris (ikon berwarna, nama, detail, chevron).
- **Kartu Sesi Terakhir**: Menampilkan ringkasan sesi paling baru (jika ada) dengan badge status "Selesai" atau "Belum".
- **Bottom Navigation Bar Glassmorphism**: Bar navigasi mengambang dengan efek blur, menampilkan 5 tab dengan indikator aktif berbentuk *pill*.

**Alur Interaksi**: Ketuk kartu latihan atau tombol CTA → Navigasi ke CameraScreen dengan latihan terpilih.

---

### H-05: Latihan (Exercise Tab)

**Tujuan**: Menampilkan katalog lengkap program latihan fisioterapi yang tersedia, dengan kemampuan filter dan pencarian.

**Elemen UI Utama**:
- **Header**: Judul "Program Latihan" dan subjudul deskriptif.
- **Search Bar** (glassmorphism): Kolom pencarian dengan ikon kaca pembesar, *real-time filtering* saat pengguna mengetik.
- **Filter Kategori** (horizontal scrollable chips): Pilihan "Semua", "Tubuh Atas", "Tubuh Bawah", "Keseimbangan", dsb. Chip aktif berwarna hijau primer.
- **Grid Kartu Latihan** (2 kolom): Setiap kartu menampilkan:
  - Ikon gerakan di atas blok warna bertema.
  - Nama latihan (bold).
  - Bagian tubuh yang dilatih.
  - Badge tingkat kesulitan (Pemula / Menengah).
  - Detail set dan repetisi.
- Animasi masuk bertahap (*staggered animation*) pada kartu saat halaman dimuat.

**Alur Interaksi**: Ketuk chip kategori untuk filter → Ketik di search bar untuk cari → Ketuk kartu latihan → Navigasi ke CameraScreen.

---

### H-06: Sesi Latihan Aktif (Camera Screen)

**Tujuan**: Layar utama sesi latihan yang menampilkan pratinjau kamera, overlay deteksi pose, umpan balik *real-time*, dan kontrol sesi.

**Elemen UI Utama**:

**Layer 1 — Pratinjau Kamera**:
- `CameraPreview` penuh layar (rasio aspek 9:16 untuk kamera depan).
- `CustomPaint` overlay yang merender kerangka tubuh (*skeleton*) berupa titik-titik (*landmark*) dan garis penghubung antar sendi dengan warna dinamis sesuai status umpan balik.

**Layer 2 — HUD Atas**:
- Tombol "Keluar" (glassmorphism, pojok kiri atas): memicu `_finishSession()`.
- Badge nama latihan (glassmorphism, pojok kanan atas).

**Layer 3 — Indikator Tengah-Bawah**:
- **Kotak Umpan Balik** (pill berwarna dinamis): Menampilkan teks instruksi yang berubah sesuai status pose. Warna hijau untuk posisi benar, kuning untuk hampir benar, merah untuk posisi salah.
- **Penghitung Repetisi** (glassmorphism card): Menampilkan `reps / target` dalam tipografi besar (40sp), label "REPETISI", dan nilai sudut sendi saat ini dalam derajat.

**Layer 4 — Kontrol Bawah**:
- Gradien hitam dari bawah untuk meningkatkan keterbacaan.
- Tiga kontrol dalam tata letak horizontal:
  - Tombol **Stop** (ikon merah, bulat): mengakhiri sesi.
  - Tombol **Pause/Play** utama (besar, bulat, hijau primer): menjeda atau melanjutkan sesi.
  - Tombol **Suara** (toggle mute/unmute): mengaktifkan/menonaktifkan umpan balik audio.

**Alur Interaksi**: Pengguna memposisikan diri → AI mendeteksi pose dan memberikan umpan balik → Pengguna melakukan gerakan → Rep counter bertambah → Ketuk Stop/Keluar → Sesi tersimpan → Kembali ke Home.

---

### H-07: Riwayat (History Tab)

**Tujuan**: Memberikan gambaran menyeluruh tentang progres latihan pengguna dari waktu ke waktu.

**Elemen UI Utama**:
- **Grafik Batang Aktivitas Mingguan** (dalam kartu glassmorphism): Tujuh batang mewakili 7 hari terakhir, tinggi batang proporsional dengan jumlah sesi per hari. Hari ini ditandai dengan warna biru.
- **Dua Kartu Statistik** (berdampingan): "Total Sesi" dan "Streak Hari" dengan nilai numerik besar dan ikon relevan.
- **Daftar Semua Sesi** (scrollable list): Setiap item menampilkan:
  - Kolom tanggal (hari dan bulan dalam format ringkas).
  - Garis pemisah vertikal.
  - Nama latihan (bold) dan detail (reps/target, durasi).
  - Badge status "Selesai" (hijau) atau "Belum" (kuning).
- Animasi masuk bertahap (*staggered slide-in*) pada setiap item sesi.
- Tampilan kosong (*empty state*) dengan ikon dan teks ajakan jika belum ada riwayat.

---

### H-08: Panduan (Guide Tab)

**Tujuan**: Menyediakan referensi instruksi gerakan yang dapat dibaca sebelum atau sesudah sesi latihan.

**Elemen UI Utama**:
- **Daftar Panduan** yang dapat discroll, setiap item dapat dikembangkan (*expandable*).
- Setiap entri panduan menampilkan nama gerakan, ikon kategori, dan indikator tingkat kesulitan.
- Saat dikembangkan, menampilkan:
  - Instruksi langkah bernomor (1, 2, 3, ...) dengan tipografi yang jelas.
  - Informasi bagian tubuh yang dilatih dan manfaat klinis.
  - Tombol "Mulai Latihan" yang langsung membuka CameraScreen.

---

### H-09: Setelan (Settings Tab)

**Tujuan**: Mengelola profil pengguna dan preferensi aplikasi.

**Elemen UI Utama**:
- **Kartu Profil** di bagian atas: Avatar inisial berwarna, nama pengguna (bold, besar), usia.
- **Bagian Preferensi Aplikasi**: Toggle untuk umpan balik audio (Aktif/Nonaktif).
- **Bagian Informasi**: Versi aplikasi, tautan tentang aplikasi, informasi hak cipta.
- **Tombol "Keluar / Ubah Profil"** (teks merah) untuk menghapus data profil dan kembali ke layar login.

---

## h.4 Alur Interaksi Pengguna (User Journey)

Berikut adalah alur interaksi menyeluruh pengguna dari pertama kali membuka aplikasi hingga menyelesaikan sesi latihan pertama:

```
[Buka Aplikasi]
      │
      ▼
[Splash Screen — 2 detik]
      │
      ▼
[Onboarding — 3 slide, geser horizontal]
      │ Ketuk "Mulai"
      ▼
[Registrasi Profil — isi nama & usia]
      │ Ketuk "Masuk & Mulai"
      ▼
[Beranda — lihat target harian]
      │ Ketuk "Mulai Latihan Sekarang"
      ▼
[Camera Screen — izin kamera diberikan]
      │
      ▼
[Posisikan diri — ikuti instruksi audio/visual]
      │
      ▼
[Lakukan repetisi — lihat counter bertambah]
      │ Target tercapai / Ketuk Stop
      ▼
[Sesi tersimpan otomatis]
      │
      ▼
[Kembali ke Beranda — streak bertambah]
      │
      ▼
[Buka Riwayat — lihat grafik aktivitas]
```

---

*Dokumen ini merupakan bagian dari proposal teknis GerakPulih untuk GEMASTIK 2026 — Divisi Pengembangan Perangkat Lunak.*

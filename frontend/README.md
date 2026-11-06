# English Day · SMAN 10 Gowa (Mobile EduTech App)

Implementasi Frontend Flutter lengkap untuk aplikasi pembelajaran bahasa Inggris **English Day** SMAN 10 Gowa, dislicing secara presisi 1:1 dari 58 desain visual pada folder `UI Design - Mobile EduTech App`.

Seluruh fungsionalitas menggunakan data dummy interaktif tanpa backend.

---

## 📱 Daftar Modul & Layar (58 State Desain)

Aplikasi mencakup seluruh state visual yang dirancang dalam folder desain:

### 1. Akun & Otentikasi
- **Splash Screen** (`Akun · splash.png`) — Tampilan awal branding English Day SMAN 10 Gowa.
- **Login** (`Akun · login.png`) — Form masuk (email & password dengan toggle show/hide).
- **Login Loading** (`Akun · login-loading.png`) — State tombol `Masuk…` dengan progress indicator.
- **Login Error** (`Akun · login-error.png`) — Banner peringatan `Email atau password salah` + tombol `Coba lagi`.
- **Register** (`Akun · register.png`) — Form pendaftaran akun, pilihan peran (Siswa / Guru).
- **Register Error** (`Akun · register-error.png`) — Validasi field (nama wajib diisi, format email, password min. 8 karakter, konfirmasi password tidak cocok).

### 2. Dashboard
- **Dashboard - Lanjutkan Latihan** (`Dashboard · lanjutkan latihan.png`) — Header sapaan personal `Halo, Rina`, avatar inisial `RA`, card resume latihan terakhir (`Reading · The Lost Kite`), dan 4 menu modul latihan.
- **Dashboard - Pengguna Baru** (`Dashboard · pengguna baru.png`) — Tampilan dashboard awal tanpa kartu resume latihan.

### 3. Writing (Latihan Menulis)
- **Input Kosong** (`Writing · input empty.png`) — Kertas bergaris (lined paper) untuk menulis kalimat/paragraf dengan counter karakter `0/500`.
- **Input Terisi** (`Writing · input filled.png`) — Input berisi contoh kalimat bahasa Inggris.
- **Input Loading** (`Writing · input loading.png`) — Tombol `Mengecek…` aktif dengan teks tersimpan info.
- **Input Lambat / AI Slow** (`Writing · input slow.png`) — Banner oranye: *"Masih memproses. Kamu bisa menunggu atau batalkan."*
- **Input Timeout / Error** (`Writing · input error.png`) — Banner merah: *"AI belum merespons. Coba lagi dalam beberapa saat."*
- **Input Limit Karakter** (`Writing · input limit.png`) — Peringatan melebihi batas 500 karakter (`Kurangi X karakter agar bisa dicek`).
- **Hasil Loading** (`Writing · hasil loading.png`) — Efek shimmer / skeleton paragraf saat menyiapkan koreksi.
- **Hasil Koreksi** (`Writing · hasil corrections.png`) — Teks bergaris dengan kata salah dicoret merah dan kata perbaikan di atasnya, serta versi perbaikan bersih.
- **Penjelasan Aturan Tata Bahasa** (`Writing · hasil sheet.png`) — Bottom sheet detail aturan (contoh: *Bentuk lampau / past tense*).
- **Hasil Kalimat Benar** (`Writing · hasil correct.png`) — Tampilan sukses ketika tidak ada kesalahan grammar.

### 4. Reading (Latihan Membaca)
- **Pengaturan Reading** (`Reading · pengaturan.png`) — Pemilihan level kesulitan (Easy A2, Medium B1, Hard B2) dan topik (Sekolah, Olahraga, Teknologi, Budaya, Alam, Acak).
- **Cerita Loading** (`Reading · cerita loading.png`) — Shimmer / skeleton pembentukan cerita oleh AI.
- **Cerita Slow & Error** (`Reading · cerita slow.png`, `Reading · cerita error.png`) — State lambat dan timeout pembuatan cerita.
- **Tampilan Cerita** (`Reading · cerita story.png`, `Reading · cerita continuation.png`) — Cerita pendek bergaya tipografi serif dengan highlight stabilo kuning pada kosakata kunci.
- **Kosakata Sheet** (`Reading · cerita sheet.png`) — Modal bottom sheet penjelasan arti dan contoh kalimat kata yang distabilo.
- **Kuis Reading** (`Reading · kuis empty.png`, `selected`, `correct`, `wrong`) — 5 soal pilihan ganda interaktif dengan indikator progres dan feedback pembahasan instan.
- **Hasil Kuis** (`Reading · kuis result.png`) — Skor akhir dengan badge stabilo kuning, ringkasan dan review pembahasan per soal.

### 5. Speaking (Latihan Berbicara)
- **Izin Mikrofon** (`Izin mikrofon · permintaan.png`, `ditolak permanen.png`) — Layar persetujuan akses mikrofon dan penanganan izin ditolak permanen.
- **Percakapan Speaking** (`Speaking · empty.png`, `idle.png`) — Bubble obrolan dua arah dengan tombol audio AI.
- **Merekam Suara** (`Speaking · recording.png`) — Animasi sound wave, tombol stop, dan live transcription ucapan pengguna.
- **Memproses & AI Berbicara** (`Speaking · processing.png`, `speaking.png`) — State AI menganalisis dan merespons audio.
- **Slow & Error** (`Speaking · slow.png`, `error.png`) — Notifikasi koneksi lambat dan deteksi suara tidak terdengar jelas.

### 6. Listening (Latihan Menyimak)
- **Intro** (`Listening · empty.png`) — Halaman pembuka latihan audio listening.
- **Loading & Slow** (`Listening · loading.png`, `slow.png`) — Penyiapan streaming audio.
- **Audio Player Interaktif** (`Listening · playing.png`) — Play/pause audio player, scrubber progres, replay, dan pengatur kecepatan playback (0.75x, 1x).
- **Pertanyaan & State Terkunci** (`Listening · questions.png`, `locked.png`) — Soal pemahaman listening dengan transkrip terkunci sebelum dijawab.
- **Error Audio** (`Listening · error.png`) — Penanganan kegagalan koneksi audio.
- **Hasil & Review** (`Listening · result.png`, `review.png`) — Skor latihan dan evaluasi benar/salah setiap nomor.
- **Transkrip Terbuka** (`Listening · transcript.png`) — Transkrip lengkap percakapan dengan kalimat bukti kunci distabilo.

### 7. Profil & Fitur Global
- **Profil Pengguna** (`Profil.png`) — Data profil dummy (Rina Amelia, Siswa, SMAN 10 Gowa), menu ubah nama, ubah password, dan tentang aplikasi.
- **Konfirmasi Keluar** (`Profil · konfirmasi keluar.png`) — Bottom sheet dialog konfirmasi logout.
- **Offline Mode** (`Global · offline.png`) — Layar peringatan tidak ada koneksi internet + tombol coba lagi.
- **Banner Status AI** (`Global · banner AI.png`) — Demonstrasi variasi banner status AI global.
- **Sesi Habis** (`Global · sesi habis.png`) — Bottom sheet pemberitahuan sesi berakhir.
- **Notifikasi Teks Disalin** (`Global · teks disalin.png`) — Floating snackbar konfirmasi copy text.
- **Showcase Komponen UI** (`Komponen · tombol.png`, `input dan pilihan.png`, `jawaban dan percakapan.png`) — Katalog komponen desain sistem token.

---

## 🎨 Galeri Desain UI (Interactive Showcase)

Untuk mempermudah verifikasi dan review slicing 1:1 terhadap seluruh 58 file gambar desain:
1. Buka aplikasi dan masuk ke menu **Profil** (avatar di pojok kanan atas Dashboard).
2. Pilih menu **Tentang aplikasi**.
3. Di dalam halaman ini terdapat **Galeri UI (58 layar)** yang dikelompokkan rapi berdasarkan kategori. Anda dapat mengklik setiap item untuk membuka layar dan state persis seperti mockup Figma / PNG.

---

## 🚀 Cara Menjalankan

Pastikan Flutter SDK sudah terpasang:

```bash
# Masuk ke direktori project
cd D:\OPENCODE3\FE-Compro\english_day

# Ambil dependencies
flutter pub get

# Jalankan di Chrome (Web) atau Emulator Android/iOS / Windows desktop
flutter run -d chrome
# atau
flutter run -d windows
# atau
flutter run
```

---

## 📁 Struktur Kode

```
lib/
├── main.dart                          # Inisialisasi aplikasi & konfigurasi tema
├── data/
│   └── dummy_data.dart                # Seluruh data dummy (user, reading, listening, writing, speaking)
├── theme/
│   └── app_theme.dart                 # Design tokens (AppColors, AppText/GoogleFonts, AppTheme)
├── widgets/
│   ├── answer_widgets.dart            # AnswerOption, AnswerFeedback, ChatBubble, SoundWave
│   ├── app_button.dart                # AppButton (primary, secondary, danger, loading), AppTextAction
│   ├── app_text_field.dart            # AppTextField, FieldError, AppChoiceChip
│   ├── common.dart                    # AppScaffold, BottomActionBar, AppCard, StatusBanner, Skeleton, InfoStateView
│   └── lined_paper.dart               # LinedPaper, LinedText, CorrectionText (kertas bergaris)
└── screens/
    ├── auth/                          # Splash, Login, Register
    ├── dashboard/                     # Dashboard (Lanjutkan latihan & pengguna baru)
    ├── gallery/                       # Interactive Design Gallery (58 State Viewer)
    ├── global/                        # Offline, Banner AI, Komponen Showcase
    ├── listening/                     # Latihan Listening, Audio Player, Soal, Transkrip
    ├── profile/                       # Profil Pengguna & Konfirmasi Keluar
    ├── reading/                       # Pengaturan, Cerita, Vocab Sheet, Kuis, Hasil
    ├── speaking/                      # Izin Mic, Chat Suara AI, Recording, Audio
    └── writing/                       # Input Teks, Loading, Review Koreksi Grammar
```

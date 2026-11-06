# English Day · SMAN 10 Gowa (Mobile EduTech App)

Implementasi Frontend Flutter lengkap untuk aplikasi pembelajaran bahasa Inggris **English Day** SMAN 10 Gowa, dislicing secara presisi 1:1 dari 58 desain visual pada folder `design/`. Seluruh fungsionalitas menggunakan data dummy interaktif tanpa backend.

---

## 📁 Struktur Repositori

```
english-day/
├── .gitignore
├── README.md
└── frontend/                          # Source code aplikasi Flutter
    ├── .gitignore
    ├── README.md                      # Dokumentasi teknis & mapping layar detail
    ├── pubspec.yaml
    ├── analysis_options.yaml
    ├── design/                        # 58 file PNG desain mockup UI
    ├── lib/
    │   ├── main.dart                  # Inisialisasi aplikasi & tema
    │   ├── data/
    │   │   └── dummy_data.dart        # Mock data (Writing, Reading, Speaking, Listening)
    │   ├── theme/
    │   │   └── app_theme.dart         # Design tokens & tema
    │   ├── widgets/                   # Komponen reusable
    │   └── screens/                   # Seluruh screen & modal (Auth, Dashboard, Writing, Reading, Speaking, Listening, Profile, Global, Gallery)
    ├── test/                          # Unit & widget smoke test
    ├── android/
    ├── ios/
    └── web/
```

---

## 🚀 Cara Menjalankan Aplikasi

Pastikan Flutter SDK sudah terpasang di komputer Anda.

```bash
# 1. Masuk ke direktori frontend
cd frontend

# 2. Unduh dependencies
flutter pub get

# 3. Jalankan aplikasi (Web / Android / iOS / Windows Desktop)
flutter run -d chrome
# atau
flutter run -d windows
# atau
flutter run
```

---

## 🎨 Interactive Design Gallery (Preview 58 Layar)

Untuk mempermudah verifikasi dan review slicing 1:1 terhadap seluruh 58 file gambar desain:
1. Jalankan aplikasi, buka menu **Profil** (avatar di pojok kanan atas Dashboard).
2. Pilih menu **Tentang aplikasi**.
3. Di dalam halaman ini terdapat **Galeri UI (58 layar)**. Anda dapat mengklik setiap item untuk membuka layar dan state persis seperti mockup Figma / PNG.

# 🎫 AI Ticket Manager App 🎫

**AI Ticket Manager** adalah aplikasi mudah alih (mobile) yang dibina menggunakan **Flutter** untuk menguruskan maklumat tiket dengan integrasi kecerdasan buatan. Aplikasi ini membolehkan pengguna menyimpan data tiket dan mendapatkan rumusan atau analisis pintar secara automatik menggunakan teknologi AI.

## 🚀 Fitur Utama

- **Sistem Autentikasi:** Log masuk dan pendaftaran pengguna yang selamat melalui **Firebase Auth**.
- **Pengurusan Tiket (CRUD):** Simpan, baca, dan urus maklumat tiket secara real-time menggunakan **Cloud Firestore**.
- **Analisis AI (Gemini):** Integrasi dengan **Gemini API** untuk menjana ringkasan automatik daripada butiran tiket yang dimasukkan.
- **Antarmuka Responsif:** Reka bentuk UI yang bersih dan mesra pengguna menggunakan komponen Material Design.
- **State Management:** Penggunaan *Provider* untuk pengurusan keadaan aplikasi yang efisien.

## 🛠️ Teknologi yang Digunakan

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Backend/Database:** [Firebase](https://firebase.google.com/) (Auth & Cloud Firestore)
- **AI Engine:** [Google Generative AI](https://ai.google.dev/) (Gemini API)
- **State Management:** [Provider](https://pub.dev/packages/provider)

## 📂 Struktur Projek

Output kode
File README created at /mnt/data/README_AI_Generator.md

```text
├── lib/
│   ├── models/          # Model data (Ticket)
│   ├── providers/       # Logic pengurusan state (TicketProvider)
│   ├── screens/         # Antarmuka pengguna (UI Screens)
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── ai_summary_screen.dart
│   │   └── ...
│   ├── services/        # Integrasi API & Backend
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   └── gemini_service.dart
│   ├── main.dart        # Entry point aplikasi
│   └── firebase_options.dart # Konfigurasi Firebase
├── android/             # Konfigurasi platform Android
├── ios/                 # Konfigurasi platform iOS
└── pubspec.yaml         # Pengurusan dependensi Flutter

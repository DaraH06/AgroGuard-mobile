<div align="center">
  <img src="assets/icon/agro1.png" alt="AgroGuard Logo" width="150"/>
  <h1>🌾 AgroGuard 📱</h1>
  <p><em>Aplikasi Android Pendeteksi Penyakit pada Tanaman Padi.</em></p>

[![Flutter](https://img.shields.io/badge/Flutter-^3.10.1-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Repo](https://img.shields.io/badge/Repository-GitHub-181717?logo=github)](https://github.com/Darah06/AgroGuard-mobile)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/Darah06/AgroGuard-mobile/LICENSE)

</div>

---

## 📖 Tentang Projek

**AgroGuard Mobile** adalah aplikasi klien berbasis Flutter yang merupakan bagian dari ekosistem AgroGuard. Aplikasi ini dirancang untuk penggunaan langsung di lapangan oleh petani, memungkinkan mereka untuk mengambil gambar tanaman padi, melampirkan data geolokasi secara otomatis, dan melakukan kompresi gambar sebelum diunggah ke backend Laravel untuk dianalisis.

## ✨ Fitur Utama

- 📸 **Smart Image Capture**: Pengambilan foto tanaman secara instan melalui kamera atau galeri.
- 📍 **Geolocation Tracking**: Penandaan otomatis koordinat GPS pada setiap laporan penyakit.
- 🗜️ **Efficient Image Compression**: Optimasi ukuran file gambar untuk menghemat kuota internet dan mempercepat unggahan.
- 🔗 **Backend Sync**: Integrasi API yang mulus dengan dashboard admin berbasis Laravel.
- 🔐 **Secure Config**: Manajemen API Key dan endpoint menggunakan environment variables (`.env`).
- 🎨 **Modern UI/UX**: Antarmuka bersih dengan standar Material Design 3.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **Library Penting**:
  - `image_picker` (Akses Kamera)
  - `geolocator` (Layanan Lokasi)
  - `flutter_image_compress` (Optimasi Gambar)
  - `http` (Komunikasi API)
  - `flutter_dotenv` (Keamanan Endpoint)

## 🚀 Persiapan Menjalankan Projek

Ikuti langkah-langkah berikut untuk menjalankan projek di lingkungan lokal Anda:

### Prasyarat

- Flutter SDK (^3.10.1 atau versi terbaru)
- Android Studio / VS Code
- Akses ke [AgroGuard Backend](https://github.com/Darah0/AgroGuard-mobile) (Laravel)

## 📱 Screenshots

<div align="center">
  <img src="assets/Screenshots/home.jpeg" width="230" alt="Home Screen"/> &nbsp;
  <img src="assets/Screenshots/kondisi.jpeg" width="230" alt="Kondisi Screen"/> &nbsp;
  <img src="assets/Screenshots/hasil.jpeg" width="230" alt="Hasil Analisis"/>
</div>

## 🤝 Kontributor

Terima kasih kepada anggota kelompok saya yang telah berkontribusi:

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<table align="center">
  <tr>
    <td align="center" width="160">
      <a href="https://github.com/Darah06">
        <img src="https://images.weserv.nl/?url=github.com/Darah06.png&w=120&h=120&fit=cover&mask=circle" width="100" alt="Darah06"/><br />
        <sub><b>Darah06</b></sub>
      </a><br />
      <sub>💻 🎨 📖</sub>
    </td>
    <td align="center" width="160">
      <a href="https://github.com/inihilmyloh">
        <img src="https://images.weserv.nl/?url=github.com/inihilmyloh.png&w=120&h=120&fit=cover&mask=circle" width="100" alt="inihilmyloh"/><br />
        <sub><b>inihilmyloh</b></sub>
      </a><br />
      <sub>💻 🎨 📖</sub>
    </td>
  </tr>
</table>

## 📄 Lisensi

Proyek ini dilisensikan di bawah **MIT License** - lihat file [LICENSE](LICENSE) untuk detail lebih lanjut.

---

<div align="center">
  <i>Dikembangkan dengan ❤️ oleh Tim AgroGuard untuk masa depan pertanian yang lebih cerdas.</i>
</div>

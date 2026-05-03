enjelasan Alur Upload Gambar (Flutter → Laravel)

1. `_pickImage` (file: `lib/home_screen.dart`)

- Fungsi untuk memilih atau mengambil foto dari kamera/galeri.
- Langkah:
  - Minta gambar menggunakan `ImagePicker` (camera/gallery).
  - Ambil posisi GPS lewat `Geolocator.getCurrentPosition`.
  - Kompres gambar dengan `FlutterImageCompress` dan simpan hasilnya sebagai file sementara.
  - Navigasi ke `PhotoPreviewScreen` dan kirim `imagePath`, `lat`, `long`.
- Tujuan: memastikan ukuran gambar wajar dan menyertakan lokasi untuk analisa.

2. `_showImageSourceDialog` (file: `lib/home_screen.dart`)

- Menampilkan bottom sheet berisi opsi: "Ambil dari Kamera" dan "Pilih dari Galeri".
- Memanggil `_pickImage(ImageSource.camera)` atau `_pickImage(ImageSource.gallery)` sesuai pilihan.

3. Tombol "Ambil Foto" (UI)

- Sebelum menampilkan dialog, aplikasi meminta izin kamera dan lokasi (`permission_handler`).
- Jika izin ditolak permanen, pengguna diarahkan ke pengaturan aplikasi.

4. `PhotoPreviewScreen._doUpload` (file: `lib/photo_preview_screen.dart`)

- Fungsi yang dipanggil ketika pengguna konfirmasi untuk mengunggah.
- Memanggil `UploadService.uploadImage(imagePath)` dan menampilkan loading.
- Menangani respon sukses dengan menampilkan dialog berisi metadata; menangani error dengan snackbar.

5. `UploadService.uploadImage` (file: `lib/services/upload_service.dart`)

- Membangun `http.MultipartRequest` ke endpoint Laravel `POST /api/upload`.
- Nama field multipart: `image` (harus konsisten dengan server).
- Mengirim header `Accept: application/json`.
- Timeout 30 detik, parsing JSON, dan mengembalikan `UploadResult` jika sukses.
- Menangani error koneksi dan format respons.

6. Model `UploadResult` (file: `lib/models/upload_result.dart`)

- Memetakan struktur `data` dari respons server: `id`, `image_path`, `image_url`, `original_filename`, `file_size`, `uploaded_at`.
- Menyediakan helper untuk format ukuran file.

7. Laravel: `FlutterImageController::upload` (file: `app/Http/Controllers/FlutterImageController.php`)

- Validasi request: field `image` wajib, tipe image, batas `mimes` dan `max` ukuran.
- Simpan file dengan `$file->store('uploads', 'public')` (disimpan di `storage/app/public/uploads`).
- Simpan metadata ke model `FlutterImage` (MongoDB) lalu kembalikan JSON sukses (status 201) berisi `data`.
- Error 422 untuk validasi, 500 untuk error lain.

8. Model Laravel `FlutterImage` (file: `app/Models/FlutterImage.php`)

- Menyimpan metadata dan menyediakan accessor `image_url` yang mengembalikan `asset('storage/' . $this->image_path)`.
- Pastikan menjalankan `php artisan storage:link` agar `public/storage` dapat diakses.

Checklist Penting

- Nama field multipart di Flutter harus `image`.
- Sesuaikan host di `UploadService` (emulator: `10.0.2.2`, physical device: IP dev atau `adb reverse`).
- Pastikan CORS jika domain berbeda.
- Jalankan `php artisan storage:link` untuk akses publik file.

Opsional

- Tambahkan pengiriman `lat`/`long` sebagai field text di multipart jika ingin disimpan di server.
- Pertimbangkan batas ukuran dan validasi tambahan di client dan server.

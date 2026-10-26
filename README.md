# flutter_ui_fundamentals

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



## Identitas Mahasiswa

- NIM: 2415051008
- Nama: I Putu Eka Bawa Utama

## Learning Dashboard

Project ini merupakan implementasi praktikum Flutter UI Fundamentals
yang menggunakan asset JSON, FutureBuilder, ListView, dan reusable widget.

### Fitur

- Menampilkan identitas mahasiswa
- Membaca data dari JSON statik
- Menampilkan daftar mata kuliah
- Menampilkan status mata kuliah
- Menggunakan FutureBuilder untuk proses asynchronous
- Menggunakan ListView untuk daftar data


## Cara Menjalankan Project

1. Pastikan Flutter sudah terpasang.
2. Jalankan `flutter pub get`.
3. Hubungkan emulator atau perangkat Android.
4. Jalankan aplikasi dengan `flutter run`.





## Arsitektur Aplikasi

Project ini menerapkan pemisahan tanggung jawab (*separation of concerns*) agar kode lebih terstruktur dan mudah dipelihara.

### Tanggung Jawab Folder

- `models/`: Mendefinisikan struktur data mata kuliah.
- `services/`: Membaca dan memproses data dari sumber data JSON.
- `repositories/`: Menjadi perantara antara Provider dan Service.
- `providers/`: Mengelola state mata kuliah, loading, dan error.
- `state/`: Mengelola state bersama, seperti daftar Favorites.
- `screens/`: Menyediakan halaman antarmuka aplikasi.
- `widgets/`: Menyediakan komponen UI yang dapat digunakan kembali.

File `main.dart` bertanggung jawab untuk menginisialisasi aplikasi dan mengatur konfigurasi Provider.

### Arah Dependency

Screen/Widget → Provider → Repository → Service/Data Source

Pembacaan JSON dilakukan melalui Service, bukan langsung dari Screen/UI. Provider tidak menyimpan `BuildContext` sebagai state.


## Finalisasi Praktikum

Proyek telah menyelesaikan tahapan state management dan architecture, termasuk penggunaan Provider, pemisahan Service dan Repository, pengelolaan shared state, serta audit separation of concerns. Riwayat perkembangan proyek dikelola menggunakan Git dan disinkronkan ke repository GitHub.

**Identitas Mahasiswa**
- Nama: I Putu Eka Bawa Utama
- NIM: 2415051008


## Tahap 1 — Membaca REST Endpoint dan JSON

### 1. Endpoint API
- **URL:** https://jsonplaceholder.typicode.com/posts/1
- **HTTP Method:** GET
- **Status Code:** 200 OK
- **Resource:** posts
- **Format Response:** JSON

### 2. Struktur Response JSON
Endpoint mengembalikan data satu post dengan struktur berikut:

```json
{
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
}
```

### 3. Identifikasi Field JSON

- **userId** (Integer): ID pengguna pemilik post.
- **id** (Integer): ID post.
- **title** (String): Judul post.
- **body** (String): Isi post.

### 4. Catatan dan Temuan
Endpoint berhasil diakses menggunakan metode GET dengan status code 200 OK. Server mengembalikan response dalam format JSON yang berisi empat field, yaitu `userId`, `id`, `title`, dan `body`. Data tersebut dapat digunakan sebagai contoh untuk mempelajari proses pengambilan dan pengolahan data dari REST API.

**Catatan:** JSONPlaceholder merupakan API latihan. Operasi penulisan data pada layanan ini disimulasikan dan tidak disimpan secara permanen.


---

## Backend yang Digunakan

Project ini menggunakan dua sumber data:

- **Supabase:** Backend database untuk pengelolaan data mata kuliah melalui operasi CRUD.
- **JSONPlaceholder:** REST API latihan untuk mempelajari komunikasi HTTP menggunakan GET, POST, PUT, dan DELETE.

## Arsitektur Singkat

Aplikasi menerapkan pemisahan tanggung jawab (*separation of concerns*) dengan alur:

`Screen/Widget → Provider → Repository → Service → Data Source`

- **Screen/Widget:** Menampilkan antarmuka dan menerima interaksi pengguna.
- **Provider:** Mengelola state, loading, dan error.
- **Repository:** Menjadi perantara antara Provider dan Service.
- **Service:** Menangani komunikasi dengan REST API atau Supabase.
- **Data Source:** Menyediakan data melalui backend atau API.

## Cara Menjalankan Aplikasi

1. Pastikan Flutter SDK dan emulator Android sudah tersedia.
2. Clone repository:

   ```bash
   git clone https://github.com/ekabawa/flutter_ui_fundamentals.git
   ```

3. Masuk ke folder project:

   ```bash
   cd flutter_ui_fundamentals
   ```

4. Instal dependency:

   ```bash
   flutter pub get
   ```

5. Pastikan konfigurasi Supabase sesuai dengan project yang digunakan.
6. Jalankan aplikasi:

   ```bash
   flutter run
   ```

## Error Handling dan Keamanan

Pengujian praktikum mencakup penanganan HTTP 404, kegagalan koneksi internet, dan kesalahan pemetaan JSON. Aplikasi menyediakan pesan error dan tombol coba lagi ketika pemuatan data gagal.

Konfigurasi keamanan dasar mencakup penggunaan publishable key Supabase, pemeriksaan kebijakan Row Level Security (RLS), serta pengabaian file `.env` melalui `.gitignore`. Kebijakan RLS harus disesuaikan dengan kebutuhan akses backend.

## Hasil Pemeriksaan

Pemeriksaan kode terakhir menggunakan `flutter analyze` menghasilkan:

`No issues found!`

Perubahan project dikelola menggunakan Git dan disinkronkan ke repository GitHub.

Repository: https://github.com/ekabawa/flutter_ui_fundamentals

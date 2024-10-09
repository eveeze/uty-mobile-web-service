// lib/main.dart

// Mengimpor package flutter yang diperlukan untuk membangun aplikasi Flutter
import 'package:flutter/material.dart';
// Mengimpor halaman HomePage dari folder 'pages'
import 'package:simple_app/pages/home_page.dart';
// Mengimpor halaman EditTaskPage yang baru ditambahkan dari folder 'pages'
import 'package:simple_app/pages/edit_task_page.dart';

// Fungsi utama untuk menjalankan aplikasi Flutter
void main() {
  runApp(const MyApp());
}

// MyApp adalah kelas StatelessWidget yang berfungsi sebagai root atau akar aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor dengan key opsional

  @override
  Widget build(BuildContext context) {
    // Menggunakan MaterialApp untuk mengatur tema dan struktur aplikasi
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Menyembunyikan label debug di pojok kanan atas
      initialRoute: '/', // Rute awal atau halaman pertama saat aplikasi dibuka
      routes: {
        '/': (context) => const HomePage(), // Rute ke halaman HomePage
        '/edit': (context) =>
            const EditTaskPage(), // Rute ke halaman EditTaskPage
      },
    );
  }
}

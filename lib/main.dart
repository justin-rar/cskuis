import 'package:flutter/material.dart';
import 'package:thischeat/login.dart'; // halaman pertama yang ditampilkan

// Entry point aplikasi Flutter — fungsi pertama yang dipanggil saat app dijalankan
void main() {
  runApp(const MyApp()); // menjalankan widget utama aplikasi
}

// MyApp — root widget dari seluruh aplikasi.
// StatelessWidget karena tidak punya state yang berubah — hanya konfigurasi global.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: menyediakan navigasi, tema, dan material design untuk seluruh app
    return MaterialApp(
      title: 'Menu Resto', // judul app (muncul di task switcher)
      debugShowCheckedModeBanner: false, // sembunyikan banner "DEBUG" di pojok kanan atas

      // ThemeData: konfigurasi tema global (warna, font, dsb)
      theme: ThemeData(
        // colorScheme.fromSeed: generate palet warna dari satu warna dasar
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true, // gunakan desain Material 3 (terbaru)
        scaffoldBackgroundColor: const Color(0xFFFFF8F3), // warna latar default semua halaman
      ),

      // home: widget pertama yang ditampilkan saat app dibuka
      // Dimulai dari LoginPage agar user harus login dulu
      home: const LoginPage(),
    );
  }
}

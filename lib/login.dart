import 'package:flutter/material.dart';
import 'package:thischeat/models/data.dart'; // untuk akses data user1
import 'package:thischeat/root.dart';        // untuk navigasi ke RootPage setelah login

// LoginPage — halaman pertama yang muncul saat app dibuka.
// StatefulWidget karena menyimpan state:
//   - _usernameController, _passwordController (input user)
//   - isLoginFailed (apakah login gagal — untuk tampilkan border merah)
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TextEditingController: menghubungkan kode dengan TextField
  // Digunakan untuk membaca nilai (.text) dan mengosongkan (.clear()) TextField
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State: apakah login terakhir gagal? Digunakan untuk menampilkan border merah
  bool isLoginFailed = false;

  // Method _login: dipanggil saat tombol Login ditekan
  void _login() {
    // Ambil teks dari controller
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Validasi: bandingkan dengan data user di data.dart
    if (username == user1.username && password == user1.password) {
      // Login berhasil → navigasi ke RootPage

      // Navigator.pushReplacement: ganti halaman saat ini dengan halaman baru.
      // Berbeda dengan push biasa — halaman Login DIHAPUS dari stack,
      // sehingga user tidak bisa back ke Login setelah masuk.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RootPage()),
      );
    } else {
      // Login gagal → update state untuk tampilkan pesan error
      setState(() {
        isLoginFailed = true; // TextField akan berubah jadi border merah
      });

      // SnackBar: pesan singkat yang muncul di bawah layar selama beberapa detik
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login gagal. Username atau password salah.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // dispose(): wajib dipanggil untuk membebaskan resource controller
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ikon logo aplikasi
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.shade100,
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  size: 48,
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(height: 24),

              // Judul dan subjudul
              const Text(
                'Menu Resto',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silakan login untuk melanjutkan',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Field input username — teruskan controller dan status gagal
              _usernameField(_usernameController, isLoginFailed),

              // Field input password — obscureText aktif (teks disembunyikan)
              _passwordField(_passwordController, isLoginFailed),

              const SizedBox(height: 24),

              // Tombol Login — lebar penuh layar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login, // panggil method _login saat ditekan
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fungsi helper: buat TextField untuk username
// Memisahkan pembuatan field ke fungsi sendiri agar build() lebih ringkas
Widget _usernameField(TextEditingController controller, bool isLoginFailed) {
  return _inputField(
    controller: controller,
    hint: 'Username',
    icon: Icons.person_outline,
    isLoginFailed: isLoginFailed,
    // obscure default false → teks username terlihat
  );
}

// Fungsi helper: buat TextField untuk password
Widget _passwordField(TextEditingController controller, bool isLoginFailed) {
  return _inputField(
    controller: controller,
    hint: 'Password',
    icon: Icons.lock_outline,
    isLoginFailed: isLoginFailed,
    obscure: true, // teks disembunyikan (diganti titik-titik)
  );
}

// Fungsi helper umum: buat TextField dengan konfigurasi yang fleksibel
// Named parameters dengan 'required' = wajib diisi
// 'bool obscure = false' = parameter opsional dengan nilai default false
Widget _inputField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  required bool isLoginFailed, // jika true → border merah
  bool obscure = false,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextField(
      controller: controller,
      // obscureText: sembunyikan teks (untuk password)
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        // Ikon di sisi kiri TextField
        prefixIcon: Icon(icon, color: Colors.orange),
        contentPadding: const EdgeInsets.all(14.0),
        // border: default border (saat tidak fokus dan tidak error)
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        // enabledBorder: border saat tidak fokus
        // Warna merah jika login gagal, oranye jika normal
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isLoginFailed ? Colors.red : Colors.orange,
            width: 1.5,
          ),
        ),
        // focusedBorder: border saat TextField aktif (diklik user)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isLoginFailed ? Colors.red : Colors.deepOrange,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    ),
  );
}

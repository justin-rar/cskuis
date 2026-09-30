// Model User: menyimpan data kredensial dan nama pengguna.
// Digunakan di LoginPage untuk validasi username dan password.
class User {
  String username; // username untuk login
  String password; // password untuk login
  String nama;     // nama lengkap yang ditampilkan di profil

  // Constructor dengan named parameter (semua wajib diisi)
  User({required this.username, required this.password, required this.nama});
}

// Data user yang terdaftar di aplikasi.
// Dalam aplikasi nyata, data ini berasal dari server/database — bukan hardcoded.
User user1 = User(
  username: 'justin',
  password: 'justin123',
  nama: 'Justin Muhammad Rasyid',
);

// Nama pelanggan yang tampil di halaman Profil.
// 'const' = nilai tidak berubah sama sekali sepanjang waktu runtime.
const String customerName = 'Justin Muhammad Rasyid';

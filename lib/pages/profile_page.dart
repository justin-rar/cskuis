import 'package:flutter/material.dart';
import 'package:thischeat/login.dart';
import 'package:thischeat/models/data.dart';

// ProfilePage — diubah menjadi StatefulWidget karena menyimpan state warna profil.
// Jika tidak ada state yang berubah, cukup pakai StatelessWidget.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State: warna avatar yang dipilih user, default oranye
  Color _selectedColor = Colors.orange;

  // Daftar pilihan warna yang tersedia untuk user
  // Dideklarasikan sebagai 'final' karena list-nya tidak diganti, hanya dibaca
  final List<Color> _colorOptions = [
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.indigo,
    Colors.blue,
    Colors.teal,
    Colors.green,
  ];

  // Method: tampilkan dialog konfirmasi sebelum logout
  // 'showDialog()' menampilkan widget dialog modal di atas halaman saat ini
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      // builder: fungsi yang mengembalikan widget dialog
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah kamu yakin ingin keluar?'),

        // actions: tombol-tombol di bagian bawah dialog
        actions: [
          // TextButton: tombol teks tanpa latar belakang — untuk aksi sekunder
          TextButton(
            onPressed: () => Navigator.pop(context), // tutup dialog, tidak logout
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),

          // ElevatedButton: tombol dengan latar belakang — untuk aksi utama
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Tutup dialog dulu sebelum navigasi
              Navigator.pop(context);

              // Navigator.pushAndRemoveUntil: pindah ke halaman baru sambil
              // menghapus SEMUA halaman di stack navigasi sebelumnya.
              // Parameter (route) => false: hapus semua route (tidak ada yang dikecualikan)
              // Efek: user tidak bisa back ke halaman setelah logout
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false, // false = hapus semua route
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange, // AppBar tetap oranye, tidak ikut color picker
        elevation: 0,

        // actions: widget yang tampil di kanan AppBar (biasanya tombol-tombol)
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout', // teks yang muncul saat ikon di-tap-and-hold
            // Panggil dialog konfirmasi, bukan langsung logout
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),

      // SingleChildScrollView: agar konten bisa di-scroll jika layar kecil
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Avatar Lingkaran ─────────────────────────────────
            // Container bundar dengan warna yang berubah sesuai _selectedColor
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // withValues(alpha:...) = warna dengan transparansi
                // alpha: 0.0 = transparan, 1.0 = penuh
                color: _selectedColor.withValues(alpha: 0.15),
              ),
              child: Icon(
                Icons.person,
                size: 64,
                color: _selectedColor.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 16),

            // Nama dari konstanta di data.dart
            Text(
              customerName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),

            // Subjudul
            const Text(
              'Pelanggan Resto',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // ── Color Picker ─────────────────────────────────────
            // Memilih warna untuk avatar profil
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Warna Profil',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Row: tampilkan lingkaran warna secara horizontal
            // .map(): transformasi setiap elemen list menjadi widget
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _colorOptions.map((color) {
                // Cek apakah warna ini yang sedang dipilih
                final bool isSelected = _selectedColor == color;

                // GestureDetector: mendeteksi gesture (tap, swipe, dll.)
                return GestureDetector(
                  onTap: () {
                    // Ubah _selectedColor → setState → build() dipanggil ulang
                    setState(() {
                      _selectedColor = color;
                    });
                  },

                  // AnimatedContainer: seperti Container biasa, tapi perubahan
                  // properti dianimasikan secara otomatis selama 'duration'
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    // Lingkaran yang dipilih lebih besar
                    width: isSelected ? 36 : 30,
                    height: isSelected ? 36 : 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      // Border hitam muncul hanya pada warna yang dipilih
                      border: Border.all(
                        color:
                            isSelected ? Colors.black45 : Colors.transparent,
                        width: 2.5,
                      ),
                      // Shadow muncul hanya pada warna yang dipilih
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                  ),
                );
              }).toList(), // ubah Iterable menjadi List<Widget>
            ),

            const SizedBox(height: 28),

            // ── Kartu Info ───────────────────────────────────────
            _InfoCard(
              icon: Icons.restaurant_menu,
              title: 'Menu Resto',
              subtitle: 'Pesan makanan favorit Anda dengan mudah.',
            ),
            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.shopping_cart_outlined,
              title: 'Pemesanan',
              subtitle: 'Jumlah dan harga dihitung otomatis.',
            ),
          ],
        ),
      ),
    );
  }
}

// _InfoCard — StatelessWidget untuk kartu informasi kecil.
// Dipisah menjadi widget sendiri agar kode lebih bersih dan mudah dibaca.
class _InfoCard extends StatelessWidget {
  final IconData icon;    // ikon yang ditampilkan
  final String title;    // judul kartu
  final String subtitle; // teks keterangan

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon dalam lingkaran oranye
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange.shade50,
            ),
            child: Icon(icon, color: Colors.deepOrange, size: 24),
          ),
          const SizedBox(width: 16),

          // Judul dan subjudul
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:thischeat/models/food_item.dart'; // untuk akses FoodItem.sampleData
import 'package:thischeat/pages/cart_page.dart';
import 'package:thischeat/pages/home_page.dart';
import 'package:thischeat/pages/profile_page.dart';

// RootPage — halaman kerangka utama yang berisi navigasi bawah (BottomNavBar).
// StatefulWidget karena menyimpan state indeks tab yang aktif.
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // State: indeks tab yang sedang aktif (0 = Menu, 1 = Keranjang, 2 = Profil)
  int _currentIndex = 0;

  // Daftar halaman yang ditampilkan — satu per tab
  // 'const': semua halaman dibuat sebagai konstanta (tidak ada state yang perlu dijaga saat inisialisasi)
  final List<Widget> _pages = const [
    HomePage(),   // tab index 0
    CartPage(),   // tab index 1
    ProfilePage(), // tab index 2
  ];

  // Getter: hitung berapa item yang sudah ada di keranjang (qty > 0)
  // Dihitung ulang setiap build() dipanggil
  int get _cartCount =>
      FoodItem.sampleData.where((f) => f.quantity > 0).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack: menampilkan hanya satu child sesuai 'index',
      // tapi SEMUA child tetap hidup di memori → state tiap tab tidak hilang saat ganti tab
      // Alternatif: Navigator (state hilang), PageView (bisa swipe)
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // NavigationBar: bottom navigation bar Material 3
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex, // tab yang aktif
        // onDestinationSelected: callback saat tab ditekan, menerima indeks baru
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index); // ganti tab → rebuild
        },
        indicatorColor: Colors.orange.shade100, // warna latar indikator tab aktif
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,

        // destinations: daftar tab yang tampil di NavigationBar
        destinations: [
          // Tab 0: Menu
          const NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu, color: Colors.deepOrange),
            label: 'Menu',
          ),

          // Tab 1: Keranjang — dengan Badge untuk menampilkan jumlah item
          NavigationDestination(
            // Badge.count: menampilkan lingkaran kecil berisi angka di atas ikon
            icon: Badge.count(
              count: _cartCount,
              // isLabelVisible: sembunyikan badge jika keranjang kosong
              isLabelVisible: _cartCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge.count(
              count: _cartCount,
              isLabelVisible: _cartCount > 0,
              child: const Icon(Icons.shopping_cart, color: Colors.deepOrange),
            ),
            label: 'Keranjang',
          ),

          // Tab 2: Profil
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Colors.deepOrange),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

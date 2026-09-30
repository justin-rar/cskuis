import 'package:flutter/material.dart';
import 'package:thischeat/models/food_item.dart';
import 'package:thischeat/pages/detail_page.dart';

// HomePage — StatefulWidget karena menyimpan state:
//   - daftar makanan (qty bisa berubah)
//   - teks pencarian (_searchQuery)
//   - pilihan pengurutan (_sortBy)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 'late final': diinisialisasi sekali saat pertama dipakai, tidak di-reset saat rebuild.
  // FoodItem.sampleData adalah list statis — qty yang diubah user tersimpan di sini.
  late final List<FoodItem> _foods = FoodItem.sampleData;

  // State pencarian: menyimpan teks yang sedang diketik user di search bar
  String _searchQuery = '';

  // State pengurutan: nilai bisa 'default' | 'nama_asc' | 'harga_asc' | 'harga_desc'
  String _sortBy = 'default';

  // Controller untuk TextField search bar
  // TextEditingController: mengontrol dan membaca nilai TextField secara programatik
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // dispose() dipanggil Flutter saat widget ini dihapus dari pohon widget.
    // Wajib dispose controller agar tidak terjadi memory leak (kebocoran memori).
    _searchController.dispose();
    super.dispose(); // selalu panggil super.dispose() di akhir
  }

  // Getter _filteredFoods: mengembalikan list yang sudah difilter dan diurutkan.
  // Getter dihitung ulang setiap kali build() dipanggil (saat setState dipanggil).
  List<FoodItem> get _filteredFoods {
    // Langkah 1: filter berdasarkan teks pencarian
    // .where() = iterasi list, ambil hanya elemen yang memenuhi kondisi
    // toLowerCase() = jadikan huruf kecil semua agar pencarian tidak case-sensitive
    List<FoodItem> result = _foods
        .where(
          (f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList(); // .toList() = ubah Iterable menjadi List

    // Langkah 2: urutkan berdasarkan pilihan _sortBy
    // .sort() = mengurutkan list di tempat (in-place), menggunakan fungsi comparator
    // comparator: fungsi (a, b) → negatif jika a < b, 0 jika sama, positif jika a > b
    if (_sortBy == 'nama_asc') {
      result.sort((a, b) => a.name.compareTo(b.name)); // A → Z
    } else if (_sortBy == 'harga_asc') {
      result.sort((a, b) => a.price.compareTo(b.price)); // termurah dulu
    } else if (_sortBy == 'harga_desc') {
      result.sort((a, b) => b.price.compareTo(a.price)); // termahal dulu
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),
      appBar: AppBar(
        title: const Text(
          'Menu Resto',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
      ),

      // Column: susun widget secara vertikal
      body: Column(
        children: [
          // ── Search Bar ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              controller: _searchController,
              // onChanged: callback yang dipanggil setiap teks berubah (per karakter)
              onChanged: (value) {
                setState(() {
                  // setState() memberitahu Flutter bahwa state berubah → rebuild widget
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari menu...',
                // Ikon di kiri TextField
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                // Ikon di kanan: hanya muncul jika ada teks (_searchQuery tidak kosong)
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear(); // kosongkan TextField
                          });
                        },
                      )
                    : null, // null = tidak tampil
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.orange.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.orange, width: 1.5),
                ),
              ),
            ),
          ),

          // ── Sort Chips ─────────────────────────────────────────
          // SingleChildScrollView horizontal: bisa di-scroll ke kanan jika layar sempit
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text(
                    'Urutkan: ',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 6),
                  // Buat chip untuk setiap pilihan sort
                  _buildSortChip('Default', 'default'),
                  const SizedBox(width: 6),
                  _buildSortChip('Nama A-Z', 'nama_asc'),
                  const SizedBox(width: 6),
                  _buildSortChip('Harga ↑', 'harga_asc'),
                  const SizedBox(width: 6),
                  _buildSortChip('Harga ↓', 'harga_desc'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Daftar Makanan ─────────────────────────────────────
          // Expanded: mengisi sisa ruang vertikal yang tersedia di Column
          Expanded(
            child: _filteredFoods.isEmpty
                // Tampilan empty state: jika tidak ada hasil pencarian
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 52, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Menu tidak ditemukan',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                  )
                // ListView.builder: efisien untuk list panjang, hanya render item yang terlihat
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredFoods.length, // jumlah item
                    // itemBuilder: dipanggil untuk setiap indeks, kembalikan widget
                    itemBuilder: (context, index) {
                      final item = _filteredFoods[index];
                      return _FoodCard(
                        food: item,
                        // onTap menggunakan async/await karena menunggu Navigator.push
                        onTap: () async {
                          // Navigator.push: buka halaman baru dan tunggu sampai ditutup
                          // <int>: tipe data yang dikembalikan saat halaman ditutup
                          final result = await Navigator.push<int>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(food: item),
                            ),
                          );

                          // Kode di bawah dijalankan setelah DetailPage ditutup
                          if (result != null) {
                            // Update qty item berdasarkan yang dikembalikan DetailPage
                            setState(() => item.quantity = result);

                            // context.mounted: cek apakah widget masih aktif
                            // (penting setelah await agar tidak error)
                            if (context.mounted) {
                              // SnackBar: notifikasi singkat di bawah layar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '✓ Pesanan ${item.name} disimpan (${result} porsi)',
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Method helper: membuat satu ChoiceChip untuk pilihan sort.
  // ChoiceChip: chip yang bisa dipilih, hanya satu yang aktif dalam satu waktu.
  Widget _buildSortChip(String label, String value) {
    final bool isSelected = _sortBy == value; // apakah chip ini sedang dipilih?
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.orange.shade100, // warna latar saat dipilih
      labelStyle: TextStyle(
        color: isSelected ? Colors.deepOrange : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      // onSelected: callback saat chip di-tap (parameter _ = nilai tidak dipakai)
      onSelected: (_) {
        setState(() {
          _sortBy = value; // ubah sort → getter _filteredFoods dihitung ulang
        });
      },
    );
  }
}

// _FoodCard — StatelessWidget karena hanya menampilkan data, tidak punya state sendiri.
// Menerima data dari parent (HomePage) lewat konstruktor.
class _FoodCard extends StatelessWidget {
  final FoodItem food;       // data makanan yang ditampilkan
  final VoidCallback onTap; // VoidCallback = fungsi tanpa parameter dan return value

  const _FoodCard({required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2, // tinggi bayangan
        shadowColor: Colors.orange.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        // InkWell: area yang bisa ditekan (dengan efek ripple/gelombang)
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            // Row: susun widget secara horizontal
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Gambar makanan di sisi kiri
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Image.network(
                      food.imageUrl,
                      fit: BoxFit.cover, // gambar memenuhi kotak tanpa distorsi
                      // loadingBuilder: widget yang ditampilkan selama gambar dimuat
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child; // sudah selesai dimuat
                        return Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              // CircularProgressIndicator: spinner loading bulat
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        );
                      },
                      // errorBuilder: widget saat gambar gagal dimuat
                      errorBuilder: (context, error, stack) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.fastfood,
                            size: 36,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. Kolom tengah: nama, deskripsi, porsi, harga
                // Expanded: mengisi sisa lebar yang tersedia di Row
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nama makanan
                      Text(
                        food.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Deskripsi — maxLines: batas baris; overflow: cara memotong teks
                      Text(
                        food.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis, // tambah "..." jika terpotong
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),

                      // Baris jumlah porsi dan harga satuan
                      Row(
                        children: [
                          Text(
                            '${food.quantity} porsi',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Rp ${food.formattedPrice} / porsi',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 3. Total harga di kanan (qty × harga)
                Text(
                  'Rp ${food.formattedTotal}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

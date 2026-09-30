import 'package:flutter/material.dart';
import 'package:thischeat/models/food_item.dart';

// CartPage — halaman keranjang yang menampilkan semua item yang sudah dipesan (qty > 0).
// Menggunakan StatefulWidget agar bisa di-refresh saat user kembali ke halaman ini.
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Getter: filter dari data statis, ambil hanya yang qty-nya > 0
  // Setiap kali build() dipanggil, daftar ini dihitung ulang dari data terbaru
  List<FoodItem> get _orderedItems =>
      FoodItem.sampleData.where((f) => f.quantity > 0).toList();

  // Getter: hitung total semua pesanan
  // fold() = iterasi list sambil mengakumulasi nilai (seperti reduce)
  int get _grandTotal =>
      _orderedItems.fold(0, (sum, f) => sum + f.totalPrice);

  @override
  Widget build(BuildContext context) {
    // Ambil daftar item saat build dipanggil (sudah ter-filter)
    final items = _orderedItems;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
      ),

      // Tampilan bercabang: kosong vs ada item
      body: items.isEmpty
          // ── Tampilan ketika keranjang kosong ───────────────────────
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ikon besar sebagai ilustrasi
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 72,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Pilih menu di halaman Beranda dulu ya!',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            )

          // ── Tampilan ketika ada item yang dipesan ─────────────────
          : Column(
              children: [
                // Daftar item pesanan — Expanded agar mengisi ruang tersisa
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    // itemBuilder dipanggil untuk setiap item di list
                    itemBuilder: (context, index) {
                      return _CartItemTile(food: items[index]);
                    },
                  ),
                ),

                // ── Panel Total di Bagian Bawah ──────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    // Border radius hanya di sudut atas
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Baris ringkasan total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${items.length} item dipesan',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Total Pembayaran',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              // Tampilkan total dengan format ribuan
                              Text(
                                'Rp ${formatPrice(_grandTotal)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Tombol "Pesan Sekarang" — lebar penuh
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showOrderDialog(context),
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Pesan Sekarang',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // Method: tampilkan AlertDialog konfirmasi sebelum memesan
  // showDialog() = menampilkan dialog modal di atas halaman saat ini
  void _showOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      // builder: function yang mengembalikan widget dialog
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Pesanan'),
        // Isi dialog: ringkasan pesanan
        content: Text(
          '${_orderedItems.length} menu dipesan\n'
          'Total: Rp ${formatPrice(_grandTotal)}\n\n'
          'Lanjutkan pemesanan?',
        ),
        // Tombol-tombol aksi di dalam dialog
        actions: [
          // Tombol Batal — hanya menutup dialog
          TextButton(
            onPressed: () => Navigator.pop(context), // tutup dialog
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          // Tombol Konfirmasi — tutup dialog lalu tampilkan SnackBar
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context); // tutup dialog dulu
              // Tampilkan SnackBar sebagai notifikasi singkat di bawah layar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎉 Pesanan berhasil dibuat!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Pesan Sekarang'),
          ),
        ],
      ),
    );
  }
}

// _CartItemTile — StatelessWidget untuk satu baris item di keranjang.
// Menampilkan gambar, nama, harga satuan × qty, dan total harga item.
class _CartItemTile extends StatelessWidget {
  final FoodItem food;

  const _CartItemTile({required this.food});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Gambar kecil di kiri
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 64,
                height: 64,
                child: Image.network(
                  food.imageUrl,
                  fit: BoxFit.cover,
                  // Fallback jika gambar gagal dimuat
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.fastfood, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Nama makanan dan keterangan harga × qty
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Harga satuan dikali jumlah porsi
                  Text(
                    'Rp ${food.formattedPrice} × ${food.quantity} porsi',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Total harga item ini (harga × qty)
            Text(
              'Rp ${food.formattedTotal}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

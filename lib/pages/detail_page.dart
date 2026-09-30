import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // untuk FilteringTextInputFormatter
import 'package:thischeat/models/food_item.dart';

// DetailPage — StatefulWidget karena menyimpan state:
//   - _currentQty (jumlah porsi saat ini)
//   - _qtyController (TextEditingController untuk input angka)
class DetailPage extends StatefulWidget {
  // 'final': field tidak bisa diubah setelah widget dibuat
  final FoodItem food; // data makanan yang dikirim dari HomePage

  // Constructor: wajib isi food
  const DetailPage({super.key, required this.food});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // 'late final': diinisialisasi di initState(), bukan di deklarasi
  late final TextEditingController _qtyController;

  // State jumlah porsi saat ini; diambil dari widget.food.quantity saat awal
  int _currentQty = 0;

  // initState(): dipanggil SATU KALI saat State pertama kali dibuat
  // Gunakan untuk inisialisasi yang membutuhkan context atau widget data
  @override
  void initState() {
    super.initState(); // selalu panggil super.initState() dulu
    _currentQty = widget.food.quantity; // ambil qty awal dari data makanan
    // Inisialisasi controller dengan teks awal berupa qty saat ini
    _qtyController = TextEditingController(text: _currentQty.toString());
  }

  // dispose(): dipanggil saat State dihapus dari pohon widget (halaman ditutup)
  // Wajib dispose semua controller untuk menghindari memory leak
  @override
  void dispose() {
    _qtyController.dispose(); // bebaskan resource controller
    super.dispose();
  }

  // Getter _totalPrice: hitung total harga live berdasarkan _currentQty
  int get _totalPrice => _currentQty * widget.food.price;

  // Method _changeQty: ubah qty dengan tombol +/-
  // delta = perubahan qty: +1 (tambah) atau -1 (kurang)
  void _changeQty(int delta) {
    // clamp(min, max): batasi nilai antara min dan max
    final newVal = (_currentQty + delta).clamp(0, 99);
    setState(() {
      _currentQty = newVal;
      _qtyController.text = newVal.toString(); // sinkronkan TextField
      // Set posisi kursor di akhir teks
      _qtyController.selection = TextSelection.fromPosition(
        TextPosition(offset: _qtyController.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // widget.food: akses data dari parent melalui 'widget' (dari StatefulWidget)
    final food = widget.food;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),
      appBar: AppBar(
        // Judul AppBar menampilkan nama makanan yang dipilih
        title: Text(
          food.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // iconTheme: atur warna ikon default di AppBar (termasuk tombol back)
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),

      // SingleChildScrollView: agar konten bisa di-scroll jika layar penuh
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Gambar Besar Makanan ─────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: double.infinity, // lebar penuh layar
                height: 200,
                child: Image.network(
                  food.imageUrl,
                  fit: BoxFit.cover,
                  // Spinner saat gambar masih dimuat
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  // Fallback saat gambar gagal dimuat (error)
                  errorBuilder: (context, error, stack) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.fastfood, size: 64, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Kartu Informasi Makanan ──────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                // boxShadow: efek bayangan di bawah container
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4), // bayangan ke bawah
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama makanan
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Harga per porsi — menggunakan getter formattedPrice
                  Text(
                    'Rp ${food.formattedPrice} / porsi',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Deskripsi makanan
                  Text(
                    food.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5, // jarak antar baris (line height)
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Kartu Input Jumlah Porsi ─────────────────────────
            Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jumlah Pesanan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Baris: tombol ─, TextField angka, tombol +
                  Row(
                    children: [
                      // Tombol kurang porsi (─)
                      _QtyButton(
                        icon: Icons.remove,
                        onPressed: () => _changeQty(-1), // kurangi 1
                      ),
                      const SizedBox(width: 12),

                      // TextField untuk input qty secara manual
                      Expanded(
                        child: TextField(
                          controller: _qtyController,
                          keyboardType: TextInputType.number, // keyboard angka
                          // inputFormatters: filter input agar hanya angka yang diterima
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Jumlah (porsi)',
                            prefixIcon: const Icon(
                              Icons.dining,
                              color: Colors.orange,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.orange,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.orange.shade200,
                              ),
                            ),
                          ),
                          // onChanged: dipanggil setiap kali teks diketik
                          onChanged: (val) {
                            final parsed = int.tryParse(val) ?? 0;
                            final clamped = parsed.clamp(0, 99);
                            setState(() => _currentQty = clamped);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Tombol tambah porsi (+)
                      _QtyButton(
                        icon: Icons.add,
                        onPressed: () => _changeQty(1), // tambah 1
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Baris total harga — diperbarui setiap setState dipanggil
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      // Getter _totalPrice dihitung ulang saat setState dipanggil
                      Text(
                        'Rp ${formatPrice(_totalPrice)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Tombol Simpan Pemesanan ──────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigator.pop: tutup halaman ini dan kembali ke halaman sebelumnya.
                  // Parameter kedua (_currentQty) adalah NILAI yang dikembalikan ke halaman sebelumnya.
                  // Di HomePage, nilai ini ditangkap oleh: final result = await Navigator.push(...)
                  Navigator.pop(context, _currentQty);
                },
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: const Text(
                  'Simpan Pemesanan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _QtyButton — StatelessWidget untuk tombol + dan - yang seragam.
// Dipisah menjadi widget sendiri agar kode lebih rapi dan bisa dipakai ulang.
class _QtyButton extends StatelessWidget {
  final IconData icon;          // ikon yang ditampilkan (add atau remove)
  final VoidCallback onPressed; // fungsi yang dipanggil saat tombol ditekan

  const _QtyButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Material + InkWell: kombinasi untuk tombol custom dengan efek ripple
    return Material(
      color: Colors.orange.shade50,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed, // panggil callback saat ditekan
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center, // tengahkan ikon di dalam container
          child: Icon(icon, color: Colors.deepOrange, size: 20),
        ),
      ),
    );
  }
}

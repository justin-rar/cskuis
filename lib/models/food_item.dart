// Model item makanan yang tampil di halaman Beranda, Detail, dan Keranjang.
class FoodItem {
  // Field 'final' = tidak bisa diubah setelah objek dibuat (immutable)
  final String name;        // Nama makanan
  final String description; // Deskripsi singkat
  final String imageUrl;    // URL gambar dari internet

  // Field 'int' biasa (bukan final) = bisa diubah → dipakai untuk update qty
  int quantity; // Jumlah porsi yang dipesan user, default 0

  final int price; // Harga per porsi dalam rupiah

  // Constructor: wajib isi semua field (required)
  FoodItem({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  // Getter 'totalPrice': menghitung total harga (qty × harga satuan)
  // Getter = seperti field, tapi nilainya dihitung setiap kali diakses
  int get totalPrice => quantity * price;

  // Getter 'formattedPrice': harga satuan dalam format ribuan (15000 → "15.000")
  String get formattedPrice => formatPrice(price);

  // Getter 'formattedTotal': total harga dalam format ribuan
  String get formattedTotal => formatPrice(totalPrice);

  // 'static final' = milik class, bukan objek; hanya dibuat sekali saat app berjalan.
  // Diakses lewat FoodItem.sampleData (tanpa buat objek dulu).
  // 'late final' di HomePage memastikan list ini tidak di-reset saat widget rebuild.
  static final List<FoodItem> sampleData = [
    FoodItem(
      name: 'Nasi Goreng',
      description: 'Nasi goreng spesial dengan telur, ayam, dan kerupuk.',
      imageUrl:
          'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800&q=80&auto=format&fit=crop',
      quantity: 0, // awal 0, berubah ketika user memesan
      price: 15000,
    ),
    FoodItem(
      name: 'Mie Goreng',
      description: 'Mie goreng jawa dengan bumbu khas dan sayuran segar.',
      imageUrl:
          'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=800&q=80&auto=format&fit=crop',
      quantity: 0,
      price: 12000,
    ),
    FoodItem(
      name: 'Ayam Bakar',
      description:
          'Ayam bakar bumbu kecap disajikan dengan sambal dan lalapan.',
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80&auto=format&fit=crop',
      quantity: 0,
      price: 25000,
    ),
    FoodItem(
      name: 'Es Teh',
      description: 'Teh manis dingin yang menyegarkan.',
      imageUrl:
          'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800&q=80&auto=format&fit=crop',
      quantity: 0,
      price: 5000,
    ),
    FoodItem(
      name: 'Es Jeruk',
      description: 'Jeruk peras asli dingin dengan es batu.',
      imageUrl:
          'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=800&q=80&auto=format&fit=crop',
      quantity: 0,
      price: 6000,
    ),
  ];
}

// Fungsi helper untuk format angka menjadi format ribuan dengan titik.
// Contoh: 15000 → "15.000", 125000 → "125.000"
// replaceAllMapped: cari semua pola regex lalu ganti sesuai fungsi (m)
String formatPrice(int value) {
  return value.toString().replaceAllMapped(
    // Regex: cocokkan digit yang diikuti kelipatan 3 digit sampai akhir string
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]}.', // tambahkan titik setelah digit yang cocok
  );
}

import 'package:flutter/material.dart';
import 'package:aplikasi_apaweh/models/coffee_menu.dart';
import 'package:aplikasi_apaweh/pages/detail_page.dart';

/// Halaman Utama Aplikasi Kafe "KopiKita"
/// Menerapkan lebih dari 10 Widget dasar Flutter dengan arsitektur bersih dan mudah dipahami.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. Data Kategori Menu
  final List<String> _categories = ['Semua', 'Kopi', 'Non-Kopi', 'Makanan'];
  String _selectedCategory = 'Semua';

  // 2. Controller & Query untuk fitur Pencarian Menu
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // 3. State Keranjang Belanja: Menyimpan pasangan (ID Menu -> Jumlah Pesanan)
  final Map<String, int> _cart = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi menambah 1 porsi menu ke keranjang
  void _addToCart(CoffeeMenu item, [int quantity = 1]) {
    setState(() {
      _cart[item.id] = (_cart[item.id] ?? 0) + quantity;
    });

    // Menampilkan notifikasi SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} ($quantity porsi) ditambahkan! ☕'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF5D4037),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.amber,
          onPressed: () {},
        ),
      ),
    );
  }

  // Menghitung total porsi seluruh item di keranjang
  int _getTotalItems() {
    int total = 0;
    for (var count in _cart.values) {
      total += count;
    }
    return total;
  }

  // Menghitung total harga seluruh pesanan di keranjang
  int _getTotalPrice() {
    int total = 0;
    _cart.forEach((id, qty) {
      final menu = dummyMenuList.firstWhere((item) => item.id == id);
      total += menu.price * qty;
    });
    return total;
  }

  // Mengosongkan keranjang belanja
  void _clearCart() {
    setState(() {
      _cart.clear();
    });
  }

  // Membuka Dialog Struk Kasir / Rincian Checkout
  void _showCheckoutDialog() {
    final int total = _getTotalPrice();
    final int totalItems = _getTotalItems();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.receipt_long, color: Color(0xFF6F4E37)),
              SizedBox(width: 8),
              Text(
                'Struk Pesanan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rincian Pesanan Kamu:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: _cart.entries.map((entry) {
                      final item = dummyMenuList.firstWhere(
                        (m) => m.id == entry.key,
                      );
                      final subtotal = item.price * entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.name} x${entry.value}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Text(
                              'Rp ${subtotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total ($totalItems item):',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Rp ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF6F4E37),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F4E37),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '🎉 Pembayaran Berhasil! Pesanan sedang disiapkan.',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Bayar Sekarang'),
            ),
          ],
        );
      },
    );
  }

  // Membuka halaman detail menu
  void _navigateToDetail(CoffeeMenu menu) async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(menu: menu)),
    );

    // Jika user menambahkan item dari halaman detail
    if (result != null && result > 0) {
      _addToCart(menu, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Memfilter daftar menu berdasarkan Kategori yang dipilih dan Kata Kunci pencarian
    final filteredMenu = dummyMenuList.where((item) {
      final matchesCategory =
          _selectedCategory == 'Semua' || item.category == _selectedCategory;
      final matchesSearch =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    final int totalCartItems = _getTotalItems();

    // 1. WIDGET: Scaffold (Struktur dasar layar)
    return Scaffold(
      // 2. WIDGET: AppBar (Header bilah navigasi atas)
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'KopiKita ☕',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723),
              ),
            ),
            Text(
              'Aroma Kopi Hangat Setiap Hari',
              style: TextStyle(
                fontSize: 12,
                color: Colors.brown,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          // 3. WIDGET: Badge (Penunjuk angka di ikon keranjang belanja)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Badge(
              label: Text('$totalCartItems'),
              isLabelVisible: totalCartItems > 0,
              backgroundColor: const Color(0xFFD32F2F),
              child: IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, size: 28),
                color: const Color(0xFF3E2723),
                onPressed: totalCartItems > 0 ? _showCheckoutDialog : null,
                tooltip: 'Keranjang Pesanan',
              ),
            ),
          ),
        ],
      ),

      // 4. WIDGET: SingleChildScrollView (Membuat halaman utama responsif dan dapat di-scroll)
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 5. WIDGET: Container Promo Banner bergradasi modern
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6F4E37),
                    Color(0xFF8D6E63),
                    Color(0xFFA1887F),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6F4E37).withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Promo Spesial Mahasiswa 🎓',
                          style: TextStyle(
                            color: Colors.amberAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Diskon 20% Hari Ini!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Bikin tugas lebih semangat bareng kopi favoritmu.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_cafe,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 6. WIDGET: TextField (Kotak Pencarian Menu yang responsif)
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari kopi, pastry, atau snack...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8D6E63)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.brown.shade100),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.brown.shade100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF6F4E37),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 7. WIDGET: Row untuk Kategori Menu (Horizontal scroll menggunakan SingleChildScrollView)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  // 8. WIDGET: FilterChip (Pilihan filter kategori)
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: const Color(0xFF6F4E37),
                      backgroundColor: Colors.white,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF5D4037),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF6F4E37)
                              : Colors.brown.shade200,
                        ),
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 18),

            // Judul Bagian Daftar Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Menu Favorit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                  ),
                ),
                Text(
                  '${filteredMenu.length} Pilihan',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 9. WIDGET: ListView (Menampilkan item menu dalam daftar dinamis)
            if (filteredMenu.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Column(
                  children: const [
                    Icon(Icons.search_off, size: 56, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Menu yang kamu cari tidak ditemukan',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredMenu.length,
                itemBuilder: (context, index) {
                  final item = filteredMenu[index];
                  final inCartCount = _cart[item.id] ?? 0;

                  // 10. WIDGET: Card (Kartu item menu dengan elevasi dan sudut melengkung)
                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    elevation: 1.5,
                    shadowColor: Colors.brown.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: Colors.brown.shade100,
                        width: 0.8,
                      ),
                    ),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => _navigateToDetail(item),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Ikon Menu di dalam kotak berdekorasi
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: item.accentColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                item.icon,
                                size: 36,
                                color: item.accentColor,
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Informasi Menu (Nama, Kategori, Rating, Harga)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3E2723),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${item.rating}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '• ${item.category}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Rp ${item.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF6F4E37),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Tombol Pesan / Tambah Porsi
                            Column(
                              children: [
                                if (inCartCount > 0)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6F4E37),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$inCartCount di keranjang',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                IconButton.filledTonal(
                                  style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xFFEFEBE9),
                                    foregroundColor: const Color(0xFF5D4037),
                                  ),
                                  onPressed: () => _addToCart(item),
                                  icon: const Icon(Icons.add),
                                  tooltip: 'Tambah ke Pesanan',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(
              height: 80,
            ), // Ruang ekstra agar tidak tertutup bottom bar
          ],
        ),
      ),

      // 11. WIDGET: BottomSheet / Bottom Bar Mengambang Ringkasan Pesanan Aktif
      bottomNavigationBar: totalCartItems > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Pesanan ($totalCartItems item):',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Rp ${_getTotalPrice().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6F4E37),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F4E37),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _showCheckoutDialog,
                      icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                      label: const Text(
                        'Checkout',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:aplikasi_apaweh/models/coffee_menu.dart';

/// Halaman Detail Menu untuk melihat rincian item dan kustomisasi pesanan
class DetailPage extends StatefulWidget {
  final CoffeeMenu menu;

  const DetailPage({
    super.key,
    required this.menu,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // State untuk kustomisasi pesanan
  int _quantity = 1;
  String _selectedTemperature = 'Dingin (Ice)';
  String _selectedSugar = 'Normal (100%)';

  // Daftar opsi suhu dan tingkat gula
  final List<String> _tempOptions = ['Dingin (Ice)', 'Hangat (Hot)'];
  final List<String> _sugarOptions = ['Normal (100%)', 'Less Sweet (50%)', 'Tanpa Gula (0%)'];

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung total harga berdasarkan jumlah porsi
    final int totalPrice = widget.menu.price * _quantity;

    // 1. WIDGET: Scaffold (Kerangka utama halaman)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Menu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // 2. WIDGET: SingleChildScrollView (Membuat konten bisa di-scroll bila layar kecil)
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3. WIDGET: Container dengan dekorasi gradasi untuk foto/ikon menu
              Center(
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.menu.accentColor.withValues(alpha: 0.15),
                        widget.menu.accentColor.withValues(alpha: 0.35),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: widget.menu.accentColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      widget.menu.icon,
                      size: 96,
                      color: widget.menu.accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. WIDGET: Row untuk Kategori dan Rating Bintang
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Badge Kategori
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6F4E37).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.menu.category,
                      style: const TextStyle(
                        color: Color(0xFF5D4037),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  // Rating Bintang
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.menu.rating} (Rating Dosen ⭐)',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 5. WIDGET: Text untuk Nama Menu
              Text(
                widget.menu.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
              const SizedBox(height: 8),

              // Harga Satuan
              Text(
                'Rp ${widget.menu.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6F4E37),
                ),
              ),
              const SizedBox(height: 16),

              const Divider(),
              const SizedBox(height: 12),

              // Judul Deskripsi
              const Text(
                'Deskripsi Menu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
              const SizedBox(height: 6),

              // Deskripsi lengkap
              Text(
                widget.menu.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // 6. WIDGET: Card untuk Kustomisasi Sajian
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.brown.shade100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pilihan Penyajian',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Pilihan Suhu
                      Wrap(
                        spacing: 8,
                        children: _tempOptions.map((temp) {
                          final isSelected = _selectedTemperature == temp;
                          return ChoiceChip(
                            label: Text(temp),
                            selected: isSelected,
                            selectedColor: const Color(0xFF6F4E37),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                            onSelected: (val) {
                              if (val) {
                                setState(() => _selectedTemperature = temp);
                              }
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),

                      const Text(
                        'Tingkat Kemanisan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Pilihan Gula
                      Wrap(
                        spacing: 8,
                        children: _sugarOptions.map((sugar) {
                          final isSelected = _selectedSugar == sugar;
                          return ChoiceChip(
                            label: Text(sugar),
                            selected: isSelected,
                            selectedColor: const Color(0xFF6F4E37),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            onSelected: (val) {
                              if (val) {
                                setState(() => _selectedSugar = sugar);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Pengatur Jumlah Pesanan (Counter / Quantity Selector)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jumlah Porsi:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.brown.shade200),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _decreaseQuantity,
                          icon: const Icon(Icons.remove, size: 18),
                          color: const Color(0xFF6F4E37),
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        IconButton(
                          onPressed: _increaseQuantity,
                          icon: const Icon(Icons.add, size: 18),
                          color: const Color(0xFF6F4E37),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      // 7. WIDGET: Container Bottom Bar untuk Tombol Tambah Pesanan
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Ringkasan Total
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6F4E37),
                      ),
                    ),
                  ],
                ),
              ),
              // 8. WIDGET: ElevatedButton (Tombol Konfirmasi Tambah Pesanan)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F4E37),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  // Kembali ke halaman beranda dan mengirimkan jumlah pesanan
                  Navigator.pop(context, _quantity);
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text(
                  'Tambah Pesanan',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
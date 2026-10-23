import 'package:flutter/material.dart';

/// Model data sederhana untuk merepresentasikan item menu kafe
class CoffeeMenu {
  final String id;
  final String name;
  final String category;
  final int price;
  final double rating;
  final String description;
  final IconData icon;
  final Color accentColor;

  const CoffeeMenu({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.description,
    required this.icon,
    this.accentColor = const Color(0xFF6F4E37),
  });
}

/// Daftar data menu (Dummy Data) yang siap ditampilkan di aplikasi
final List<CoffeeMenu> dummyMenuList = [
  const CoffeeMenu(
    id: '1',
    name: 'Caramel Macchiato',
    category: 'Kopi',
    price: 28000,
    rating: 4.8,
    description:
        'Espresso murni berkualitas tinggi dipadukan sirup vanila lembut, susu gurih, dan saus karamel lezat di atasnya.',
    icon: Icons.coffee,
    accentColor: Color(0xFF8D6E63),
  ),
  const CoffeeMenu(
    id: '2',
    name: 'Iced Americano',
    category: 'Kopi',
    price: 22000,
    rating: 4.7,
    description:
        'Double shot espresso premium yang diseduh dengan air dingin dan es batu segar. Segar dan meningkatkan fokus.',
    icon: Icons.local_cafe,
    accentColor: Color(0xFF5D4037),
  ),
  const CoffeeMenu(
    id: '3',
    name: 'Creamy Matcha Latte',
    category: 'Non-Kopi',
    price: 30000,
    rating: 4.9,
    description:
        'Teh hijau matcha otentik dengan susu segar creamy, memberikan rasa manis lembut dan menenangkan pikiran.',
    icon: Icons.emoji_food_beverage,
    accentColor: Color(0xFF2E7D32),
  ),
  const CoffeeMenu(
    id: '4',
    name: 'Belgian Choco Float',
    category: 'Non-Kopi',
    price: 27000,
    rating: 4.8,
    description:
        'Cokelat pekat Belgia dengan lelehan cokelat kental dan es krim vanila di atasnya.',
    icon: Icons.icecream,
    accentColor: Color(0xFF795548),
  ),
  const CoffeeMenu(
    id: '5',
    name: 'Butter Croissant',
    category: 'Makanan',
    price: 24000,
    rating: 4.9,
    description:
        'Pastry renyah berlapis dengan aroma butter Prancis yang wangi, dipanggang hangat setiap pagi.',
    icon: Icons.bakery_dining,
    accentColor: Color(0xFFE65100),
  ),
  const CoffeeMenu(
    id: '6',
    name: 'Red Velvet Cake',
    category: 'Makanan',
    price: 32000,
    rating: 4.8,
    description:
        'Sepotong kue lembut red velvet dengan olesan cream cheese premium gurih manis yang lumer di lidah.',
    icon: Icons.cake,
    accentColor: Color(0xFFC2185B),
  ),
];

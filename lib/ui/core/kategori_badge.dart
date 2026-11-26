import 'package:flutter/material.dart';

IconData iconKategori(String kategori) {
  switch (kategori) {
    case 'Makanan':
      return Icons.rice_bowl_outlined;
    case 'Minuman':
      return Icons.local_cafe_outlined;
    case 'Camilan':
      return Icons.cookie_outlined;
    default:
      return Icons.restaurant_menu;
  }
}

/// Kotak ikon kategori (warna solid, tanpa gradasi).
class KategoriBadge extends StatelessWidget {
  const KategoriBadge({super.key, required this.kategori, this.size = 44});

  final String kategori;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(
        iconKategori(kategori),
        size: size * 0.5,
        color: scheme.onPrimaryContainer,
      ),
    );
  }
}

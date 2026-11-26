import 'package:flutter/material.dart';

import '../../../domain/models/menu_item.dart';
import '../../core/kategori_badge.dart';

/// Panel detail menu. Dipakai sebagai panel samping (tablet)
/// dan sebagai bottom sheet (HP).
class MenuDetail extends StatelessWidget {
  const MenuDetail({super.key, required this.item, required this.onTambah});

  final MenuItem? item;
  final VoidCallback onTambah;

  @override
  Widget build(BuildContext context) {
    final menu = item;
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    if (menu == null) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app_outlined,
                  size: 40, color: scheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text(
                'Pilih menu untuk melihat detail',
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Padding menyesuaikan lebar panel yang tersedia.
          final padding = constraints.maxWidth < 340 ? 16.0 : 24.0;
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: KategoriBadge(kategori: menu.kategori, size: 56),
                ),
                const SizedBox(height: 16),
                Text(
                  menu.kategori,
                  style: text.labelLarge?.copyWith(color: scheme.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  menu.nama,
                  style:
                      text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  formatRupiah(menu.harga),
                  style: text.titleLarge?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  menu.deskripsi,
                  style: text.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant, height: 1.4),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onTambah,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah ke pesanan'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

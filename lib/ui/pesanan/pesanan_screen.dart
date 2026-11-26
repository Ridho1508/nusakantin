import 'package:flutter/material.dart';

import '../../domain/models/menu_item.dart';
import '../menu/menu_view_model.dart';

class PesananScreen extends StatelessWidget {
  const PesananScreen({super.key, required this.viewModel});

  final MenuViewModel viewModel;

  void _pesan(BuildContext context) {
    viewModel.kosongkan();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Pesanan berhasil dikirim'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final pesanan = viewModel.pesanan;

        if (pesanan.isEmpty) return const _Kosong();

        final daftar = ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pesanan.length,
          itemBuilder: (context, index) {
            final baris = pesanan[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _PesananTile(
                baris: baris,
                onTambah: () => viewModel.tambah(baris.item),
                onKurang: () => viewModel.kurang(baris.item),
              ),
            );
          },
        );

        final ringkasan = _Ringkasan(
          jumlah: viewModel.totalJumlah,
          total: viewModel.totalHarga,
          onPesan: () => _pesan(context),
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            // Landscape / layar lebar: ringkasan pindah ke samping.
            if (constraints.maxWidth >= 600) {
              return Row(
                children: [
                  Expanded(child: daftar),
                  SizedBox(
                    width: 320,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                      child: ringkasan,
                    ),
                  ),
                ],
              );
            }
            // Portrait: ringkasan di bawah daftar.
            return Column(
              children: [
                Expanded(child: daftar),
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxHeight: constraints.maxHeight * 0.5),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ringkasan,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _Kosong extends StatelessWidget {
  const _Kosong();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_bag_outlined,
                size: 48, color: scheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text('Belum ada pesanan', style: text.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Pilih menu di tab Menu lalu tambahkan ke pesanan.',
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _PesananTile extends StatelessWidget {
  const _PesananTile({
    required this.baris,
    required this.onTambah,
    required this.onKurang,
  });

  final BarisPesanan baris;
  final VoidCallback onTambah;
  final VoidCallback onKurang;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final item = baris.item;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.nama,
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              formatRupiah(item.harga),
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.outlined(
                      onPressed: onKurang,
                      icon: const Icon(Icons.remove),
                      visualDensity: VisualDensity.compact,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('${baris.jumlah}', style: text.titleMedium),
                    ),
                    IconButton.outlined(
                      onPressed: onTambah,
                      icon: const Icon(Icons.add),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                Text(
                  formatRupiah(item.harga * baris.jumlah),
                  style: text.titleMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Ringkasan extends StatelessWidget {
  const _Ringkasan({
    required this.jumlah,
    required this.total,
    required this.onPesan,
  });

  final int jumlah;
  final int total;
  final VoidCallback onPesan;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 12,
              runSpacing: 4,
              children: [
                Text('Jumlah item',
                    style: text.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant)),
                Text('$jumlah', style: text.bodyMedium),
              ],
            ),
            const Divider(height: 24),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 12,
              runSpacing: 4,
              children: [
                Text('Total',
                    style: text.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text(
                  formatRupiah(total),
                  style: text.titleMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onPesan, child: const Text('Pesan sekarang')),
          ],
        ),
      ),
    );
  }
}

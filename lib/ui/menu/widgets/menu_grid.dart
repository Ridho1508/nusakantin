import 'package:flutter/material.dart';

import '../../../domain/models/menu_item.dart';
import '../../core/kategori_badge.dart';

/// Grid menu untuk tablet / jendela lebar.
class MenuGrid extends StatelessWidget {
  const MenuGrid({
    super.key,
    required this.items,
    required this.header,
    required this.onTap,
    this.selected,
  });

  final List<MenuItem> items;
  final Widget header;
  final MenuItem? selected;
  final ValueChanged<MenuItem> onTap;

  @override
  Widget build(BuildContext context) {
    // Tinggi kartu mengikuti ukuran teks supaya tidak overflow saat 200%.
    final scale =
        MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 3.0).toDouble();
    final tinggiKartu = 82 + 70 * scale;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxExtent = constraints.maxWidth < 480 ? 190.0 : 230.0;
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              sliver: SliverToBoxAdapter(child: header),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: maxExtent,
                  mainAxisExtent: tinggiKartu,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _MenuCard(
                    item: item,
                    selected: item.id == selected?.id,
                    onTap: () => onTap(item),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final MenuItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? scheme.primary : const Color(0xFFE2E8E5),
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KategoriBadge(kategori: item.kategori, size: 36),
              const SizedBox(height: 10),
              Text(
                item.nama,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                formatRupiah(item.harga),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.titleSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

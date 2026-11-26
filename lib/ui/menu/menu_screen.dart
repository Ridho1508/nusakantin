import 'package:flutter/material.dart';

import '../../domain/models/menu_item.dart';
import '../core/window_size.dart';
import 'menu_view_model.dart';
import 'widgets/menu_detail.dart';
import 'widgets/menu_grid.dart';
import 'widgets/menu_list.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.viewModel});

  final MenuViewModel viewModel;

  void _tambah(BuildContext context, MenuItem item) {
    viewModel.tambah(item);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${item.nama} ditambahkan'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
  }

  void _bukaDetail(BuildContext context, MenuItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetContext) => MenuDetail(
        item: item,
        onTambah: () {
          Navigator.pop(sheetContext);
          _tambah(context, item);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = WindowSize.of(context);

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final header = _KategoriChips(viewModel: viewModel);

        // HP: ListView.builder + detail lewat bottom sheet.
        if (size.isCompact) {
          return MenuList(
            items: viewModel.menuTampil,
            header: header,
            onTap: (item) => _bukaDetail(context, item),
          );
        }

        // Tablet / jendela lebar: grid + panel detail di samping.
        final lebarPanel = size.isExpanded ? 380.0 : 300.0;
        return Row(
          children: [
            Expanded(
              child: MenuGrid(
                items: viewModel.menuTampil,
                header: header,
                selected: viewModel.menuTerpilih,
                onTap: viewModel.pilihMenu,
              ),
            ),
            const VerticalDivider(),
            SizedBox(
              width: lebarPanel,
              child: MenuDetail(
                item: viewModel.menuTerpilih,
                onTambah: () {
                  final menu = viewModel.menuTerpilih;
                  if (menu != null) _tambah(context, menu);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Chip kategori memakai Wrap agar turun baris otomatis (tidak overflow).
class _KategoriChips extends StatelessWidget {
  const _KategoriChips({required this.viewModel});

  final MenuViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final kategori in viewModel.daftarKategori)
          ChoiceChip(
            label: Text(kategori),
            showCheckmark: false,
            selected: kategori == viewModel.kategoriAktif,
            onSelected: (_) => viewModel.pilihKategori(kategori),
          ),
      ],
    );
  }
}

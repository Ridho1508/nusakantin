import 'package:flutter/foundation.dart';

import '../../data/repositories/menu_repository.dart';
import '../../domain/models/menu_item.dart';

typedef BarisPesanan = ({MenuItem item, int jumlah});

class MenuViewModel extends ChangeNotifier {
  MenuViewModel(MenuRepository repository)
      : _items = repository.ambilSemua(),
        daftarKategori = [semua, ...repository.ambilKategori()];

  static const String semua = 'Semua';

  final List<MenuItem> _items;
  final List<String> daftarKategori;
  final Map<int, int> _jumlah = {};

  String _kategoriAktif = semua;
  MenuItem? _menuTerpilih;

  String get kategoriAktif => _kategoriAktif;
  MenuItem? get menuTerpilih => _menuTerpilih;

  List<MenuItem> get menuTampil => _kategoriAktif == semua
      ? List.unmodifiable(_items)
      : _items.where((m) => m.kategori == _kategoriAktif).toList();

  List<BarisPesanan> get pesanan => [
        for (final m in _items)
          if ((_jumlah[m.id] ?? 0) > 0) (item: m, jumlah: _jumlah[m.id]!),
      ];

  int get totalJumlah => _jumlah.values.fold(0, (a, b) => a + b);

  int get totalHarga =>
      pesanan.fold(0, (sum, b) => sum + b.item.harga * b.jumlah);

  void pilihKategori(String kategori) {
    _kategoriAktif = kategori;
    final terpilih = _menuTerpilih;
    if (terpilih != null && kategori != semua && terpilih.kategori != kategori) {
      _menuTerpilih = null;
    }
    notifyListeners();
  }

  void pilihMenu(MenuItem item) {
    _menuTerpilih = item;
    notifyListeners();
  }

  void tambah(MenuItem item) {
    _jumlah[item.id] = (_jumlah[item.id] ?? 0) + 1;
    notifyListeners();
  }

  void kurang(MenuItem item) {
    final sekarang = _jumlah[item.id] ?? 0;
    if (sekarang <= 1) {
      _jumlah.remove(item.id);
    } else {
      _jumlah[item.id] = sekarang - 1;
    }
    notifyListeners();
  }

  void kosongkan() {
    _jumlah.clear();
    notifyListeners();
  }
}

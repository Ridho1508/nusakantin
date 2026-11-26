import '../../domain/models/menu_item.dart';

class MenuRepository {
  const MenuRepository();

  List<MenuItem> ambilSemua() => _data;

  List<String> ambilKategori() {
    final hasil = <String>[];
    for (final m in _data) {
      if (!hasil.contains(m.kategori)) hasil.add(m.kategori);
    }
    return hasil;
  }
}

const List<MenuItem> _data = [
  MenuItem(
    id: 1,
    nama: 'Nasi Goreng Spesial',
    kategori: 'Makanan',
    harga: 18000,
    deskripsi: 'Nasi goreng dengan telur, ayam suwir, dan kerupuk.',
  ),
  MenuItem(
    id: 2,
    nama: 'Ayam Geprek',
    kategori: 'Makanan',
    harga: 17000,
    deskripsi: 'Ayam crispy dengan sambal geprek pedas, nasi hangat, dan lalapan.',
  ),
  MenuItem(
    id: 3,
    nama: 'Mie Ayam Bakso',
    kategori: 'Makanan',
    harga: 15000,
    deskripsi: 'Mie kenyal dengan topping ayam, bakso, dan pangsit.',
  ),
  MenuItem(
    id: 4,
    nama: 'Soto Ayam',
    kategori: 'Makanan',
    harga: 16000,
    deskripsi: 'Soto kuah kuning dengan suwiran ayam, telur, dan soun.',
  ),
  MenuItem(
    id: 5,
    nama: 'Es Teh Manis',
    kategori: 'Minuman',
    harga: 5000,
    deskripsi: 'Teh dingin dengan gula pas, segar di siang hari.',
  ),
  MenuItem(
    id: 6,
    nama: 'Es Jeruk',
    kategori: 'Minuman',
    harga: 7000,
    deskripsi: 'Perasan jeruk segar dengan es batu.',
  ),
  MenuItem(
    id: 7,
    nama: 'Kopi Susu',
    kategori: 'Minuman',
    harga: 12000,
    deskripsi: 'Kopi susu dingin, teman begadang mengerjakan tugas.',
  ),
  MenuItem(
    id: 8,
    nama: 'Jus Alpukat',
    kategori: 'Minuman',
    harga: 14000,
    deskripsi: 'Alpukat blender dengan susu cokelat.',
  ),
  MenuItem(
    id: 9,
    nama: 'Pisang Goreng',
    kategori: 'Camilan',
    harga: 8000,
    deskripsi: 'Pisang goreng tepung renyah, disajikan hangat.',
  ),
  MenuItem(
    id: 10,
    nama: 'Batagor',
    kategori: 'Camilan',
    harga: 12000,
    deskripsi: 'Batagor goreng dengan bumbu kacang dan kecap.',
  ),
  MenuItem(
    id: 11,
    nama: 'Risol Mayo',
    kategori: 'Camilan',
    harga: 6000,
    deskripsi: 'Risol isi sosis, telur, dan mayones.',
  ),
  MenuItem(
    id: 12,
    nama: 'Tahu Crispy',
    kategori: 'Camilan',
    harga: 7000,
    deskripsi: 'Tahu goreng tepung dengan bumbu tabur pedas.',
  ),
];

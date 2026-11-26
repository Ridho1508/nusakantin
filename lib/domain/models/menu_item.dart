class MenuItem {
  const MenuItem({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.deskripsi,
  });

  final int id;
  final String nama;
  final String kategori;
  final int harga;
  final String deskripsi;
}

/// Contoh: 15000 -> "Rp 15.000"
String formatRupiah(int nilai) {
  final s = nilai.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}

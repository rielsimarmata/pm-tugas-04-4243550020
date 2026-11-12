import 'dart:async';

import 'kendaraan.dart';

/// Exception kustom: dilempar saat parkiran sudah penuh.
class ParkirPenuh implements Exception {
  final int kapasitas;
  ParkirPenuh(this.kapasitas);

  @override
  String toString() => 'Parkiran penuh (kapasitas $kapasitas)';
}

/// Exception kustom: kendaraan tidak ada / sudah ada di parkiran.
class ParkirGagal implements Exception {
  final String alasan;
  ParkirGagal(this.alasan);

  @override
  String toString() => alasan;
}

class Parkiran {
  final int kapasitas;

  // Enkapsulasi: data tidak bisa diubah langsung dari luar.
  final Map<String, Kendaraan> _kendaraan = {};
  int _pendapatan = 0;

  // Semua kejadian dipancarkan lewat Stream broadcast.
  final StreamController<String> _log = StreamController<String>.broadcast();

  Parkiran(this.kapasitas);

  Stream<String> get log => _log.stream;
  int get sisa => kapasitas - _kendaraan.length;
  int get pendapatan => _pendapatan;

  /// Kendaraan masuk. Palang disimulasikan dengan Future.delayed.
  Future<void> masuk(Kendaraan k) async {
    await Future.delayed(const Duration(milliseconds: 300)); // palang terbuka
    if (_kendaraan.containsKey(k.plat)) {
      throw ParkirGagal('${k.plat} sudah ada di dalam parkiran');
    }
    if (sisa <= 0) throw ParkirPenuh(kapasitas);
    _kendaraan[k.plat] = k;
    _log.add('MASUK ${k.label} (sisa $sisa)');
  }

  /// Kendaraan keluar; mengembalikan biaya yang dibayar.
  Future<int> keluar(String plat, DateTime waktuKeluar) async {
    await Future.delayed(const Duration(milliseconds: 300)); // palang terbuka
    final k = _kendaraan[plat];
    if (k == null) throw ParkirGagal('Kendaraan $plat tidak ditemukan');
    final bayar = k.biaya(waktuKeluar);
    _kendaraan.remove(plat);
    _pendapatan += bayar;
    _log.add('KELUAR ${k.label} bayar Rp$bayar');
    return bayar;
  }

  Future<void> tutup() => _log.close();
}

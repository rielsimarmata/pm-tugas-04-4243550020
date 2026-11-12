// Model kendaraan untuk Sistem Parkir Kampus FMIPA.

/// Kerangka semua kendaraan. Tidak dapat dibuat objeknya langsung.
abstract class Kendaraan {
  final String plat;
  final DateTime waktuMasuk;

  Kendaraan(this.plat, this.waktuMasuk);

  /// Abstrak: wajib diimplementasikan subclass.
  String get jenis;
  int get tarifPerJam;

  /// Biaya parkir: dibulatkan ke atas per jam, minimal 1 jam.
  int biaya(DateTime keluar) {
    final menit = keluar.difference(waktuMasuk).inMinutes;
    var jam = (menit + 59) ~/ 60; // pembulatan ke atas
    if (jam < 1) jam = 1;
    return jam * tarifPerJam;
  }

  String get label => '$jenis $plat';

  @override
  String toString() => label;
}

class Motor extends Kendaraan {
  Motor(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Motor';

  @override
  int get tarifPerJam => 2000;
}

class Mobil extends Kendaraan {
  Mobil(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Mobil';

  @override
  int get tarifPerJam => 5000;
}

class Truk extends Kendaraan {
  Truk(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Truk';

  @override
  int get tarifPerJam => 10000;
}

/// Mixin: kendaraan berlangganan (member) mendapat diskon 50%.
mixin Berlangganan on Kendaraan {
  static const double diskon = 0.5;

  @override
  String get jenis => '${super.jenis} (member)';

  @override
  int biaya(DateTime keluar) =>
      (super.biaya(keluar) * (1 - diskon)).round();
}

/// Mobil member = Mobil + perilaku Berlangganan.
class MobilMember extends Mobil with Berlangganan {
  MobilMember(super.plat, super.waktuMasuk);
}


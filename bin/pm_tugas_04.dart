import 'package:pm_tugas_04/kendaraan.dart';
import 'package:pm_tugas_04/parkiran.dart';

Future<void> main() async {
  final parkiran = Parkiran(3);

  // Layar pos jaga: listener Stream.
  parkiran.log.listen((kejadian) => print(kejadian));

  final masuk = DateTime(2026, 11, 12, 8, 0);
  final keluar = DateTime(2026, 11, 12, 10, 30); // 2,5 jam -> dibulatkan 3 jam

  // Polimorfisme: satu List berisi berbagai jenis kendaraan.
  final List<Kendaraan> antrean = [
    Motor('BK 1234 AB', masuk),
    Mobil('BK 88 UN', masuk),
    MobilMember('BK 7 MIPA', masuk),
    Truk('BK 9999 XY', masuk), // seharusnya ditolak (penuh)
  ];

  for (final k in antrean) {
    try {
      await parkiran.masuk(k);
    } on ParkirPenuh catch (e) {
      print('Ditolak: $e');
    } on ParkirGagal catch (e) {
      print('Ditolak: $e');
    }
  }

  // Semua kendaraan yang masuk keluar kembali.
  for (final k in antrean) {
    try {
      await parkiran.keluar(k.plat, keluar);
    } on ParkirGagal {
      // Truk tidak pernah masuk, jadi dilewati.
    }
  }

  print('Pendapatan: Rp${parkiran.pendapatan}');
  await parkiran.tutup();
}

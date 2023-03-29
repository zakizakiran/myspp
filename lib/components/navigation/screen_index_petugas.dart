import 'package:flutter/cupertino.dart';
import 'package:myspp_app/pages/home/admin_settings.dart';
import 'package:myspp_app/pages/home/petugas_home.dart';
import 'package:myspp_app/pages/pembayaran/data_pembayaran_petugas.dart';
import 'package:myspp_app/pages/riwayat/riwayat_pembayaran.dart';

List<Widget> screensPetugas() {
  return [
    const PetugasHome(),
    const DataPembayaranPetugas(),
    const RiwayatPembayaran(),
    const AdminSettings(),
  ];
}

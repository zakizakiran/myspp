import 'package:flutter/cupertino.dart';
import 'package:myspp_app/pages/home/admin_home.dart';
import 'package:myspp_app/pages/home/admin_settings.dart';
import 'package:myspp_app/pages/pembayaran/data_pembayaran.dart';
import 'package:myspp_app/pages/riwayat/riwayat_pembayaran.dart';

List<Widget> screensAdmin() {
  return [
    const AdminHome(),
    const DataPembayaran(),
    const RiwayatPembayaran(),
    const AdminSettings(),
  ];
}

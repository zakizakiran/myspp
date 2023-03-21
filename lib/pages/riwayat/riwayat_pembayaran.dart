import 'package:flutter/material.dart';

class RiwayatPembayaran extends StatefulWidget {
  const RiwayatPembayaran({super.key});

  @override
  State<RiwayatPembayaran> createState() => _RiwayatPembayaranState();
}

class _RiwayatPembayaranState extends State<RiwayatPembayaran> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Riwayat Pembayaran'),
    ));
  }
}

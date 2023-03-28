import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:myspp_app/model/pembayaran.dart';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';

class LaporanPembayaran {
  Future<String> convertDataToCSV(List<Pembayaran> data) async {
    List<List<dynamic>> rows = [];
    // Tambahkan header CSV
    rows.add([
      "Nama Siswa",
      "NISN",
      "Tagihan",
      "Bulan Bayar",
      "Tahun Bayar",
      "Tanggal Transaksi",
      ""
    ]);

    // Tambahkan baris data model ke dalam CSV
    for (Pembayaran model in data) {
      rows.add([
        model.namaSiswa,
        model.nisn,
        model.jmlTagihan,
        model.bulanBayar,
        model.tahunBayar,
        model.tglTransaksi,
      ]);
    }
    // Konversi rows menjadi format CSV menggunakan flutter_csv
    String csv = const ListToCsvConverter().convert(rows);
    return csv;
  }

  Future<void> saveDataToCSV(
      BuildContext context, List<Pembayaran> data, String fileName) async {
    // Konversi data ke dalam format CSV
    String csv = await convertDataToCSV(data);

    // Dapatkan direktori penyimpanan lokal
    Directory? directory = await getExternalStorageDirectory();

    // Buat file CSV
    String files = fileName;
    String filePath = "${directory!.path}/$files";
    File file = File(filePath);

    // Tulis data CSV ke dalam file
    await file.writeAsString(csv);
    await OpenDocument.openDocument(filePath: filePath);

    Logger().i("File CSV berhasil disimpan di $filePath");
  }
}

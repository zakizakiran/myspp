import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:myspp_app/model/pembayaran.dart';
import 'package:open_document/my_files/init.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CustomRow {
  final String namaSiswa;
  final String nisn;
  final String jmlBayar;
  final String bulanBayar;
  final String tahunBayar;
  final String tglTransaksi;
  final String status;

  CustomRow(this.namaSiswa, this.nisn, this.jmlBayar, this.bulanBayar,
      this.tahunBayar, this.tglTransaksi, this.status);
}

class PdfInvoiceService {
  Future<Uint8List> createinvoice({required Pembayaran pembayaran}) async {
    final pdf = pw.Document();
    final List<CustomRow> elements = [
      CustomRow("Nama Siswa", "NISN", "Total Bayar", "Bulan Bayar", "Tahun",
          "Status", ""),
      CustomRow(
          pembayaran.namaSiswa.toString(),
          pembayaran.nisn.toString(),
          NumberFormat.simpleCurrency(locale: 'id', name: 'Rp.')
              .format(pembayaran.jmlBayar),
          pembayaran.bulanBayar.toString(),
          pembayaran.tahunBayar.toString(),
          "",
          pembayaran.jmlBayar.toString()),
      CustomRow("", "", "", "", "", "", ""),
      CustomRow("Petugas", "", "", "", "", "", ""),
      CustomRow(
        pembayaran.namaPetugas.toString(),
        "",
        "",
        "",
        "",
        "",
        "",
      )
      //
    ];

    final image =
        (await rootBundle.load('assets/img/logo.png')).buffer.asUint8List();

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(pw.MemoryImage(image),
                      width: 200, height: 200, fit: pw.BoxFit.cover),
                ],
              ),
              pw.SizedBox(height: 50.0),
              pw.Text('Bukti Pembayaran SPP',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18.0,
                  )),
              pw.SizedBox(height: 16.0),
              pw.Text(
                'Hari / Tanggal Cetak :   ${DateFormat.yMMMMEEEEd('id').format(DateTime.now())}',
              ),
              pw.SizedBox(height: 10.0),
              pw.Text(
                'Tanggal Transaksi    :   ${DateFormat.yMMMMEEEEd('id').format(DateTime.tryParse(pembayaran.tglTransaksi.toString())!)}',
              ),
              pw.SizedBox(height: 10.0),
              pembayaran.jmlBayar! >= pembayaran.jmlTagihan!.toInt()
                  ? pw.Text('Status Pembayaran  :   Lunas')
                  : pw.Text('Status Pembayaran  :   Belum Lunas'),
              pw.SizedBox(height: 50.0),
              pw.Row(
                children: [
                  itemColumn(elements),
                ],
              ),
              pw.SizedBox(height: 100),
              pw.Center(
                child: pw.Text(
                    "***  Terimakasih Atas Kepercayaan Anda Kepada Kami  ***",
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              )
            ]);
      },
    ));
    return pdf.save();
  }

  pw.Expanded itemColumn(List<CustomRow> elements) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          for (var element in elements)
            pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                      pw.Text(
                        element.namaSiswa,
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(height: 20.0)
                    ])),
                pw.Expanded(
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        element.nisn,
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(height: 20.0)
                    ])),
                pw.Expanded(
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        element.jmlBayar,
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(height: 20.0)
                    ])),
                pw.Expanded(
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        element.bulanBayar,
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(height: 20.0)
                    ])),
                pw.Expanded(
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        element.tahunBayar,
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(height: 20.0)
                    ])),
              ],
            )
        ],
      ),
    );
  }

  Future<void> savePdfFile(
      BuildContext context, String fileName, Uint8List byteList) async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                backgroundColor: HexColor('204FA1'),
              ),
            ));
    var appDrect = (await getExternalStorageDirectory())?.path;
    var filePath = "${appDrect!}/$fileName";
    Logger().i(filePath);
    final file = File(filePath);
    await file.writeAsBytes(byteList, flush: true);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    await OpenDocument.openDocument(filePath: filePath);
  }
}

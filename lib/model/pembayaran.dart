class Pembayaran {
  String? pid;
  String? namaSiswa;
  String? nisn;
  String? emailSiswa;
  String? namaPetugas;
  DateTime? tglTransaksi;
  DateTime? tglDibuat;
  String? bulanBayar;
  int? tahunBayar;
  int? jmlBayar;
  int? jmlTagihan;

  Pembayaran(
      {this.pid,
      this.namaSiswa,
      this.nisn,
      this.emailSiswa,
      this.namaPetugas,
      this.tglTransaksi,
      this.tglDibuat,
      this.bulanBayar,
      this.tahunBayar,
      this.jmlBayar,
      this.jmlTagihan});

  factory Pembayaran.fromJson(Map<String, dynamic> json) {
    return Pembayaran(
        pid: json['pid'],
        namaSiswa: json['nama_siswa'],
        nisn: json['nisn'],
        emailSiswa: json['email_siswa'],
        namaPetugas: json['nama_petugas'],
        tglTransaksi:
            DateTime.tryParse(json['tgl_transaksi'].toDate().toString()),
        tglDibuat: DateTime.tryParse(json['tgl_dibuat'].toDate().toString()),
        bulanBayar: json['bln_bayar'],
        tahunBayar: json['thn_bayar'],
        jmlBayar: json['jml_bayar'],
        jmlTagihan: json['jml_tagihan']);
  }

  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'nama_siswa': namaSiswa,
      'nisn': nisn,
      'email_siswa': emailSiswa,
      'nama_petugas': namaPetugas,
      'tgl_transaksi': tglTransaksi,
      'tgl_dibuat': tglDibuat,
      'bln_bayar': bulanBayar,
      'thn_bayar': tahunBayar,
      'jml_bayar': jmlBayar,
      'jml_tagihan': jmlTagihan,
    };
  }

  Pembayaran copyWith({
    String? pid,
    String? namaSiswa,
    String? nisn,
    String? emailSiswa,
    String? namaPetugas,
    DateTime? tglTransaksi,
    DateTime? tglDibuat,
    String? bulanBayar,
    int? tahunBayar,
    int? jmlBayar,
    int? jmlTagihan,
  }) {
    return Pembayaran(
        pid: pid ?? this.pid,
        namaSiswa: namaSiswa ?? this.namaSiswa,
        nisn: nisn ?? this.nisn,
        emailSiswa: emailSiswa ?? this.emailSiswa,
        namaPetugas: namaPetugas ?? this.namaPetugas,
        tglTransaksi: tglTransaksi ?? this.tglTransaksi,
        tglDibuat: tglDibuat ?? this.tglDibuat,
        bulanBayar: bulanBayar ?? this.bulanBayar,
        tahunBayar: tahunBayar ?? this.tahunBayar,
        jmlBayar: jmlBayar ?? this.jmlBayar,
        jmlTagihan: jmlTagihan ?? this.jmlTagihan);
  }
}

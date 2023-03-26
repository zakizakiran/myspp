class Pembayaran {
  String? pid;
  String? namaSiswa;
  String? nisn;
  String? emailSiswa;
  String? namaPetugas;
  DateTime? tglTransaksi;
  String? bulanBayar;
  int? tahunBayar;
  int? jmlBayar;

  Pembayaran(
      {this.pid,
      this.namaSiswa,
      this.nisn,
      this.emailSiswa,
      this.namaPetugas,
      this.tglTransaksi,
      this.bulanBayar,
      this.tahunBayar,
      this.jmlBayar});

  factory Pembayaran.fromJson(Map<String, dynamic> json) {
    return Pembayaran(
        pid: json['pid'],
        namaSiswa: json['nama_siswa'],
        nisn: json['nisn'],
        emailSiswa: json['email_siswa'],
        namaPetugas: json['nama_petugas'],
        tglTransaksi:
            DateTime.tryParse(json['tgl_transaksi'].toDate().toString()),
        bulanBayar: json['bln_bayar'],
        tahunBayar: json['thn_bayar'],
        jmlBayar: json['jml_bayar']);
  }

  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'nama_siswa': namaSiswa,
      'nisn': nisn,
      'email_siswa': emailSiswa,
      'nama_petugas': namaPetugas,
      'tgl_transaksi': tglTransaksi,
      'bln_bayar': bulanBayar,
      'thn_bayar': tahunBayar,
      'jml_bayar': jmlBayar,
    };
  }

  Pembayaran copyWith({
    String? pid,
    String? namaSiswa,
    String? nisn,
    String? emailSiswa,
    String? namaPetugas,
    DateTime? tglTransaksi,
    String? bulanBayar,
    int? tahunBayar,
    int? jmlBayar,
  }) {
    return Pembayaran(
        pid: pid ?? this.pid,
        namaSiswa: namaSiswa ?? this.namaSiswa,
        nisn: nisn ?? this.nisn,
        emailSiswa: emailSiswa ?? this.emailSiswa,
        namaPetugas: namaPetugas ?? this.namaPetugas,
        tglTransaksi: tglTransaksi ?? this.tglTransaksi,
        bulanBayar: bulanBayar ?? this.bulanBayar,
        tahunBayar: tahunBayar ?? this.tahunBayar,
        jmlBayar: jmlBayar ?? this.jmlBayar);
  }
}

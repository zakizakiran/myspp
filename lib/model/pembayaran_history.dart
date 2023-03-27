class PembayaranHistory {
  String? idHistoryPembayaran;
  String? idPembayaran;
  String? emailSiswa;
  String? namaSiswa;
  String? nisn;
  int? jmlBayar;
  DateTime? tgl;

  PembayaranHistory({
    this.idHistoryPembayaran,
    this.idPembayaran,
    this.emailSiswa,
    this.namaSiswa,
    this.nisn,
    this.jmlBayar,
    this.tgl,
  });

  factory PembayaranHistory.fromJson(Map<String, dynamic> json) {
    return PembayaranHistory(
      idHistoryPembayaran: json['id_history_pembayaran'],
      idPembayaran: json['id_pembayaran'],
      emailSiswa: json['email_siswa'],
      namaSiswa: json['nama_siswa'],
      nisn: json['nisn'],
      jmlBayar: json['jml_bayar'],
      tgl: DateTime.tryParse(json['tgl'].toDate().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_history_pembayaran': idHistoryPembayaran,
      'id_pembayaran': idPembayaran,
      'email_siswa': emailSiswa,
      'nama_siswa': namaSiswa,
      'nisn': nisn,
      'jml_bayar': jmlBayar,
      'tgl': tgl,
    };
  }

  PembayaranHistory copyWith({
    String? idHistoryPembayaran,
    String? idPembayaran,
    String? emailSiswa,
    String? namaSiswa,
    String? nisn,
    int? jmlBayar,
    DateTime? tgl,
  }) {
    return PembayaranHistory(
      idHistoryPembayaran: idHistoryPembayaran ?? this.idHistoryPembayaran,
      idPembayaran: idPembayaran ?? this.idPembayaran,
      emailSiswa: emailSiswa ?? this.emailSiswa,
      namaSiswa: namaSiswa ?? this.namaSiswa,
      nisn: nisn ?? this.nisn,
      jmlBayar: jmlBayar ?? this.jmlBayar,
      tgl: tgl ?? this.tgl,
    );
  }
}

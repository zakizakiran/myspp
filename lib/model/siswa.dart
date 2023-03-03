class Siswa {
  String? sid;
  String? nama;
  String? nis;
  String? nisn;
  String? kelas;
  String? telp;
  String? alamat;

  Siswa({
    this.sid,
    this.nama,
    this.nis,
    this.nisn,
    this.kelas,
    this.telp,
    this.alamat,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
        sid: json['sid'],
        nama: json['nama'],
        nis: json['nis'],
        nisn: json['nisn'],
        kelas: json['kelas'],
        alamat: json['alamat'],
        telp: json['telp']);
  }

  Map<String, dynamic> toJson() {
    return {
      'sid': sid,
      'nama': nama,
      'nis': nis,
      'nisn': nisn,
      'kelas': kelas,
      'telp': telp,
      'alamat': alamat,
    };
  }

  Siswa copyWith({
    String? sid,
    String? nama,
    String? nis,
    String? nisn,
    String? kelas,
    String? telp,
    String? alamat,
  }) {
    return Siswa(
      sid: sid ?? this.sid,
      nama: nama ?? this.nama,
      nis: nis ?? this.nis,
      nisn: nisn ?? this.nisn,
      kelas: kelas ?? this.kelas,
      telp: telp ?? this.telp,
      alamat: alamat ?? this.alamat,
    );
  }
}

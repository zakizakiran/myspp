class Users {
  String? uid;
  String? nama;
  String? nis;
  String? nisn;
  String? email;
  String? kelas;
  String? role;
  String? telp;
  String? alamat;

  Users({
    this.uid,
    this.nama,
    this.nis,
    this.nisn,
    this.email,
    this.kelas,
    this.telp,
    this.alamat,
    this.role,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uid: json['uid'],
      nama: json['nama'],
      nis: json['nis'],
      nisn: json['nisn'],
      email: json['email'],
      kelas: json['kelas'],
      alamat: json['alamat'],
      role: json['role'],
      telp: json['telp']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nama': nama,
      'nis': nis,
      'nisn': nisn,
      'email': email,
      'kelas': kelas,
      'telp' : telp,
      'alamat' : alamat,
      'role': role,
    };
  }

  Users copyWith({
    String? uid,
    String? nama,
    String? nis,
    String? nisn,
    String? email,
    String? kelas,
    String? telp,
    String? alamat,
    String? role,
  }) {
    return Users(
      uid: uid ?? this.uid,
      nama: nama ?? this.nama,
      nis: nis ?? this.nis,
      nisn: nisn ?? this.nisn,
      email: email ?? this.email,
      kelas: kelas ?? this.kelas,
      telp: telp ?? this.telp,
      alamat: alamat ?? this.alamat,
      role: role ?? this.role,
    );
  }
}

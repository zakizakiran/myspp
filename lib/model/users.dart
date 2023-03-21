class Users {
  String? uid;
  String? nama;
  String? email;
  String? level;
  String? telp;
  String? alamat;

  Users({
    this.uid,
    this.nama,
    this.email,
    this.alamat,
    this.level,
    this.telp,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uid: json['uid'],
      nama: json['nama'],
      email: json['email'],
      alamat: json['alamat'],
      level: json['level'],
      telp: json['telp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nama': nama,
      'email': email,
      'alamat': alamat,
      'level': level,
      'telp': telp,
    };
  }

  Users copyWith({
    String? uid,
    String? nama,
    String? email,
    String? level,
    String? telp,
    String? alamat,
  }) {
    return Users(
      uid: uid ?? this.uid,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      level: level ?? this.level,
      telp: telp ?? this.telp,
      alamat: alamat ?? this.alamat,
    );
  }
}

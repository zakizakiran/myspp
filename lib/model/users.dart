class Users {
  String? uid;
  String? name;
  String? nis;
  String? email;
  String? photoUrl;
  String? about;
  String? grade;
  String? role;

  Users({
    this.uid,
    this.name,
    this.nis,
    this.email,
    this.photoUrl,
    this.about,
    this.grade,
    this.role,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uid: json['uid'],
      name: json['name'],
      nis: json['nis'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      about: json['about'],
      grade: json['grade'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'nis': nis,
      'email': email,
      'photoUrl': photoUrl,
      'about': about,
      'grade': grade,
      'role': role,
    };
  }

  Users copyWith({
    String? uid,
    String? name,
    String? nis,
    String? email,
    String? photoUrl,
    String? about,
    String? grade,
    String? role,
  }) {
    return Users(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      nis: nis ?? this.nis,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      about: about ?? this.about,
      grade: grade ?? this.grade,
      role: role ?? this.role,
    );
  }
}

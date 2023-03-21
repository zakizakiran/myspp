class LogHistory {
  String? logId;
  String? email;
  String? aktivitas;
  DateTime? tgl;

  LogHistory({
    this.logId,
    this.email,
    this.aktivitas,
    this.tgl,
  });

  factory LogHistory.fromJson(Map<String, dynamic> json) {
    return LogHistory(
      logId: json['logId'],
      email: json['email'],
      aktivitas: json['aktivitas'],
      tgl: DateTime.tryParse(json['tgl'].toDate().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logId': logId,
      'email': email,
      'aktivitas': aktivitas,
      'tgl': tgl,
    };
  }

  LogHistory copyWith({
    String? logId,
    String? email,
    String? aktivitas,
    DateTime? tgl,
  }) {
    return LogHistory(
        logId: logId ?? this.logId,
        email: email ?? this.email,
        aktivitas: aktivitas ?? this.aktivitas,
        tgl: tgl ?? this.tgl);
  }
}

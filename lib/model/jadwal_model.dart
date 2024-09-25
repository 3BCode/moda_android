class JadwalModel {
  final int? id;
  final int? userId;
  final int? loketId;
  final int? hariId;
  final int? sopirId;
  final int? kabasalId;
  final int? kabtujuanId;
  final String? harga;
  final String? waktu;
  final String? statusJadwal;
  final String? createdAt;
  final String? updatedAt;
  final String? user;
  final String? loket;
  final String? sopirNama;
  final String? angkutanNama;
  final String? angkutanPlat;
  final String? hariNama;
  final String? kabAsal;
  final String? kabTujuan;

  JadwalModel({
    this.id,
    this.userId,
    this.loketId,
    this.hariId,
    this.sopirId,
    this.kabasalId,
    this.kabtujuanId,
    this.harga,
    this.waktu,
    this.statusJadwal,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.loket,
    this.sopirNama,
    this.angkutanNama,
    this.angkutanPlat,
    this.hariNama,
    this.kabAsal,
    this.kabTujuan,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()),
      loketId: json['loket_id'] is int
          ? json['loket_id']
          : int.tryParse(json['loket_id'].toString()),
      hariId: json['hari_id'] is int
          ? json['hari_id']
          : int.tryParse(json['hari_id'].toString()),
      sopirId: json['sopir_id'] is int
          ? json['sopir_id']
          : int.tryParse(json['sopir_id'].toString()),
      kabasalId: json['kabasal_id'] is int
          ? json['kabasal_id']
          : int.tryParse(json['kabasal_id'].toString()),
      kabtujuanId: json['kabtujuan_id'] is int
          ? json['kabtujuan_id']
          : int.tryParse(json['kabtujuan_id'].toString()),
      harga: json['harga']?.toString(),
      waktu: json['waktu'] as String?,
      statusJadwal: json['status_jadwal'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] as String?,
      loket: json['loket'] as String?,
      sopirNama: json['sopir_nama'] as String?,
      angkutanNama: json['angkutan_nama'] as String?,
      angkutanPlat: json['angkutan_plat'] as String?,
      hariNama: json['hari_nama'] as String?,
      kabAsal: json['kab_asal'] as String?,
      kabTujuan: json['kab_tujuan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (loketId != null) 'loket_id': loketId,
      if (hariId != null) 'hari_id': hariId,
      if (sopirId != null) 'sopir_id': sopirId,
      if (kabasalId != null) 'kabasal_id': kabasalId,
      if (kabtujuanId != null) 'kabtujuan_id': kabtujuanId,
      if (harga != null) 'harga': harga,
      if (waktu != null) 'waktu': waktu,
      if (statusJadwal != null) 'status_jadwal': statusJadwal,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (user != null) 'user': user,
      if (loket != null) 'loket': loket,
      if (sopirNama != null) 'sopir_nama': sopirNama,
      if (angkutanNama != null) 'angkutan_nama': angkutanNama,
      if (angkutanPlat != null) 'angkutan_plat': angkutanPlat,
      if (hariNama != null) 'hari_nama': hariNama,
      if (kabAsal != null) 'kab_asal': kabAsal,
      if (kabTujuan != null) 'kab_tujuan': kabTujuan,
    };
  }
}

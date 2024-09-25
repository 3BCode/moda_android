class SopirModel {
  final int? id;
  final int? userId;
  final int? loketId;
  final int? angkutanId;
  final String? nik;
  final String? nama;
  final String? alamat;
  final String? noHp;
  final String? createdAt;
  final String? updatedAt;
  final String? user;
  final String? loket;
  final String? angkutanNama;
  final String? angkutanPlat;
  final String? angkutanKapasitas;

  SopirModel({
    this.id,
    this.userId,
    this.loketId,
    this.angkutanId,
    this.nik,
    this.nama,
    this.alamat,
    this.noHp,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.loket,
    this.angkutanNama,
    this.angkutanPlat,
    this.angkutanKapasitas,
  });

  factory SopirModel.fromJson(Map<String, dynamic> json) {
    return SopirModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()),
      loketId: json['loket_id'] is int
          ? json['loket_id']
          : int.tryParse(json['loket_id'].toString()),
      angkutanId: json['angkutan_id'] is int
          ? json['angkutan_id']
          : int.tryParse(json['angkutan_id'].toString()),
      nik: json['nik'] as String?,
      nama: json['nama'] as String?,
      alamat: json['alamat'] as String?,
      noHp: json['no_hp'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] as String?,
      loket: json['loket'] as String?,
      angkutanNama: json['angkutan_nama'] as String?,
      angkutanPlat: json['angkutan_plat'] as String?,
      angkutanKapasitas: json['angkutan_kapasitas']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (loketId != null) 'loket_id': loketId,
      if (angkutanId != null) 'angkutan_id': angkutanId,
      if (nik != null) 'nik': nik,
      if (nama != null) 'nama': nama,
      if (alamat != null) 'alamat': alamat,
      if (noHp != null) 'no_hp': noHp,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (user != null) 'user': user,
      if (loket != null) 'loket': loket,
      if (angkutanNama != null) 'angkutan_nama': angkutanNama,
      if (angkutanPlat != null) 'angkutan_plat': angkutanPlat,
      if (angkutanKapasitas != null) 'angkutan_kapasitas': angkutanKapasitas,
    };
  }
}

class AngkutanModel {
  final int? id;
  final int? userId;
  final int? loketId;
  final int? tipeangkutanId;
  final String? nama;
  final String? plat;
  final String? kapasitas;
  final String? createdAt;
  final String? updatedAt;
  final String? user;
  final String? loket;
  final String? tipeangkutan;

  AngkutanModel({
    this.id,
    this.userId,
    this.loketId,
    this.tipeangkutanId,
    this.nama,
    this.plat,
    this.kapasitas,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.loket,
    this.tipeangkutan,
  });

  factory AngkutanModel.fromJson(Map<String, dynamic> json) {
    return AngkutanModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()),
      loketId: json['loket_id'] is int
          ? json['loket_id']
          : int.tryParse(json['loket_id'].toString()),
      tipeangkutanId: json['tipeangkutan_id'] is int
          ? json['tipeangkutan_id']
          : int.tryParse(json['tipeangkutan_id'].toString()),
      nama: json['nama'] as String?,
      plat: json['plat'] as String?,
      kapasitas: json['kapasitas']?.toString(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] as String?,
      loket: json['loket'] as String?,
      tipeangkutan: json['tipeangkutan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (loketId != null) 'loket_id': loketId,
      if (tipeangkutanId != null) 'tipeangkutan_id': tipeangkutanId,
      if (nama != null) 'nama': nama,
      if (plat != null) 'plat': plat,
      if (kapasitas != null) 'kapasitas': kapasitas,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (user != null) 'user': user,
      if (loket != null) 'loket': loket,
      if (tipeangkutan != null) 'tipeangkutan': tipeangkutan,
    };
  }
}

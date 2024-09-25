class PelangganModel {
  final int? id;
  final String? nmPenumpang;
  final String? noHp;
  final int? userId;
  final int? loketId;
  final String? createdAt;
  final String? updatedAt;
  final String? user;
  final String? loket;

  PelangganModel({
    this.id,
    this.nmPenumpang,
    this.noHp,
    this.userId,
    this.loketId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.loket,
  });

  factory PelangganModel.fromJson(Map<String, dynamic> json) {
    return PelangganModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      nmPenumpang: json['nm_penumpang'] as String?,
      noHp: json['no_hp'] as String?,
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()),
      loketId: json['loket_id'] is int
          ? json['loket_id']
          : int.tryParse(json['loket_id'].toString()),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] as String?,
      loket: json['loket'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (nmPenumpang != null) 'nm_penumpang': nmPenumpang,
      if (noHp != null) 'no_hp': noHp,
      if (userId != null) 'user_id': userId,
      if (loketId != null) 'loket_id': loketId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (user != null) 'user': user,
      if (loket != null) 'loket': loket,
    };
  }
}

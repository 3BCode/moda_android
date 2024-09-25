class UserModel {
  final int? id;
  final int? loketId;
  final String? name;
  final String? namaLoket;
  final String? noHp;
  final String? fileLoket;
  final String? alamat;
  final String? email;
  final String? emailVerifiedAt;
  final String? role;
  final String? foto;
  final String? level;
  final int? isVerified;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    this.loketId,
    this.name,
    this.namaLoket,
    this.noHp,
    this.fileLoket,
    this.alamat,
    this.email,
    this.emailVerifiedAt,
    this.role,
    this.foto,
    this.level,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      loketId: json['loket_id'],
      name: json['name'],
      namaLoket: json['nama_loket'],
      noHp: json['no_hp'],
      fileLoket: json['file_loket'],
      alamat: json['alamat'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      role: json['role'],
      foto: json['foto'],
      level: json['level'],
      isVerified: json['is_verified'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loket_id': loketId,
      'name': name,
      'nama_loket': namaLoket,
      'no_hp': noHp,
      'file_loket': fileLoket,
      'alamat': alamat,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'role': role,
      'foto': foto,
      'level': level,
      'is_verified': isVerified,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

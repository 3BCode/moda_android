class UserModel {
  final String? id;
  final String? nama;
  final String? namaLoket;
  final String? alamat;
  final String? noHP;
  final String? email;
  final String? level;
  final String? status;
  final String? gambar;
  final String? createdDate;

  UserModel({
    this.id,
    this.nama,
    this.namaLoket,
    this.alamat,
    this.noHP,
    this.email,
    this.level,
    this.status,
    this.gambar,
    this.createdDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nama: json['nama'],
      namaLoket: json['namaLoket'],
      alamat: json['alamat'],
      noHP: json['noHP'],
      email: json['email'],
      level: json['level'],
      status: json['status'],
      gambar: json['gambar'],
      createdDate: json['createdDate'],
    );
  }
}

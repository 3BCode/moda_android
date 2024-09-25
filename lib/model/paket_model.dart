class PaketModel {
  final int? id;
  final int? userId;
  final int? loketId;
  final int? jadwalId;
  final int? penumpangId;
  final String? noPaket;
  final String? isiPaket;
  final String? keterangan;
  final String? nmPenerima;
  final String? noHpPenerima;
  final String? jmlBayar;
  final String? statusPaket;
  final String? createdAt;
  final String? updatedAt;
  final String? user;
  final String? loket;
  final String? nmPenumpang;
  final String? noHp;
  final String? kabAsal;
  final String? kabTujuan;
  final String? sopirNama;
  final String? angkutanNama;
  final String? angkutanPlat;

  PaketModel({
    this.id,
    this.userId,
    this.loketId,
    this.jadwalId,
    this.penumpangId,
    this.noPaket,
    this.isiPaket,
    this.keterangan,
    this.nmPenerima,
    this.noHpPenerima,
    this.jmlBayar,
    this.statusPaket,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.loket,
    this.nmPenumpang,
    this.noHp,
    this.kabAsal,
    this.kabTujuan,
    this.sopirNama,
    this.angkutanNama,
    this.angkutanPlat,
  });

  factory PaketModel.fromJson(Map<String, dynamic> json) {
    return PaketModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()),
      loketId: json['loket_id'] is int
          ? json['loket_id']
          : int.tryParse(json['loket_id'].toString()),
      jadwalId: json['jadwal_id'] is int
          ? json['jadwal_id']
          : int.tryParse(json['jadwal_id'].toString()),
      penumpangId: json['penumpang_id'] is int
          ? json['penumpang_id']
          : int.tryParse(json['penumpang_id'].toString()),
      noPaket: json['no_paket'] as String?,
      isiPaket: json['isi_paket'] as String?,
      keterangan: json['keterangan'] as String?,
      nmPenerima: json['nm_penerima'] as String?,
      noHpPenerima: json['no_hp_penerima'] as String?,
      jmlBayar: json['jml_bayar'] as String?,
      statusPaket: json['status_paket'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] as String?,
      loket: json['loket'] as String?,
      nmPenumpang: json['nm_penumpang'] as String?,
      noHp: json['no_hp'] as String?,
      kabAsal: json['kab_asal'] as String?,
      kabTujuan: json['kab_tujuan'] as String?,
      sopirNama: json['sopir_nama'] as String?,
      angkutanNama: json['angkutan_nama'] as String?,
      angkutanPlat: json['angkutan_plat'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (loketId != null) 'loket_id': loketId,
      if (jadwalId != null) 'jadwal_id': jadwalId,
      if (penumpangId != null) 'penumpang_id': penumpangId,
      if (noPaket != null) 'no_paket': noPaket,
      if (isiPaket != null) 'isi_paket': isiPaket,
      if (keterangan != null) 'keterangan': keterangan,
      if (nmPenerima != null) 'nm_penerima': nmPenerima,
      if (noHpPenerima != null) 'no_hp_penerima': noHpPenerima,
      if (jmlBayar != null) 'jml_bayar': jmlBayar,
      if (statusPaket != null) 'status_paket': statusPaket,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (user != null) 'user': user,
      if (loket != null) 'loket': loket,
      if (nmPenumpang != null) 'nm_penumpang': nmPenumpang,
      if (noHp != null) 'no_hp': noHp,
      if (kabAsal != null) 'kab_asal': kabAsal,
      if (kabTujuan != null) 'kab_tujuan': kabTujuan,
      if (sopirNama != null) 'sopir_nama': sopirNama,
      if (angkutanNama != null) 'angkutan_nama': angkutanNama,
      if (angkutanPlat != null) 'angkutan_plat': angkutanPlat,
    };
  }
}

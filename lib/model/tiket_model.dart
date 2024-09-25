class TiketModel {
  final int? id;
  final int? userId;
  final int? loketId;
  final int? jadwalId;
  final int? penumpangId;
  final String? noTiket;
  final String? jmlTiket;
  final String? tglBerangkat;
  final String? jmlBayar;
  final String? noKursi;
  final String? almJemput;
  final String? statusBayar;
  final String? createdAt;
  final String? updatedAt;
  final String? user;
  final String? loket;
  final String? nmPenumpang;
  final String? noHp;
  final String? kabAsal;
  final String? kabTujuan;
  final String? hargaTiket;
  final String? sopirNama;
  final String? angkutanNama;
  final String? angkutanPlat;

  TiketModel({
    this.id,
    this.userId,
    this.loketId,
    this.jadwalId,
    this.penumpangId,
    this.noTiket,
    this.jmlTiket,
    this.tglBerangkat,
    this.jmlBayar,
    this.noKursi,
    this.almJemput,
    this.statusBayar,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.loket,
    this.nmPenumpang,
    this.noHp,
    this.kabAsal,
    this.kabTujuan,
    this.hargaTiket,
    this.sopirNama,
    this.angkutanNama,
    this.angkutanPlat,
  });

  factory TiketModel.fromJson(Map<String, dynamic> json) {
    return TiketModel(
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
      noTiket: json['no_tiket'] as String?,
      jmlTiket: json['jml_tiket'] as String?,
      tglBerangkat: json['tgl_berangkat'] as String?,
      jmlBayar: json['jml_bayar'] as String?,
      noKursi: json['no_kursi'] as String?,
      almJemput: json['alm_jemput'] as String?,
      statusBayar: json['status_bayar'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] as String?,
      loket: json['loket'] as String?,
      nmPenumpang: json['nm_penumpang'] as String?,
      noHp: json['no_hp'] as String?,
      kabAsal: json['kab_asal'] as String?,
      kabTujuan: json['kab_tujuan'] as String?,
      hargaTiket: json['harga_tiket'] as String?,
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
      if (noTiket != null) 'no_tiket': noTiket,
      if (jmlTiket != null) 'jml_tiket': jmlTiket,
      if (tglBerangkat != null) 'tgl_berangkat': tglBerangkat,
      if (jmlBayar != null) 'jml_bayar': jmlBayar,
      if (noKursi != null) 'no_kursi': noKursi,
      if (almJemput != null) 'alm_jemput': almJemput,
      if (statusBayar != null) 'status_bayar': statusBayar,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (user != null) 'user': user,
      if (loket != null) 'loket': loket,
      if (nmPenumpang != null) 'nm_penumpang': nmPenumpang,
      if (noHp != null) 'no_hp': noHp,
      if (kabAsal != null) 'kab_asal': kabAsal,
      if (kabTujuan != null) 'kab_tujuan': kabTujuan,
      if (hargaTiket != null) 'harga_tiket': hargaTiket,
      if (sopirNama != null) 'sopir_nama': sopirNama,
      if (angkutanNama != null) 'angkutan_nama': angkutanNama,
      if (angkutanPlat != null) 'angkutan_plat': angkutanPlat,
    };
  }
}

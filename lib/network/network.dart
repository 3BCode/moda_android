class NetworkURL {
  static String baseURL = "http://192.168.1.5/moda/public/api";
  static String storageURL = 'http://192.168.1.5/moda/public/storage/';
  // Baru API
  static String login() {
    return '$baseURL/login';
  }

  static String registrasi() {
    return '$baseURL/register';
  }

  static String getAngkutan(int page) {
    return '$baseURL/angkutan?page=$page';
  }

  static String getSopir(int page) {
    return '$baseURL/sopir?page=$page';
  }

  static String getJadwal(int page) {
    return '$baseURL/jadwal?page=$page';
  }

  static String getPelanggan(int page) {
    return '$baseURL/penumpang?page=$page';
  }

  static String pelangganAdd() {
    return "$baseURL/penumpang/store";
  }

  static String pelangganEdit() {
    return "$baseURL/penumpang/update";
  }

  static String pelangganDelete() {
    return "$baseURL/penumpang/destroy";
  }

  static String getTiket(int page) {
    return '$baseURL/tiket?page=$page';
  }

  static String getPaket(int page) {
    return '$baseURL/paket?page=$page';
  }

  static String getKaryawan(int page) {
    return '$baseURL/karyawan?page=$page';
  }

  static String getProfile() {
    return "$baseURL/user/profile";
  }

  static String editProfile() {
    return "$baseURL/user/profile/update";
  }

  static String editProfilePhoto() {
    return "$baseURL/user/photo/update";
  }

  // Tutup Baru API

  static String profilEditGambar() {
    return "$baseURL/profil_edit_gambar.php";
  }

  static String profilEdit() {
    return "$baseURL/profil_edit.php";
  }

  static String angkutanGet(String adminid) {
    return "$baseURL/angkutan.php?adminid=$adminid";
  }

  static String angkutanAdd() {
    return "$baseURL/angkutan_add.php";
  }

  static String angkutanEdit() {
    return "$baseURL/angkutan_edit.php";
  }

  static String angkutanDelete() {
    return "$baseURL/angkutan_delete.php";
  }

  static String tipeAngkutanGet() {
    return "$baseURL/tipe_angkutan.php";
  }

  static String sopirGet(String adminid) {
    return "$baseURL/sopir.php?adminid=$adminid";
  }

  static String sopirAdd() {
    return "$baseURL/sopir_add.php";
  }

  static String sopirEdit() {
    return "$baseURL/sopir_edit.php";
  }

  static String sopirDelete() {
    return "$baseURL/sopir_delete.php";
  }

  static String jadwalGet(String adminid) {
    return "$baseURL/jadwal.php?adminid=$adminid";
  }

  static String jadwalAdd() {
    return "$baseURL/jadwal_add.php";
  }

  static String jadwalEdit() {
    return "$baseURL/jadwal_edit.php";
  }

  static String jadwalDelete() {
    return "$baseURL/jadwal_delete.php";
  }

  static String hariGet() {
    return "$baseURL/hari.php";
  }

  static String kabupatenGet() {
    return "$baseURL/kabupaten.php";
  }

  static String pelangganGet(String adminid) {
    return "$baseURL/pelanggan.php?adminid=$adminid";
  }

  static String tiketGet(String adminid) {
    return "$baseURL/tiket.php?adminid=$adminid";
  }

  static String tiketAdd() {
    return "$baseURL/tiket_add.php";
  }

  static String tiketEdit() {
    return "$baseURL/tiket_edit.php";
  }

  static String tiketDelete() {
    return "$baseURL/tiket_delete.php";
  }

  static String paketGet(String adminid) {
    return "$baseURL/paket.php?adminid=$adminid";
  }

  static String paketAdd() {
    return "$baseURL/paket_add.php";
  }

  static String paketEdit() {
    return "$baseURL/paket_edit.php";
  }

  static String paketDelete() {
    return "$baseURL/paket_delete.php";
  }
}

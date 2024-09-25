import 'package:flutter/material.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/components/custom_clipper.dart';
import 'package:moda/screen/pemilik_loket/angkutan/angkutan.dart';
import 'package:moda/screen/pemilik_loket/jadwal/jadwal.dart';
import 'package:moda/screen/pemilik_loket/karyawan/karyawan.dart';
import 'package:moda/screen/pemilik_loket/paket/paket.dart';
import 'package:moda/screen/pemilik_loket/pelanggan/pelanggan.dart';
import 'package:moda/screen/pemilik_loket/sopir/sopir.dart';
import 'package:moda/screen/pemilik_loket/tiket/tiket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String namaLoket = "";

  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      namaLoket = preferences.getString("namaLoket") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.abus,
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: AppBarCustomClipper(),
                child: Container(
                  color: AppColor.backgroundColor,
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 16, right: 16, bottom: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LOKET $namaLoket'.toUpperCase(),
                          style: GoogleFonts.fredoka(
                            textStyle: const TextStyle(
                              color: AppColor.putih,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const CircleAvatar(
                          backgroundColor: AppColor.putih,
                          child: Icon(Icons.person,
                              color: AppColor.backgroundColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.putih,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Pendapatan', style: GoogleFonts.fredoka()),
                              Image.asset('assets/logo_kecil.png', height: 24),
                            ],
                          ),
                          Text(
                            'Rp0',
                            style: GoogleFonts.fredoka(
                              textStyle: const TextStyle(
                                color: AppColor.black,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text(
                            'Kalkulasi pendapatan berdasarkan hari ini.',
                            style: GoogleFonts.fredoka(
                              textStyle: const TextStyle(
                                  fontSize: 12, color: AppColor.abu),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildHeaderButton(
                                  'Laporan', 'assets/laporan.png'),
                              _buildHeaderButton(
                                  'Ringkasan', 'assets/ringkasan.png'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Terakhir diperbaharui: 23 Sep 2024, 17:56.',
                            style: GoogleFonts.fredoka(
                              textStyle: const TextStyle(
                                  fontSize: 12, color: AppColor.abu),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Bagian yang bisa di-scroll
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGridMenu(),
                    const SizedBox(height: 16),
                    _buildPromoCard(),
                    const SizedBox(height: 16),
                    _buildActivitySection(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(String label, String assetPath) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.abu),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.fredoka(
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 12),
          Image.asset(assetPath, width: 18, height: 18),
        ],
      ),
    );
  }

  Widget _buildGridMenu() {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': 'assets/angkutan.png',
        'label': 'Angkutan',
        'page': const Angkutan(),
      },
      {
        'icon': 'assets/sopir.png',
        'label': 'Sopir',
        'page': const Sopir(),
      },
      {
        'icon': 'assets/jadwal.png',
        'label': 'Jadwal',
        'page': const Jadwal(),
      },
      {
        'icon': 'assets/pelanggan.png',
        'label': 'Pelanggan',
        'page': const Pelanggan(),
      },
      {
        'icon': 'assets/tiket.png',
        'label': 'Tiket',
        'page': const Tiket(),
      },
      {
        'icon': 'assets/paket.png',
        'label': 'Paket',
        'page': const Paket(),
      },
      {
        'icon': 'assets/karyawan.png',
        'label': 'Karyawan',
        'page': const Karyawan(),
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.9,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item['page'] as Widget),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(item['icon'] as String, height: 40, width: 40),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item['label'] as String,
                    style: GoogleFonts.fredoka(
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.customSwatch[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SPECIAL 100',
            style: GoogleFonts.fredoka(
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Text('Mitra perdana', style: GoogleFonts.fredoka()),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Biaya pendaftaran', style: GoogleFonts.fredoka()),
                  Text(
                    'FREE',
                    style: GoogleFonts.fredoka(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppColor.backgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Daftar', style: GoogleFonts.fredoka()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktivitas Terakhir',
          style: GoogleFonts.fredoka(
            textStyle: const TextStyle(color: AppColor.black, fontSize: 18),
          ),
        ),
        Text(
          'Riwayat Aktivitas Terakhir Loket Anda',
          style: GoogleFonts.fredoka(
            textStyle: const TextStyle(color: AppColor.abu, fontSize: 14),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildActivityItem(),
        ),
      ],
    );
  }

  Widget _buildActivityItem() {
    return Row(
      children: [
        Image.asset('assets/transaksi.png', height: 40, width: 40),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Transaksi -0721d12',
                  style: GoogleFonts.fredoka(
                    color: AppColor.black,
                    fontSize: 14,
                  )),
              Text('Jumlah',
                  style:
                      GoogleFonts.fredoka(fontSize: 12, color: AppColor.abu)),
              Text(
                'Rp0',
                style: GoogleFonts.fredoka(
                  textStyle:
                      const TextStyle(color: AppColor.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        Text(
          '21 Sep 2024 - 17:05',
          style: GoogleFonts.fredoka(fontSize: 12, color: AppColor.abu),
        ),
      ],
    );
  }
}

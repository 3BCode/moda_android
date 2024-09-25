import 'package:flutter/material.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/components/custom_clipper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String namaLoket = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      namaLoket = preferences.getString("namaLoket") ?? "";
      email = preferences.getString("email") ?? "";
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
                          'PROFIL',
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
                    const SizedBox(height: 20),
                    _buildProfileInfo(),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMenuSection(),
                    const SizedBox(height: 20),
                    _buildAboutSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Text(
            namaLoket,
            style: GoogleFonts.fredoka(
              textStyle: const TextStyle(
                color: AppColor.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: GoogleFonts.fredoka(
              textStyle: const TextStyle(
                color: AppColor.abu,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement edit profile functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('Edit Profil', style: GoogleFonts.fredoka()),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.settings, 'label': 'Pengaturan'},
      {'icon': Icons.history, 'label': 'Riwayat Transaksi'},
      {'icon': Icons.help, 'label': 'Bantuan'},
      {'icon': Icons.info, 'label': 'Tentang Aplikasi'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: menuItems
            .map((item) => _buildMenuItem(item['icon'], item['label']))
            .toList(),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: AppColor.backgroundColor),
      title: Text(
        label,
        style: GoogleFonts.fredoka(
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: Implement navigation to respective pages
      },
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tentang Loket',
          style: GoogleFonts.fredoka(
            textStyle: const TextStyle(
              color: AppColor.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Loket $namaLoket adalah mitra resmi dari aplikasi Moda. '
          'Kami menyediakan layanan pemesanan tiket dan pengiriman paket yang cepat dan terpercaya.',
          style: GoogleFonts.fredoka(
            textStyle: const TextStyle(
              color: AppColor.abu,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

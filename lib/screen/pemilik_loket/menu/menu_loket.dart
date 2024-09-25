import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/screen/pemilik_loket/home/home.dart';
import 'package:moda/screen/pemilik_loket/profil/profil.dart';

import '../../../preferences_manager/preferences_manager.dart';

class MenuLoket extends StatefulWidget {
  final VoidCallback signOut;
  const MenuLoket(this.signOut, {super.key});

  @override
  State<MenuLoket> createState() => _MenuLoketState();
}

class _MenuLoketState extends State<MenuLoket> {
  int selectIndex = 0;

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  late TabController tabController;

  String id = "";
  String loketId = "";
  String name = "";
  String email = "";
  String level = "";
  String namaLoket = "";
  String accessToken = "";
  String tokenType = "";

  Future<void> getPref() async {
    Map<String, String> userPreferences =
        await PreferencesManager.getUserPreferences();
    setState(() {
      id = userPreferences['id'] ?? "";
      loketId = userPreferences['loketId'] ?? "";
      name = userPreferences['name'] ?? "";
      email = userPreferences['email'] ?? "";
      level = userPreferences['level'] ?? "";
      namaLoket = userPreferences['namaLoket'] ?? "";
      accessToken = userPreferences['accessToken'] ?? "";
      tokenType = userPreferences['tokenType'] ?? "";
    });

    // Print the values
    print('Preferensi Pengguna:');
    print('ID: $id');
    print('Loket ID: $loketId');
    print('Name: $name');
    print('Email: $email');
    print('Level: $level');
    print('Nama Loket: $namaLoket');
    print('Access Token: $accessToken');
    print('Token Type: $tokenType');
  }

  Future<void> onRefresh() async {
    await getPref();
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.putih,
        body: Stack(
          children: [
            Offstage(
              offstage: selectIndex != 0,
              child: TickerMode(
                enabled: selectIndex == 0,
                child: const Home(),
              ),
            ),
            Offstage(
              offstage: selectIndex != 1,
              child: const Profil(),
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          width: 60,
          height: 60,
          child: Container(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectIndex = 0;
                      });
                    },
                    child: Ink(
                      child: Tab(
                        icon: Image.asset(
                          'assets/home.png',
                          width: 25.0,
                          height: 25.0,
                          color: selectIndex == 0
                              ? AppColor.buttonColor
                              : AppColor.abu,
                        ),
                        child: Text(
                          'Home',
                          style: GoogleFonts.fredoka(
                            fontSize: 10.0,
                            color: selectIndex == 0
                                ? AppColor.buttonColor
                                : AppColor.abu,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectIndex = 1;
                      });
                    },
                    child: Ink(
                      child: Tab(
                        icon: Image.asset(
                          'assets/profil.png',
                          width: 25.0,
                          height: 25.0,
                          color: selectIndex == 1
                              ? AppColor.buttonColor
                              : AppColor.abu,
                        ),
                        child: Text(
                          'Profil',
                          style: GoogleFonts.fredoka(
                            fontSize: 10.0,
                            color: selectIndex == 1
                                ? AppColor.buttonColor
                                : AppColor.abu,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

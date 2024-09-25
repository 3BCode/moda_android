import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/components/custom_clipper.dart';
import 'package:moda/model/user_model.dart';
import 'package:moda/network/network.dart';
import 'package:moda/screen/pemilik_loket/profil/profil_edit.dart';
import 'package:moda/screen/pemilik_loket/profil/profil_edit_gambar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../custom/customButton.dart';

import '../../../custom/info_card.dart';
import '../../auth/login.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("level");
    pref.remove("id");
    pref.remove("nama");
    pref.remove("email");
    pref.remove("namaLoket");
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  String adminid = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? adminidValue = preferences.getInt("id");

    setState(() {
      adminid = adminidValue?.toString() ?? "";
    });
    print(adminid);
    getProfil();
  }

  var loading = false;
  List<UserModel> list = [];

  getProfil() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(
      Uri.parse(
        NetworkURL.getProfil(adminid),
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        for (Map i in data) {
          list.add(UserModel.fromJson(i as Map<String, dynamic>));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> onRefresh() async {
    getPref();
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.abus,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 160,
              child: AppBar(
                backgroundColor: AppColor.abus,
                flexibleSpace: ClipPath(
                  clipper: AppBarCustomClipper(),
                  child: Container(
                    padding: const EdgeInsets.only(top: 35),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColor.all,
                          AppColor.all,
                        ],
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Profil Loket',
                        style: TextStyle(
                          color: AppColor.putih,
                          fontSize: 30,
                          fontFamily: 'MaisonNeue',
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout, size: 28),
                    color: AppColor.putih,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Warning"),
                            content:
                                const Text("Apakah Anda Yakin Inggin Keluar?"),
                            actions: <Widget>[
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  side: BorderSide(
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "No",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  side: BorderSide(
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  signOut();
                                },
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 60,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.putih,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: RefreshIndicator(
                        onRefresh: onRefresh,
                        child: loading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (context, i) {
                                  final a = list[i];
                                  return Container(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CircleAvatar(
                                                  radius: 60,
                                                  backgroundImage: NetworkImage(
                                                    '${NetworkURL.baseURL}../../asset/profil/${a.gambar}',
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: CircleAvatar(
                                                radius: 17,
                                                backgroundColor: AppColor
                                                    .all, // Background color of the CircleAvatar
                                                child: Center(
                                                  child: IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfilEditGambar(
                                                                  a, onRefresh),
                                                        ),
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.camera_alt,
                                                      size: 17,
                                                      color: AppColor
                                                          .putih, // Color of the camera icon
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        InfoCard(
                                          text: a.nama!,
                                          icon: Icons.account_circle_outlined,
                                          onPressed: () {},
                                        ),
                                        InfoCard(
                                          text: a.namaLoket!,
                                          icon: Icons.card_membership_sharp,
                                          onPressed: () {},
                                        ),
                                        InfoCard(
                                          text: a.email!,
                                          icon: Icons.email,
                                          onPressed: () {},
                                        ),
                                        InfoCard(
                                          text: a.noHP!,
                                          icon: Icons.phone_android,
                                          onPressed: () {},
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilEdit(a, onRefresh),
                                              ),
                                            );
                                          },
                                          child: const CustomButton(
                                            "EDIT PROFIL",
                                            color: AppColor.all,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

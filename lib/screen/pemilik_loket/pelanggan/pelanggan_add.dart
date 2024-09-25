import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PelangganAdd extends StatefulWidget {
  final VoidCallback reload;
  const PelangganAdd(this.reload, {super.key});

  @override
  State<PelangganAdd> createState() => _PelangganAddState();
}

class _PelangganAddState extends State<PelangganAdd> {
  String adminid = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? adminidValue = preferences.getInt("id");

    setState(() {
      adminid = adminidValue?.toString() ?? "";
    });
    print(adminid);
  }

  final _key = GlobalKey<FormState>();
  TextEditingController namaController = TextEditingController();
  TextEditingController noHPController = TextEditingController();

  cek() {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      submit();
    }
  }

  submit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const PopScope(
          child: AlertDialog(
            title: Text('Processing..'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 16,
                ),
                Text("Please wait...")
              ],
            ),
          ),
        );
      },
    );

    var uri = Uri.parse(NetworkURL.pelangganAdd());
    var request = http.MultipartRequest("POST", uri);

    request.fields['adminid'] = adminid;
    request.fields['nama'] = namaController.text.trim();
    request.fields['noHP'] = noHPController.text.trim();

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((a) {
      final data = jsonDecode(a);
      int value = data['value'];
      String message = data['message'];
      if (value == 1) {
         if (!mounted) return;
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Information"),
                content: Text(message),
                actions: <Widget>[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        Navigator.pop(context);
                        widget.reload();
                      });
                    },
                    child: const Text(
                      "Ok",
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              );
            });
      } else {
         if (!mounted) return;
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Warning"),
              content: Text(message),
              actions: <Widget>[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            );
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Pelanggan",
          style: TextStyle(
            fontSize: 18.0,
            color: AppColor.putih,
            fontFamily: 'MaisonNeue',
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.all,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColor.putih,
            size: 30,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Masukkan nama pelanggan";
                  }
                  return null;
                },
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Nama Pelanggan",
                  filled: true,
                  fillColor: Colors.white,
                  errorStyle: const TextStyle(color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 15,
                  ),
                  isDense: true,
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Masukkan no HP";
                  }
                  return null;
                },
                controller: noHPController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "No HP",
                  filled: true,
                  fillColor: Colors.white,
                  errorStyle: const TextStyle(color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 30),
              Material(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.all,
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  onPressed: () {
                    cek();
                  },
                  child: const Text(
                    'TAMBAH',
                    style: TextStyle(fontSize: 22.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

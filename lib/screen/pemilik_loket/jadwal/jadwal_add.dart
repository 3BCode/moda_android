import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/custom/currency.dart';
import 'package:moda/network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class JadwalAdd extends StatefulWidget {
  final VoidCallback reload;
  const JadwalAdd(this.reload, {super.key});

  @override
  State<JadwalAdd> createState() => _JadwalAddState();
}

class _JadwalAddState extends State<JadwalAdd> {
  String adminid = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? adminidValue = preferences.getInt("id");

    setState(() {
      adminid = adminidValue?.toString() ?? "";
    });
    getHari();
    getSopir();
    getKabAsal();
    getKabTujuan();
    print(adminid);
  }

  final _key = GlobalKey<FormState>();
  TextEditingController hargaController = TextEditingController();
  TextEditingController jamController = TextEditingController();

  String? _valHari;
  List<dynamic> _dataHari = [];
  Future getHari() async {
    var url = Uri.parse(NetworkURL.hariGet());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        _dataHari = jsonData;
      });
    }
    print("Data Hari : $_dataHari");
  }

  String? _valSopir;
  List<dynamic> _dataSopir = [];
  Future getSopir() async {
    var url = Uri.parse(NetworkURL.sopirGet(adminid));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        _dataSopir = jsonData;
      });
    }
    print("Data Sopir : $_dataSopir");
  }

  String? _valKabasal;
  List<dynamic> _dataKabasal = [];
  Future getKabAsal() async {
    var url = Uri.parse(NetworkURL.kabupatenGet());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        _dataKabasal = jsonData;
      });
    }
    print("Data Kabasal : $_dataKabasal");
  }

  String? _valKabTujuan;
  List<dynamic> _dataKabTujuan = [];
  Future getKabTujuan() async {
    var url = Uri.parse(NetworkURL.kabupatenGet());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        _dataKabTujuan = jsonData;
      });
    }
    print("Data KabTujuan : $_dataKabTujuan");
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != TimeOfDay.now()) {
      setState(() {
        jamController.text = picked.format(context);
      });
    }
  }

  @override
  void dispose() {
    jamController.dispose();
    super.dispose();
  }

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

    var uri = Uri.parse(NetworkURL.jadwalAdd());
    var request = http.MultipartRequest("POST", uri);

    request.fields['hariid'] = _valHari!;
    request.fields['sopirid'] = _valSopir!;
    request.fields['kabasalid'] = _valKabasal!;
    request.fields['kabtujuanid'] = _valKabTujuan!;
    request.fields['harga'] = hargaController.text.replaceAll(",", "");
    request.fields['jam'] = jamController.text.trim();
    request.fields['adminid'] = adminid;

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
          "Tambah Jadwal",
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
              DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: "Hari",
                  labelText: "Hari",
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
                value: _valHari,
                items: _dataHari.map((hari) {
                  return DropdownMenuItem(
                    value: hari['id'].toString(),
                    child: Text(
                      '${hari['nama']}',
                    ),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) return "Pilih hari";
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _valHari = value as String;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: "Sopir",
                  labelText: "Sopir",
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
                value: _valSopir,
                items: _dataSopir.map((sopir) {
                  return DropdownMenuItem(
                    value: sopir['id'].toString(),
                    child: Text(
                      '${sopir['nama']} (${sopir['plat']})',
                    ),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) return "Pilih sopir";
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _valSopir = value as String;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: "Kota Asal",
                  labelText: "Kota Asal",
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
                value: _valKabasal,
                items: _dataKabasal.map((kabasal) {
                  return DropdownMenuItem(
                    value: kabasal['id'].toString(),
                    child: Text(
                      '${kabasal['nama']}',
                    ),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) return "Pilih Kota Asal";
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _valKabasal = value as String;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: "Kota Tujuan",
                  labelText: "Kota Tujuan",
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
                value: _valKabTujuan,
                items: _dataKabTujuan.map((kabtujuan) {
                  return DropdownMenuItem(
                    value: kabtujuan['id'].toString(),
                    child: Text(
                      '${kabtujuan['nama']}',
                    ),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) return "Pilih Kota Tujuan";
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _valKabTujuan = value as String;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Masukkan harga";
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyFormat()
                ],
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Harga",
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
              const SizedBox(height: 20),
              TextFormField(
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Masukkan jam";
                  }
                  return null;
                },
                controller: jamController,
                readOnly: true,
                onTap: () => _selectTime(context),
                decoration: InputDecoration(
                  labelText: "Jam",
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

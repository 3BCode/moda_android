import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SopirAdd extends StatefulWidget {
  final VoidCallback reload;
  const SopirAdd(this.reload, {super.key});

  @override
  State<SopirAdd> createState() => _SopirAddState();
}

class _SopirAddState extends State<SopirAdd> {
  String adminid = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? adminidValue = preferences.getInt("id");

    setState(() {
      adminid = adminidValue?.toString() ?? "";
    });
    getAngkutan();
    print(adminid);
  }

  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  final _key = GlobalKey<FormState>();
  TextEditingController nikController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noHPController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? _valAngkutan;
  List<dynamic> _dataAngkutan = [];
  Future getAngkutan() async {
    var url = Uri.parse(NetworkURL.angkutanGet(adminid));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        _dataAngkutan = jsonData;
      });
    }
    print("Data Angkutan : $_dataAngkutan");
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

    var uri = Uri.parse(NetworkURL.sopirAdd());
    var request = http.MultipartRequest("POST", uri);

    request.fields['adminid'] = adminid;
    request.fields['angkutanid'] = _valAngkutan!;
    request.fields['nik'] = nikController.text.trim();
    request.fields['nama'] = namaController.text.trim();
    request.fields['email'] = emailController.text.trim();
    request.fields['alamat'] = alamatController.text.trim();
    request.fields['noHP'] = noHPController.text.trim();
    request.fields['password'] = passwordController.text.trim();
    request.fields['passwordHid'] = passwordController.text.trim();

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
          "Tambah Sopir",
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
                    return "Masukkan nik";
                  }
                  return null;
                },
                controller: nikController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "NIK",
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
                    return "Masukkan nama sopir";
                  }
                  return null;
                },
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Nama Sopir",
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
              DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: "Angkutan",
                  labelText: "Angkutan",
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
                value: _valAngkutan,
                items: _dataAngkutan.map((angkutan) {
                  return DropdownMenuItem(
                    value: angkutan['id'].toString(),
                    child: Text(
                      '${angkutan['nama']} (${angkutan['plat']})',
                    ),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) return "Pilih angkutan";
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _valAngkutan = value as String;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Masukkan alamat";
                  }
                  return null;
                },
                controller: alamatController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Alamat",
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
              const SizedBox(height: 20),
              TextFormField(
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return 'Masukkan email';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(e)) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
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
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Masukkan password";
                  }
                  return null;
                },
                obscureText: _secureText,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  errorStyle: const TextStyle(color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    onPressed: showHide,
                    icon: Icon(
                      _secureText ? Icons.visibility_off : Icons.visibility,
                      color: _secureText ? Colors.grey : Colors.blue,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 15,
                  ),
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

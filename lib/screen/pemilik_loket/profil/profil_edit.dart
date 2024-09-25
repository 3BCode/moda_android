import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../components/app_color.dart';
import '../../../model/user_model.dart';
import '../../../network/network.dart';

class ProfilEdit extends StatefulWidget {
  final UserModel model;
  final VoidCallback reload;
  const ProfilEdit(this.model, this.reload, {super.key});

  @override
  State<ProfilEdit> createState() => _ProfilEditState();
}

class _ProfilEditState extends State<ProfilEdit> {
  String adminid = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? adminidValue = preferences.getInt("id");

    setState(() {
      adminid = adminidValue?.toString() ?? "";
    });
    print(adminid);
  }

  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  final _key = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  setup() {
    emailController = TextEditingController(text: widget.model.email);
    passwordController = TextEditingController();
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

    var url = Uri.parse(NetworkURL.profilEdit());
    var request = http.MultipartRequest("POST", url);
    request.fields['email'] = emailController.text;
    // Jika password tidak kosong, kirim password baru
    if (passwordController.text.isNotEmpty) {
      request.fields['password'] = passwordController.text;
      request.fields['passwordHid'] = passwordController.text;
    }
    request.fields['adminid'] = widget.model.id!;

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

  Future<void> onRefresh() async {
    getPref();
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profil",
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
                    if (passwordController.text.isNotEmpty) {
                      return "Masukkan password";
                    } else {
                      return null;
                    }
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
                    if (_key.currentState!.validate()) {
                      cek();
                    }
                  },
                  child: const Text(
                    'EDIT',
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

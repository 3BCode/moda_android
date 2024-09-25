import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moda/components/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../model/user_model.dart';
import '../../../network/network.dart';

class ProfilEditGambar extends StatefulWidget {
  final UserModel model;
  final VoidCallback reload;
  const ProfilEditGambar(this.model, this.reload, {super.key});

  @override
  State<ProfilEditGambar> createState() => _ProfilEditGambarState();
}

class _ProfilEditGambarState extends State<ProfilEditGambar> {
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

  final picker = ImagePicker();

  // imageFile
  File? imageFile;
  Future _photochoiceImageGalery() async {
    final pickedImage = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      imageFile = File(pickedImage!.path);
    });
  }

  Future _photochoiceImageCamera() async {
    final pickedImage = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      imageFile = File(pickedImage!.path);
    });
  }

  void _photoshowPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Galery'),
                    onTap: () {
                      _photochoiceImageGalery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _photochoiceImageCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
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
        builder: (context) {
          return const AlertDialog(
            title: Text("Processing.."),
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
          );
        });

    var url = Uri.parse(NetworkURL.profilEditGambar());
    var request = http.MultipartRequest("POST", url);
    request.fields['adminid'] = widget.model.id!;

    if (imageFile == null) {
      request.fields['gambar'] = widget.model.gambar!;
    } else {
      var pic = await http.MultipartFile.fromPath("gambar", imageFile!.path);
      request.files.add(pic);
    }

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((a) {
      final data = jsonDecode(a);
      int value = data['value'];
      String message = data['message'];
      // ignore: avoid_print
      print(value);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Foto Profil",
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
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  children: <Widget>[
                    Text(
                      "Foto Profil",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MaisonNeue',
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _photoshowPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColor.all,
                    child: imageFile == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              '${NetworkURL.baseURL}../../asset/profil/${widget.model.gambar}',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              imageFile!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
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
                  'Edit Foto Profil',
                  style: TextStyle(fontSize: 22.0, color: AppColor.putih),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

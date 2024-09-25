import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

class TiketAdd extends StatefulWidget {
  final VoidCallback reload;
  const TiketAdd(this.reload, {super.key});

  @override
  State<TiketAdd> createState() => _TiketAddState();
}

class _TiketAddState extends State<TiketAdd> {
  String adminid = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? adminidValue = preferences.getInt("id");

    setState(() {
      adminid = adminidValue?.toString() ?? "";
    });
    getJadwal();
    getPelanggan();
    print(adminid);
  }

  final _key = GlobalKey<FormState>();
  TextEditingController almPenjemputanController = TextEditingController();

  final List<TextEditingController> _noKursiControllers = [];
  final TextEditingController jumlahPesanController = TextEditingController();
  int _jumlahPesanan = 1;

  void _addKursiFields(int jumlah) {
    _noKursiControllers.clear();
    for (int i = 0; i < jumlah; i++) {
      _noKursiControllers.add(TextEditingController());
    }
  }

  String? _valJadwal;
  List<dynamic> _dataJadwal = [];
  final TextEditingController _typeAheadController = TextEditingController();

  Future getJadwal() async {
    var url = Uri.parse(NetworkURL.jadwalGet(adminid));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        _dataJadwal = jsonData;
      });
    }
    print("Data Jadwal : $_dataJadwal");
  }

  Map<String, dynamic> get _selectedJadwal {
    return _dataJadwal.firstWhere(
        (jadwal) => jadwal['id'].toString() == _valJadwal,
        orElse: () => {});
  }

  String? _valPelanggan;
  List<dynamic> _dataPelanggan = [];
  final TextEditingController _typeAheadPController = TextEditingController();

  Future getPelanggan() async {
    var url = Uri.parse(NetworkURL.pelangganGet(adminid));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        _dataPelanggan = jsonData;
      });
    }
    print("Data Pelanggan : $_dataPelanggan");
  }

  late String pilihTanggal;
  DateTime tgl = DateTime.now();
  final TextStyle valueStyle = const TextStyle(fontSize: 16.0);
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        pilihTanggal = DateFormat('dd/MM/yyyy').format(tgl);
        _dateController.text = pilihTanggal;
      });
    }
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

    var uri = Uri.parse(NetworkURL.tiketAdd());
    var request = http.MultipartRequest("POST", uri);

    request.fields['jadwalid'] = _valJadwal!;
    request.fields['pelangganid'] = _valPelanggan!;
    request.fields['tglBerangkat'] = "$tgl";
    request.fields['jumlahPesan'] = jumlahPesanController.text.trim();
    String kursi = _noKursiControllers
        .map((controller) => controller.text.trim())
        .join(',');
    request.fields['noKursi'] = kursi;
    request.fields['almPenjemputan'] = almPenjemputanController.text.trim();
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
    pilihTanggal = DateFormat('dd/MM/yyyy').format(tgl);
    _dateController.text = pilihTanggal;
    _addKursiFields(_jumlahPesanan);
  }

  @override
  void dispose() {
    for (var controller in _noKursiControllers) {
      controller.dispose();
    }
    jumlahPesanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Tiket",
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
              TypeAheadFormField<String?>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _typeAheadController,
                  decoration: InputDecoration(
                    hintText: "Jadwal",
                    labelText: "Jadwal",
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
                    suffixIcon: _typeAheadController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _typeAheadController.clear();
                                _valJadwal = null;
                              });
                            },
                          )
                        : null,
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return _dataJadwal
                      .where((jadwal) =>
                          jadwal['nmhari']
                              .toLowerCase()
                              .contains(pattern.toLowerCase()) ||
                          jadwal['nmkabasal']
                              .toLowerCase()
                              .contains(pattern.toLowerCase()) ||
                          jadwal['nmkabtujuan']
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                      .map((jadwal) => jadwal['id'].toString())
                      .toList();
                },
                itemBuilder: (context, suggestion) {
                  var jadwal = _dataJadwal.firstWhere(
                      (jadwal) => jadwal['id'].toString() == suggestion);
                  return ListTile(
                    title: Text(
                      '${jadwal['nmhari']} - ${jadwal['nmkabasal']} ke ${jadwal['nmkabtujuan']}',
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    _valJadwal = suggestion;
                    var selectedJadwal = _dataJadwal.firstWhere(
                        (jadwal) => jadwal['id'].toString() == suggestion);
                    _typeAheadController.text =
                        '${selectedJadwal['nmhari']} - ${selectedJadwal['nmkabasal']} ke ${selectedJadwal['nmkabtujuan']}';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return "Pilih jadwal";
                  return null;
                },
              ),
              if (_valJadwal != null && _selectedJadwal.isNotEmpty)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detail Jadwal:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text('Hari: ${_selectedJadwal['nmhari']}'),
                        Text('Asal: ${_selectedJadwal['nmkabasal']}'),
                        Text('Tujuan: ${_selectedJadwal['nmkabtujuan']}'),
                        Text('Plat: ${_selectedJadwal['plat']}'),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              TypeAheadFormField<String?>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _typeAheadPController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Pelanggan",
                    labelText: "Pelanggan",
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
                    suffixIcon: _typeAheadPController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _typeAheadPController.clear();
                                _valPelanggan = null;
                              });
                            },
                          )
                        : null,
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return _dataPelanggan
                      .where((pelanggan) =>
                          pelanggan['nama']
                              .toLowerCase()
                              .contains(pattern.toLowerCase()) ||
                          pelanggan['noHP']
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                      .map((pelanggan) => pelanggan['id'].toString())
                      .toList();
                },
                itemBuilder: (context, suggestion) {
                  var pelanggan = _dataPelanggan.firstWhere(
                    (pelanggan) => pelanggan['id'].toString() == suggestion,
                  );
                  return ListTile(
                    title: Text(
                      '${pelanggan['nama']} - ${pelanggan['noHP']}',
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    _valPelanggan = suggestion;
                    var selectedPelanggan = _dataPelanggan.firstWhere(
                      (pelanggan) => pelanggan['id'].toString() == suggestion,
                    );
                    _typeAheadPController.text =
                        '${selectedPelanggan['nama']} - ${selectedPelanggan['noHP']}';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return "Pilih pelanggan";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: jumlahPesanController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Jumlah Pesanan",
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
                onChanged: (value) {
                  int? jumlah = int.tryParse(value);
                  if (jumlah != null && jumlah > 0) {
                    setState(() {
                      _jumlahPesanan = jumlah;
                      _addKursiFields(jumlah);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan jumlah pesanan";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _noKursiControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _noKursiControllers[index],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Nomor Kursi ${index + 1}",
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
                        prefixIcon: const Icon(Icons.event_seat),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Masukkan nomor kursi";
                        }
                        return null;
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Masukkan alamat penjemputan";
                  }
                  return null;
                },
                controller: almPenjemputanController,
                decoration: InputDecoration(
                  labelText: "Alamat Penjemputan",
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
                  prefixIcon: const Icon(Icons.location_on),
                ),
                textCapitalization: TextCapitalization.words,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Pilih tanggal";
                  }
                  return null;
                },
                controller: _dateController,
                keyboardType: TextInputType.text,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Tanggal",
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
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectedDate(context),
                  ),
                ),
                onTap: () => _selectedDate(context),
              ),
              const SizedBox(height: 30),
              Material(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
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

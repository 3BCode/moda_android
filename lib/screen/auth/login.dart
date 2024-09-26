// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/components/show_processing_dialog.dart';
import 'package:moda/network/network.dart';
import 'package:http/http.dart' as http;
import 'package:moda/screen/auth/registrasi.dart';
import 'package:moda/screen/karyawan_loket/menu/menu_karyawans.dart';
import 'package:moda/screen/pemilik_loket/menu/menu_loket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn, signUsers }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  final _formKey = GlobalKey<FormState>();
  bool _secureText = true;
  bool _isProcessing = false;
  bool _isDialogShowing = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPref();
    checkLoginStatus();
  }

  @override
  void dispose() {
    _dismissProcessingDialog();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Masukkan email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Masukkan password";
    }
    return null;
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    if (token != null) {
      setState(() {
        String? level = prefs.getString('level');
        _loginStatus =
            level == "1" ? LoginStatus.signIn : LoginStatus.signUsers;
      });
    }
  }

  void _showProcessingDialog() {
    if (!_isDialogShowing) {
      _isDialogShowing = true;
      showProcessingDialog(context);
    }
  }

  void _dismissProcessingDialog() {
    if (_isDialogShowing && mounted) {
      Navigator.of(context).pop();
      _isDialogShowing = false;
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      _showProcessingDialog();

      try {
        final response = await http.post(
          Uri.parse(NetworkURL.login()),
          body: {
            "email": _emailController.text.trim(),
            "password": _passwordController.text.trim(),
          },
        ).timeout(const Duration(seconds: 30));

        if (!mounted) return;

        _dismissProcessingDialog();

        final data = jsonDecode(response.body);
        int code = data['meta']['code'];

        if (code == 200) {
          await _handleSuccessfulLogin(data);
        } else {
          _showErrorDialog(code, data, data['meta']['message']);
        }
      } catch (e) {
        if (!mounted) return;

        _dismissProcessingDialog();

        _showErrorDialog(
            0, null, "Terjadi kesalahan jaringan. Silakan coba lagi.");
      } finally {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
  }

  Future<void> _handleSuccessfulLogin(dynamic data) async {
    var user = data['data']['user'];
    String level = user['level'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("accessToken", data['data']['access_token']);
    await prefs.setString("tokenType", data['data']['token_type']);
    await prefs.setString("email", user['email'] ?? '');
    await prefs.setString("name", user['name'] ?? '');
    await prefs.setInt("id", user['id'] ?? 0);
    await prefs.setInt("loketId", user['loket_id'] ?? 0);
    await prefs.setString("level", level);
    await prefs.setString("namaLoket", user['nama_loket'] ?? '');

    print('Data yang disimpan:');
    print('Access Token: ${data['data']['access_token']}');
    print('Token Type: ${data['data']['token_type']}');
    print('Email: ${user['email']}');
    print('Name: ${user['name']}');
    print('ID: ${user['id']}');
    print('Loket ID: ${user['loket_id']}');
    print('Level: $level');
    print('Nama Loket: ${user['nama_loket']}');

    if (mounted) {
      setState(() {
        _loginStatus =
            level == "1" ? LoginStatus.signIn : LoginStatus.signUsers;
      });
    }
  }

  void _showErrorDialog(int code, dynamic data, String? message) {
    String errorMessages = '';
    if (code == 0) {
      errorMessages = "Terjadi kesalahan jaringan. Silakan coba lagi.";
    } else if (code == 401) {
      errorMessages = message ?? 'Authentication Failed';
    } else if (code == 422) {
      Map<String, dynamic> errors = data['data'];
      errors.forEach((key, value) {
        errorMessages += '${value.join(", ")}\n';
      });
    } else if (code == 403) {
      errorMessages = data['data']['message'] ?? 'Account not activated';
    } else {
      errorMessages = message ?? 'Terjadi kesalahan yang tidak diketahui';
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(dialogContext).pop();
            return false;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: AppColor.putih,
            title: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                const SizedBox(height: 10),
                Text(
                  "Login Gagal",
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),
            content: Text(
              errorMessages,
              style: GoogleFonts.fredoka(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(
                    "Coba Lagi",
                    style: GoogleFonts.fredoka(
                      color: AppColor.putih,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required int errorMaxLines,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.putih,
        hintText: hintText,
        hintStyle: GoogleFonts.fredoka(
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColor.abu,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColor.abu,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColor.buttonColor,
            width: 2,
          ),
        ),
        errorStyle: GoogleFonts.fredoka(
          color: Colors.red,
          fontSize: 12,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        prefixIcon: Icon(prefixIcon, color: AppColor.buttonColor),
        suffixIcon: suffixIcon,
      ),
    );
  }

  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      String? value = preferences.getString("level");

      _loginStatus = (value ?? "") == "1"
          ? LoginStatus.signIn
          : (value ?? "") == "2"
              ? LoginStatus.signUsers
              : LoginStatus.notSignIn;
    });
  }

  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isDialogShowing) {
          _dismissProcessingDialog();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_dasar.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  "assets/background.png",
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColor.putih,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.abu.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/logo.png",
                                    width: 80,
                                    height: 80,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildTextField(
                                    controller: _emailController,
                                    hintText: "Email",
                                    prefixIcon: Icons.email,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: _validateEmail,
                                    errorMaxLines: 2,
                                  ),
                                  const SizedBox(height: 15),
                                  _buildTextField(
                                    controller: _passwordController,
                                    hintText: "Password",
                                    prefixIcon: Icons.lock,
                                    obscureText: _secureText,
                                    validator: _validatePassword,
                                    suffixIcon: IconButton(
                                      onPressed: _showHide,
                                      icon: Icon(
                                        _secureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: _secureText
                                            ? Colors.grey
                                            : AppColor.accentColor,
                                      ),
                                    ),
                                    errorMaxLines: 2,
                                  ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.buttonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                      ),
                                      onPressed: _isProcessing ? null : _submit,
                                      child: _isProcessing
                                          ? const CircularProgressIndicator(
                                              color: AppColor.textColor)
                                          : Text(
                                              'MASUK',
                                              style: GoogleFonts.fredoka(
                                                fontSize: 18.0,
                                                color: AppColor.textColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Registrasi(getPref),
                                  ),
                                );
                              },
                              child: Text(
                                "Belum punya akun? Daftar",
                                style: GoogleFonts.fredoka(
                                  color: AppColor.putih,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case LoginStatus.signIn:
        return MenuLoket(signOut);
      case LoginStatus.signUsers:
        return MenuKaryawan(signOut);
    }
  }
}

// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/components/show_processing_dialog.dart';
import 'package:moda/network/network.dart';
import 'package:http/http.dart' as http;

class Registrasi extends StatefulWidget {
  final VoidCallback reload;
  const Registrasi(this.reload, {super.key});

  @override
  State<Registrasi> createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  final _formKey = GlobalKey<FormState>();
  bool _secureText = true;
  bool _agreeToTerms = false;
  bool _isDialogShowing = false;
  bool _isProcessing = false;

  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _namaLoketController = TextEditingController();
  final TextEditingController _noHPController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final nikFormatter = FilteringTextInputFormatter.digitsOnly;

  void _showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  String? _validateNIK(String? value) {
    if (value == null || value.isEmpty) {
      return "Masukkan NIK";
    }
    if (value.length != 16) {
      return "NIK harus 16 digit";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Masukkan password";
    }
    if (value.length < 8) {
      return "Password minimal 8 karakter";
    }

    List<String> requirements = [];

    if (!value.contains(RegExp(r'[A-Z]'))) {
      requirements.add("huruf besar");
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      requirements.add("huruf kecil");
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      requirements.add("angka");
    }
    if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
      requirements.add("simbol (!@#\$&*~)");
    }

    if (requirements.isNotEmpty) {
      return "Password harus mengandung:\n${requirements.map((r) => "• $r").join("\n")}";
    }

    return null;
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

  void _submit() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      setState(() {
        _isProcessing = true;
      });

      _showProcessingDialog();

      try {
        final response = await http.post(
          Uri.parse(NetworkURL.registrasi()),
          body: {
            "nik": _nikController.text.trim(),
            "name": _namaController.text.trim(),
            "nama_loket": _namaLoketController.text.trim(),
            "no_hp": _noHPController.text.trim(),
            "alamat": _alamatController.text.trim(),
            "email": _emailController.text.trim(),
            "password": _passwordController.text.trim(),
          },
        ).timeout(const Duration(seconds: 30));

        if (!mounted) return;

        _dismissProcessingDialog();

        final data = jsonDecode(response.body);
        int code = data['meta']['code'];
        String message = data['meta']['message'];

        if (code == 200) {
          _showSuccessDialog(message);
        } else {
          _showErrorDialog(code, data, message);
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
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Anda harus menyetujui syarat dan ketentuan')),
      );
    }
  }

  void _showSuccessDialog(String message) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, dialogWidget) {
        return WillPopScope(
          onWillPop: () async {
            _dismissProcessingDialog();
            return false;
          },
          child: Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: AppColor.putih,
                title: Column(
                  children: [
                    Lottie.asset(
                      'assets/animations/high_five.json',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                      repeat: true,
                      reverse: true,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Registrasi Berhasil",
                      style: GoogleFonts.fredoka(
                        fontSize: 22,
                        color: AppColor.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  message,
                  style: GoogleFonts.fredoka(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        widget.reload();
                      },
                      child: Text(
                        "Lanjutkan",
                        style: GoogleFonts.fredoka(
                          color: AppColor.putih,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: false,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) => const SizedBox(),
    );
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

    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return WillPopScope(
          onWillPop: () async {
            _dismissProcessingDialog();
            return false;
          },
          child: Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: AppColor.putih,
                title: Column(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      "Registrasi Gagal",
                      style: GoogleFonts.fredoka(
                        fontSize: 22,
                        color: AppColor.black,
                        fontWeight: FontWeight.bold,
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
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "Coba Lagi",
                        style: GoogleFonts.fredoka(
                          color: AppColor.putih,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) => const SizedBox(),
    );
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
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_dasar.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
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
                              const SizedBox(height: 10),
                              _buildTextField(
                                controller: _nikController,
                                hintText: "NIK Pemilik Loket",
                                prefixIcon: Icons.credit_card,
                                keyboardType: TextInputType.number,
                                validator: _validateNIK,
                                errorMaxLines: 2,
                                inputFormatters: [
                                  nikFormatter,
                                  LengthLimitingTextInputFormatter(16),
                                ],
                              ),
                              const SizedBox(height: 15),
                              _buildTextField(
                                controller: _namaController,
                                hintText: "Nama Lengkap Pemilik Loket",
                                prefixIcon: Icons.person,
                                validator: (value) => value!.isEmpty
                                    ? "Masukkan nama lengkap"
                                    : null,
                                errorMaxLines: 5,
                                textCapitalization: TextCapitalization.words,
                              ),
                              const SizedBox(height: 15),
                              _buildTextField(
                                controller: _namaLoketController,
                                hintText: "Nama Loket",
                                prefixIcon: Icons.store,
                                validator: (value) => value!.isEmpty
                                    ? "Masukkan nama loket"
                                    : null,
                                errorMaxLines: 5,
                                textCapitalization: TextCapitalization.words,
                              ),
                              const SizedBox(height: 15),
                              _buildTextField(
                                controller: _noHPController,
                                hintText: "No HP",
                                prefixIcon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                validator: (value) =>
                                    value!.isEmpty ? "Masukkan no hp" : null,
                                errorMaxLines: 5,
                              ),
                              const SizedBox(height: 15),
                              _buildTextField(
                                controller: _alamatController,
                                hintText: "Alamat Lengkap",
                                prefixIcon: Icons.location_on,
                                validator: (value) => value!.isEmpty
                                    ? "Masukkan alamat lengkap"
                                    : null,
                                errorMaxLines: 5,
                                textCapitalization: TextCapitalization.words,
                              ),
                              const SizedBox(height: 15),
                              _buildTextField(
                                controller: _emailController,
                                hintText: "Email",
                                prefixIcon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Masukkan email';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Email tidak valid';
                                  }
                                  return null;
                                },
                                errorMaxLines: 2,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                errorMaxLines: 5,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _agreeToTerms = value!;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Saya menyetujui syarat dan ketentuan yang berlaku",
                                      style: GoogleFonts.fredoka(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                  ),
                                  onPressed: _isProcessing ? null : _submit,
                                  child: _isProcessing
                                      ? const CircularProgressIndicator(
                                          color: AppColor.textColor)
                                      : Text(
                                          'DAFTAR',
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
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Sudah punya akun? Login",
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
        ),
      ),
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
    List<TextInputFormatter>? inputFormatters,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      textCapitalization: textCapitalization,
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
}

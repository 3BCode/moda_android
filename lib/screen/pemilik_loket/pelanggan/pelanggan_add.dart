import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/components/show_processing_dialog.dart';
import 'package:moda/model/pelanggan_model.dart';
import 'package:moda/service/api_pelanggan_service.dart';

class PelangganAdd extends StatefulWidget {
  final VoidCallback reload;
  const PelangganAdd(this.reload, {super.key});

  @override
  State<PelangganAdd> createState() => _PelangganAddState();
}

class _PelangganAddState extends State<PelangganAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nmPenumpangController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();

  bool isLoading = false;
  bool _isDialogShowing = false;

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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _showProcessingDialog();

      try {
        final formattedPhoneNumber = formatPhoneNumber(_noHpController.text);

        final newPelanggan = PelangganModel(
          nmPenumpang: _nmPenumpangController.text,
          noHp: formattedPhoneNumber,
        );

        final response =
            await ApiPelangganService().createPelanggan(newPelanggan);
        setState(() {
          isLoading = false;
        });
        _dismissProcessingDialog();
        widget.reload();
        if (!mounted) return;
        _showSuccessDialog(
            response['meta']['message'] ?? 'Pelanggan berhasil ditambahkan');
      } catch (e) {
        print('Error : $e');
        setState(() {
          isLoading = false;
        });
        _dismissProcessingDialog();
        if (!mounted) return;
        _showErrorDialog(e is FormatException
            ? e.message
            : e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  void _showSuccessDialog(String message) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, dialogWidget) {
        return Transform.scale(
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
                    "Pelanggan Berhasil Ditambahkan",
                    style: GoogleFonts.fredoka(
                      fontSize: 15,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
              content: Text(
                message,
                style: GoogleFonts.fredoka(fontSize: 12),
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
                      "Selesai",
                      style: GoogleFonts.fredoka(
                        color: AppColor.putih,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
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

  void _showErrorDialog(String message) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
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
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    "Gagal Menambahkan Pelanggan",
                    style: GoogleFonts.fredoka(
                      fontSize: 15,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
              content: Text(
                message,
                style: GoogleFonts.fredoka(fontSize: 12),
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
                      ),
                    ),
                  ),
                ),
              ],
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
    return Scaffold(
      backgroundColor: AppColor.putih,
      appBar: AppBar(
        title: Text(
          "Tambah Pelanggan",
          style: GoogleFonts.fredoka(
            fontSize: 20.0,
            color: AppColor.putih,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.putih),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Data Pelanggan",
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _nmPenumpangController,
                            labelText: "Nama",
                            hintText: "Masukkan nama",
                            isRequired: true,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _noHpController,
                            labelText: "Nomor HP",
                            hintText: "Masukkan nomor HP",
                            isRequired: true,
                            prefix: "+62 ",
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonColor,
                        foregroundColor: AppColor.putih,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        elevation: 0,
                      ),
                      onPressed: isLoading ? null : _submitForm,
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: AppColor.putih,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'SIMPAN',
                              style: GoogleFonts.fredoka(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatPhoneNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'[^\d]+'), '');

    if (phone.startsWith('62')) {
      phone = phone.substring(2);
    }

    phone = phone.replaceFirst(RegExp(r'^0+'), '');

    if (phone.length < 9 || phone.length > 12) {
      throw const FormatException('Nomor telepon tidak valid');
    }

    return '+62$phone';
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    bool isRequired = false,
    String? prefix,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: labelText,
            style: GoogleFonts.fredoka(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    )
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            if (prefix != null)
              Positioned(
                left: 0,
                child: Text(
                  prefix,
                  style: GoogleFonts.fredoka(
                    color: AppColor.black,
                    fontSize: 16,
                  ),
                ),
              ),
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              style: GoogleFonts.fredoka(color: AppColor.black, fontSize: 16),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle:
                    GoogleFonts.fredoka(color: Colors.grey[400], fontSize: 16),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.accentColor),
                ),
                contentPadding: EdgeInsets.only(
                  left: prefix != null ? 40 : 0,
                  bottom: 8,
                  top: 8,
                ),
                filled: false,
              ),
              validator: (value) {
                if (isRequired && (value == null || value.isEmpty)) {
                  return 'Field ini wajib diisi';
                }
                if (labelText == "Nomor HP") {
                  try {
                    String formattedNumber = formatPhoneNumber(value!);
                    if (formattedNumber.length < 14 ||
                        formattedNumber.length > 15) {
                      return 'Nomor HP tidak valid';
                    }
                  } catch (e) {
                    return 'Nomor HP tidak valid';
                  }
                }
                return null;
              },
              inputFormatters: labelText == "Nomor HP"
                  ? [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(14),
                    ]
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

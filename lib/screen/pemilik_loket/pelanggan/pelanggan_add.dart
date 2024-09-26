import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moda/components/app_color.dart';
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final newPelanggan = PelangganModel(
        nmPenumpang: _nmPenumpangController.text,
        noHp: _noHpController.text,
      );
      try {
        final response =
            await ApiPelangganService().createPelanggan(newPelanggan);
        setState(() {
          isLoading = false;
        });
        widget.reload();
        if (!mounted) return;
        _showSuccessDialog(response['meta']['message']);
      } catch (e) {
        print('Error : $e');
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;
        _showErrorDialog('$e');
      }
    }
  }

  void _showSuccessDialog(String message) {
    // Existing success dialog implementation
  }

  void _showErrorDialog(String message) {
    // Existing error dialog implementation
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonColor,
                      foregroundColor: AppColor.putih,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    onPressed: isLoading ? null : _submitForm,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColor.putih,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Tambah Pelanggan',
                            style: GoogleFonts.fredoka(
                              fontSize: 16,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    bool isRequired = false,
    String? prefix,
    TextInputType keyboardType = TextInputType.text,
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
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}

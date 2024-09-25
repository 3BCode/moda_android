// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moda/components/app_color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  const CustomButton(this.text, {super.key, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColor.all,
              AppColor.all,
            ],
          )),
      child: Text(
        // ignore: unnecessary_string_interpolations
        "$text",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

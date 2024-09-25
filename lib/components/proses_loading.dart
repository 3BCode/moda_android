import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/components/loading_animation.dart';

class ProsesLoading extends StatelessWidget {
  const ProsesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          minWidth: 200,
        ),
        decoration: BoxDecoration(
          color: AppColor.putih.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColor.abus.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tunggu Sebentar',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 12,
                color: Colors.black87,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 35,
              height: 35,
              child: LoadingAnimation(),
            ),
            const SizedBox(height: 6),
            Text(
              'Sedang memuat',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 10,
                color: Colors.black54,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppColor {
  static const Color all = Color(0xFF1DA0DE);
  static const putih = Colors.white;
  static const abu = Color(0xFFA9A9A9);
  static const abus = Color(0xFFF7F7F7);
  static const Color backgroundColor = Color(0xFF40B449);
  static const Color red = Colors.red;
  static const Color black = Colors.black;

  static const MaterialColor customSwatch = MaterialColor(
    0xFF40B449,
    <int, Color>{
      50: Color(0xFFE3F2E5),
      100: Color(0xFFB8E6BA),
      200: Color(0xFF8FDB8E),
      300: Color(0xFF65D063),
      400: Color(0xFF48C64C),
      500: Color(0xFF40B449),
      600: Color(0xFF39A042),
      700: Color(0xFF328C3A),
      800: Color(0xFF2B7833),
      900: Color(0xFF1D5B25),
    },
  );

  static final LinearGradient backgroundGradient = LinearGradient(
    colors: [
      customSwatch[400]!,
      customSwatch[600]!,
      customSwatch[800]!,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [0.0, 0.5, 1.0],
  );

  static const Color buttonColor = Color(0xFF388E3C);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color accentColor = Color(0xFFFFC107);
}

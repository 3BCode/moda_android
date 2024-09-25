import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/screen/auth/login.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColor.backgroundColor,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Login(),
      theme: ThemeData(
        primarySwatch: AppColor.customSwatch,
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: AppColor.backgroundColor,
            statusBarIconBrightness: Brightness.light,
          ),
          child: child!,
        );
      },
    );
  }
}

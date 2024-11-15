import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:libremovies/providers/movie.dart';
import 'package:libremovies/screens/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.system;
    ThemeData themeData = ThemeData(primaryColor: const Color(0XFFD11D27));
    Get.put(MovieProvider());
    return GetMaterialApp(
      theme: themeData,
      home: const HomeScreen(),
    );
  }
}

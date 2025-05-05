import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Pastikan jalur ini benar, tergantung pada lokasi file splash_screen.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData.dark(),
      home: SplashScreen(), // SplashScreen sebagai halaman pertama
    );
  }
}

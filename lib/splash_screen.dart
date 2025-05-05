import 'package:flutter/material.dart';
import 'dart:async'; // Untuk Timer
import 'screen/calculator_screen.dart'; // Jika berada di folder screens


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Timer ini akan menavigasi ke CalculatorScreen setelah 3 detik
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CalculatorScreen()), // Pindah ke CalculatorScreen
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/images/splashs.png', // Jalur gambar di folder assets
          width: 400, // Sesuaikan lebar gambar
          height: 400, // Sesuaikan tinggi gambar
        ),
      ),
    );
  }
}

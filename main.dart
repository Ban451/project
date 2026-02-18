import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StayVue',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A8A), // Biru tua yang lebih elegan
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyLarge: GoogleFonts.poppins(color: Colors.black87),
          bodyMedium: GoogleFonts.poppins(color: Colors.black54),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB), // Biru yang lebih cerah untuk tombol
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
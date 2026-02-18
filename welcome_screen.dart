import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';
import 'guest/guest_home_screen.dart';
import 'user/user_home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final AuthService _authService = AuthService();

  // Navigasi berdasarkan role
  void _navigateToHome() {
    if (_authService.isGuest) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GuestHomeScreen()),
      );
    } else if (_authService.isRegularUser) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserHomeScreen()),
      );
    }
  }

  // Handle skip (login sebagai guest)
  void _handleSkip() {
    _authService.loginAsGuest();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Anda masuk sebagai Tamu'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
    
    Future.delayed(const Duration(milliseconds: 500), () {
      _navigateToHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'SV',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title
              Text(
                'Selamat Datang di',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              
              Text(
                'stayvue',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'Temukan kenyamanan menginap bersama kami',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(flex: 3),
              
              // Buttons
              Column(
                children: [
                  // Login Member
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Skip / Guest Button
                  TextButton(
                    onPressed: _handleSkip,
                    child: Text(
                      'Lewati',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
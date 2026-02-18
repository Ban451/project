import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../login_screen.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jelajahi Hotel',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E3A8A),
              ),
            ),
            Text(
              'Login untuk akses semua fitur',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          // Guest Badge
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.person_outline, size: 14, color: Colors.orange[700]),
                const SizedBox(width: 4),
                Text(
                  'Guest',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Login
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dapatkan Fitur Lengkap!',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Login untuk booking hotel, menyimpan favorit, dan promo eksklusif',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E3A8A),
                    ),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
            
            // Hotel List (Read-only)
            _buildHotelList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHotelList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
                child: const Center(
                  child: Icon(Icons.hotel, color: Colors.white, size: 50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hotel Contoh ${index + 1}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Login untuk lihat harga & booking',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock, size: 20, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
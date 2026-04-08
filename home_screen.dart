import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../models/hotel.dart';
import 'login_screen.dart';
import 'booking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _authService.isRegularUser ? _buildFAB() : null,
    );
  }

  // AppBar berbeda untuk Guest vs User
  AppBar _buildAppBar() {
    String title =
        _authService.isGuest ? 'Jelajahi Hotel' : 'Cari Hotel Impianmu';

    String subtitle = _authService.isGuest
        ? 'Login untuk akses semua fitur'
        : 'Halo, ${_authService.currentUser?.name ?? 'User'}!';

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E3A8A),
            ),
          ),
        ],
      ),
      actions: [
        // Badge berbeda untuk Guest vs User
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _authService.isGuest
                ? Colors.orange.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                _authService.isGuest
                    ? Icons.person_outline
                    : Icons.verified_user,
                size: 14,
                color: _authService.isGuest
                    ? Colors.orange[700]
                    : Colors.green[700],
              ),
              const SizedBox(width: 4),
              Text(
                _authService.isGuest ? 'Guest' : 'Member',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: _authService.isGuest
                      ? Colors.orange[700]
                      : Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Body dengan fitur berbeda
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner khusus Guest (mengajak login)
          if (_authService.isGuest) _buildGuestBanner(),

          // Search Bar (sama untuk semua)
          _buildSearchBar(),

          // Categories (sama untuk semua)
          _buildCategories(),

          // Hotel List dengan fitur berbeda
          _buildHotelList(),
        ],
      ),
    );
  }

  // Banner khusus Guest
  Widget _buildGuestBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
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
                  'Login untuk booking hotel dan menyimpan favorit',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
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
    );
  }

  // Search Bar (sama untuk semua)
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari hotel, lokasi...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFF2563EB)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.tune, color: Color(0xFF2563EB)),
              onPressed: _authService.isGuest
                  ? _showLoginRequiredDialog // Guest: minta login
                  : _showFilterDialog, // User: buka filter
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  // Categories (sama untuk semua)
  Widget _buildCategories() {
    final categories = ['Hotel', 'Villa', 'Apartemen', 'Resort'];
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hotel, color: const Color(0xFF2563EB)),
                const SizedBox(height: 4),
                Text(
                  categories[index],
                  style: GoogleFonts.poppins(fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Hotel List dengan fitur berbeda
  Widget _buildHotelList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: Hotel.sampleHotels.length,
      itemBuilder: (context, index) {
        final hotel = Hotel.sampleHotels[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              // Hotel Image (sama)
              Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        hotel.images[0],
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                    // Favorite button hanya untuk User
                    if (_authService.isRegularUser)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.favorite_border,
                              color: Color(0xFF2563EB), size: 20),
                        ),
                      ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hotel.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                hotel.location,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Harga hanya untuk User
                        if (_authService.isRegularUser)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp ${hotel.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                              Text(
                                '/malam',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Booking button berbeda
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _authService.isGuest
                            ? _showLoginRequiredDialog // Guest: minta login
                            : () =>
                                _navigateToBooking(hotel), // User: ke booking
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _authService.isGuest
                              ? Colors.grey
                              : const Color(0xFF2563EB),
                        ),
                        child: Text(
                          _authService.isGuest
                              ? 'Login untuk Booking'
                              : 'Booking Sekarang',
                        ),
                      ),
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

  // Bottom Navigation Bar berbeda untuk Guest vs User
  Widget _buildBottomNavBar() {
    // Guest: hanya 3 menu
    if (_authService.isGuest) {
      return BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index > 1) {
            // Profile menu
            _showLoginRequiredDialog();
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      );
    }

    // User: 5 menu lengkap
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: Colors.grey[400],
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Booking'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }

  // FAB hanya untuk User
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => _showSnackbar('Buat Pemesanan Cepat'),
      backgroundColor: const Color(0xFF2563EB),
      child: const Icon(Icons.add),
    );
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Diperlukan', style: GoogleFonts.poppins()),
        content: Text(
          'Silakan login terlebih dahulu untuk mengakses fitur ini',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Nanti'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    // Implementasi filter untuk user
  }

  void _navigateToBooking(Hotel hotel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(hotel: hotel),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  int _selectedTab = 0; // 0: Semua, 1: Hotel, 2: Villa, 3: Resort

  final AuthService _authService = AuthService();

  // Data Hotel
  final List<Map<String, dynamic>> _hotels = [
    {
      'id': 1,
      'name': 'Grand Hyatt Jakarta',
      'location': 'Jakarta Pusat',
      'price': 850000,
      'rating': 4.8,
      'reviews': 2450,
      'image': 'hotel1',
      'facilities': ['Kolam Renang', 'Spa', 'Restoran', 'Gym'],
      'available': true,
      'discount': 20,
      'type': 'Hotel',
    },
    {
      'id': 2,
      'name': 'The Ritz-Carlton',
      'location': 'Jakarta Selatan',
      'price': 1200000,
      'rating': 4.9,
      'reviews': 1890,
      'image': 'hotel2',
      'facilities': ['Kolam Renang', 'Spa', 'Restoran', 'Gym', 'Bar'],
      'available': true,
      'discount': 15,
      'type': 'Hotel',
    },
    {
      'id': 3,
      'name': 'Aryaduta Hotel',
      'location': 'Jakarta Pusat',
      'price': 650000,
      'rating': 4.5,
      'reviews': 3200,
      'image': 'hotel3',
      'facilities': ['Kolam Renang', 'Restoran', 'Gym'],
      'available': true,
      'discount': 0,
      'type': 'Hotel',
    },
    {
      'id': 4,
      'name': 'Pullman Hotel',
      'location': 'Jakarta Barat',
      'price': 950000,
      'rating': 4.7,
      'reviews': 1560,
      'image': 'hotel4',
      'facilities': ['Kolam Renang', 'Spa', 'Restoran', 'Gym'],
      'available': false,
      'discount': 10,
      'type': 'Hotel',
    },
    {
      'id': 5,
      'name': 'The Laguna Villa',
      'location': 'Bandung',
      'price': 1500000,
      'rating': 4.8,
      'reviews': 890,
      'image': 'villa1',
      'facilities': ['Private Pool', 'Garden', 'BBQ'],
      'available': true,
      'discount': 25,
      'type': 'Villa',
    },
    {
      'id': 6,
      'name': 'Mulia Resort',
      'location': 'Bali',
      'price': 2100000,
      'rating': 4.9,
      'reviews': 3450,
      'image': 'resort1',
      'facilities': ['Private Beach', 'Spa', 'Restoran'],
      'available': true,
      'discount': 30,
      'type': 'Resort',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Filter hotel berdasarkan tab yang dipilih
  List<Map<String, dynamic>> get _filteredHotels {
    if (_selectedTab == 0) return _hotels;
    if (_selectedTab == 1)
      return _hotels.where((h) => h['type'] == 'Hotel').toList();
    if (_selectedTab == 2)
      return _hotels.where((h) => h['type'] == 'Villa').toList();
    if (_selectedTab == 3)
      return _hotels.where((h) => h['type'] == 'Resort').toList();
    return _hotels;
  }

  // Cek apakah user bisa melakukan booking
  bool get _canBook => !_authService.isGuest;

  // Navigasi ke login
  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  // Handle booking
  void _handleBooking(Map<String, dynamic> hotel) {
    if (_canBook) {
      _showSnackbar('Booking ${hotel['name']}');
      // Navigasi ke halaman booking
    } else {
      _showLoginRequiredDialog('booking');
    }
  }

  // Handle favorite
  void _handleFavorite(Map<String, dynamic> hotel) {
    if (_canBook) {
      _showSnackbar('${hotel['name']} ditambahkan ke favorit');
      // Tambah ke favorit
    } else {
      _showLoginRequiredDialog('menyimpan favorit');
    }
  }

  // Dialog untuk login
  void _showLoginRequiredDialog(String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Login Diperlukan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Anda perlu login untuk $action. Lanjutkan ke halaman login?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Nanti',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToLogin();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
            ),
            child: Text(
              'Login',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner untuk guest
                if (_authService.isGuest) _buildGuestBanner(),

                // Hero Section
                _buildHeroSection(),

                // Search Section
                _buildSearchSection(),

                // Categories Tab
                _buildCategoriesTab(),

                // Special Offers
                _buildSpecialOffers(),

                // Hotel List
                _buildHotelList(),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    String greeting = _authService.isGuest
        ? 'Halo, Tamu!'
        : _authService.isAdmin
            ? 'Halo, Admin!'
            : 'Halo, ${_authService.currentUser?.name ?? 'User'}!';

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              'SV',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            _authService.isAdmin ? 'Dashboard Admin' : 'Cari Hotel Impianmu',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E3A8A),
            ),
          ),
        ],
      ),
      actions: [
        // Role Badge
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _authService.isGuest
                ? Colors.orange.withOpacity(0.1)
                : _authService.isAdmin
                    ? Colors.purple.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _authService.isGuest
                  ? Colors.orange.withOpacity(0.3)
                  : _authService.isAdmin
                      ? Colors.purple.withOpacity(0.3)
                      : Colors.green.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _authService.isGuest
                    ? Icons.person_outline
                    : _authService.isAdmin
                        ? Icons.admin_panel_settings
                        : Icons.verified_user,
                size: 14,
                color: _authService.isGuest
                    ? Colors.orange[700]
                    : _authService.isAdmin
                        ? Colors.purple[700]
                        : Colors.green[700],
              ),
              const SizedBox(width: 4),
              Text(
                _authService.isGuest
                    ? 'Guest'
                    : _authService.isAdmin
                        ? 'Admin'
                        : 'Member',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: _authService.isGuest
                      ? Colors.orange[700]
                      : _authService.isAdmin
                          ? Colors.purple[700]
                          : Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Notification (hanya untuk user yang login)
        if (!_authService.isGuest)
          Stack(
            children: [
              IconButton(
                icon:
                    Icon(Icons.notifications_outlined, color: Colors.grey[700]),
                onPressed: () => _showSnackbar('Notifikasi'),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildGuestBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.info, color: Colors.orange[700], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mode Tamu',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Login untuk booking hotel dan menyimpan favorit',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _navigateToLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 160,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.hotel,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Diskon Spesial!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Dapatkan diskon hingga 30% untuk booking hotel pertama Anda',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Gunakan Kode: STAY30',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Search Bar
          Container(
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
                hintText: 'Cari hotel, lokasi, atau destinasi...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: const Color(0xFF2563EB),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: const Color(0xFF2563EB),
                      ),
                      onPressed: () => _showFilterDialog(),
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Date & Guest Selection
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.calendar_today,
                  label: 'Check-in',
                  value: '12 Jun 2024',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.calendar_today,
                  label: 'Check-out',
                  value: '15 Jun 2024',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.people,
                  label: 'Tamu',
                  value: '2 Dewasa',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.king_bed,
                  label: 'Kamar',
                  value: '1 Kamar',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2563EB)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Jenis Penginapan',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E3A8A),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildCategoryChip('Semua', Icons.apps, 0),
              _buildCategoryChip('Hotel', Icons.hotel, 1),
              _buildCategoryChip('Villa', Icons.villa, 2),
              _buildCategoryChip('Resort', Icons.beach_access, 3),
              _buildCategoryChip('Apartemen', Icons.apartment, 4),
              _buildCategoryChip('Homestay', Icons.house, 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF2563EB),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialOffers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Penawaran Spesial',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              TextButton(
                onPressed: () => _showSnackbar('Lihat semua'),
                child: Text(
                  'Lihat Semua',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              final discounts = [30, 25, 20];
              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2563EB).withOpacity(0.9),
                      const Color(0xFF1E3A8A).withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Diskon ${discounts[index]}%',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Untuk booking minimal 2 malam',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Kode: HOTEL${discounts[index]}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHotelList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedTab == 0
                    ? 'Rekomendasi Hotel'
                    : _selectedTab == 1
                        ? 'Hotel Populer'
                        : _selectedTab == 2
                            ? 'Villa Eksklusif'
                            : 'Resort Mewah',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              if (!_authService.isGuest)
                Row(
                  children: [
                    Icon(Icons.sort, size: 16, color: const Color(0xFF2563EB)),
                    const SizedBox(width: 4),
                    Text(
                      'Filter',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _filteredHotels.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildHotelCard(_filteredHotels[index]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return GestureDetector(
      onTap: () => _showHotelDetail(hotel),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Hotel Image
            Stack(
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.hotel,
                      size: 60,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
                if (!hotel['available'])
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Sold Out',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (hotel['discount'] > 0)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Diskon ${hotel['discount']}%',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${hotel['rating']}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' (${hotel['reviews']})',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Hotel Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotel['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 12, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Text(
                                  hotel['location'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Favorite button (hanya untuk user yang login)
                      if (!_authService.isGuest)
                        IconButton(
                          icon: Icon(Icons.favorite_border,
                              color: Colors.grey[400]),
                          onPressed: () => _handleFavorite(hotel),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Facilities
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hotel['facilities'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            hotel['facilities'][index],
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: const Color(0xFF2563EB),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Price and Book Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hotel['discount'] > 0)
                            Text(
                              'Rp ${(hotel['price'] * (100 + hotel['discount']) / 100).toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[500],
                              ),
                            ),
                          Row(
                            children: [
                              Text(
                                'Rp ${hotel['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                              Text(
                                ' /malam',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Booking button
                      ElevatedButton(
                        onPressed: hotel['available']
                            ? () => _handleBooking(hotel)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _canBook ? const Color(0xFF2563EB) : Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          _canBook ? 'Booking' : 'Login to Book',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });

        // Untuk guest, beberapa menu mungkin perlu login
        if (_authService.isGuest && (index == 2 || index == 3)) {
          _showLoginRequiredDialog('mengakses menu ini');
          setState(() {
            _selectedIndex = 0; // Kembali ke beranda
          });
        } else {
          String menu = ['Beranda', 'Cari', 'Pesanan', 'Profil'][index];
          _showSnackbar(menu);
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: Colors.grey[400],
      selectedLabelStyle:
          GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: 'Beranda'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined), label: 'Cari'),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bookmark_outline,
            color: _authService.isGuest ? Colors.grey[400] : null,
          ),
          label: 'Pesanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            color: _authService.isGuest ? Colors.grey[400] : null,
          ),
          label: 'Profil',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    // Hanya tampil untuk user yang login (bukan guest)
    if (_authService.isGuest) return const SizedBox.shrink();

    return Container(
      height: 70,
      width: 70,
      margin: const EdgeInsets.only(bottom: 10),
      child: FloatingActionButton(
        onPressed: () => _showSnackbar('Buat Pemesanan'),
        backgroundColor: const Color(0xFF2563EB),
        elevation: 4,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white, size: 24),
              Text(
                'Pesan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    // Filter hanya untuk user yang login
    if (_authService.isGuest) {
      _showLoginRequiredDialog('menggunakan filter');
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Filter Pencarian',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildFilterOption('Harga', 'Rp 500rb - Rp 2jt'),
                  _buildFilterOption('Bintang Hotel', '5 Bintang'),
                  _buildFilterOption('Fasilitas', 'Kolam Renang, Spa, Gym'),
                  _buildFilterOption('Jarak', '< 5 km'),
                  _buildFilterOption('Review', '4.5+'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: Color(0xFF2563EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Reset',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF2563EB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showSnackbar('Filter diterapkan');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Terapkan',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 18, color: Colors.grey[500]),
            ],
          ),
        ],
      ),
    );
  }

  void _showHotelDetail(Map<String, dynamic> hotel) {
    _showSnackbar('Detail ${hotel['name']}');
    // Navigasi ke halaman detail hotel
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        duration: const Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

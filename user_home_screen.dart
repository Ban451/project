import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

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
              'Halo, User!',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Cari Hotel Impianmu',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E3A8A),
              ),
            ),
          ],
        ),
        actions: [
          // User Badge
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_user, size: 14, color: Colors.green[700]),
                const SizedBox(width: 4),
                Text(
                  'Member',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.green[700],
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
            // Search Bar
            Padding(
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
                      onPressed: () => _showFilterDialog(),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
            
            // Categories
            _buildCategories(),
            
            // Hotel List with Booking
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
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
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
                  'Hotel',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          );
        },
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
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(Icons.hotel, color: Colors.white, size: 50),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
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
                                'Hotel Mewah ${index + 1}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text('4.8', style: GoogleFonts.poppins()),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                  Text(' Jakarta', style: GoogleFonts.poppins(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Rp 850.000',
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigasi ke booking
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Booking Sekarang'),
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

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Filter options here
          ],
        ),
      ),
    );
  }
}
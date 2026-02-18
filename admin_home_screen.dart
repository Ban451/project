import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
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
              'Dashboard Admin',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E3A8A),
              ),
            ),
            Text(
              'Kelola sistem booking hotel',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          // Admin Badge
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.admin_panel_settings, size: 14, color: Colors.purple[700]),
                const SizedBox(width: 4),
                Text(
                  'Admin',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.purple[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard('Total Hotel', '24', Icons.hotel, Colors.blue),
                _buildStatCard('Total User', '156', Icons.people, Colors.green),
                _buildStatCard('Booking Aktif', '45', Icons.bookmark, Colors.orange),
                _buildStatCard('Pendapatan', 'Rp 125jt', Icons.money, Colors.purple),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Management Menu
            Text(
              'Menu Manajemen',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildManagementMenu(
              'Kelola Hotel',
              Icons.hotel,
              Colors.blue,
              () => _showSnackbar('Menu Kelola Hotel'),
            ),
            _buildManagementMenu(
              'Kelola User',
              Icons.people,
              Colors.green,
              () => _showSnackbar('Menu Kelola User'),
            ),
            _buildManagementMenu(
              'Kelola Booking',
              Icons.bookmark,
              Colors.orange,
              () => _showSnackbar('Menu Kelola Booking'),
            ),
            _buildManagementMenu(
              'Laporan',
              Icons.bar_chart,
              Colors.purple,
              () => _showSnackbar('Menu Laporan'),
            ),
            _buildManagementMenu(
              'Pengaturan',
              Icons.settings,
              Colors.grey,
              () => _showSnackbar('Menu Pengaturan'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Hotels'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementMenu(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../models/hotel.dart';
import 'admin_profile_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final AuthService authService = AuthService();
  int _selectedIndex = 0;

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
            Text('Dashboard Admin', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF1E3A8A))),
            Text('Kelola sistem booking hotel', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF2563EB)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminProfileScreen()));
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Icon(Icons.admin_panel_settings, size: 14, color: Colors.purple[700]),
                const SizedBox(width: 4),
                Text('Admin', style: GoogleFonts.poppins(fontSize: 12, color: Colors.purple[700], fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildDashboard() : _buildManageHotels(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
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

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text('Menu Manajemen', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildManagementMenu('Kelola Hotel', Icons.hotel, Colors.blue, () => setState(() => _selectedIndex = 1)),
          _buildManagementMenu('Kelola User', Icons.people, Colors.green, () => _showSnackbar('Kelola User')),
          _buildManagementMenu('Kelola Booking', Icons.bookmark, Colors.orange, () => _showSnackbar('Kelola Booking')),
          _buildManagementMenu('Laporan Penjualan', Icons.bar_chart, Colors.purple, () => _showSnackbar('Laporan')),
          _buildManagementMenu('Pengaturan', Icons.settings, Colors.grey, () => _showSnackbar('Pengaturan')),
        ],
      ),
    );
  }

  Widget _buildManageHotels() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: Hotel.sampleHotels.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showAddHotelDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Hotel Baru'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), padding: const EdgeInsets.symmetric(vertical: 12)),
            ),
          );
        }
        final hotel = Hotel.sampleHotels[index - 1];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)])),
              child: Center(child: Text(hotel.images[0], style: const TextStyle(fontSize: 24))),
            ),
            title: Text(hotel.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text('Rp ${hotel.price.toString()} • ${hotel.location}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showEditHotelDialog(hotel)),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _showDeleteConfirmation(hotel)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color)),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
          Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildManagementMenu(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color)),
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showAddHotelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Hotel', style: GoogleFonts.poppins()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: const InputDecoration(labelText: 'Nama Hotel', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(decoration: const InputDecoration(labelText: 'Lokasi', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(decoration: const InputDecoration(labelText: 'Harga per Malam', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(onPressed: () { Navigator.pop(context); _showSnackbar('Hotel berhasil ditambahkan'); }, child: const Text('Simpan')),
        ],
      ),
    );
  }

  void _showEditHotelDialog(Hotel hotel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Hotel', style: GoogleFonts.poppins()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: const InputDecoration(labelText: 'Nama Hotel'), controller: TextEditingController(text: hotel.name)),
              const SizedBox(height: 12),
              TextField(decoration: const InputDecoration(labelText: 'Lokasi'), controller: TextEditingController(text: hotel.location)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(onPressed: () { Navigator.pop(context); _showSnackbar('Hotel berhasil diupdate'); }, child: const Text('Update')),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Hotel hotel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Hotel', style: GoogleFonts.poppins()),
        content: Text('Apakah Anda yakin ingin menghapus ${hotel.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(onPressed: () { Navigator.pop(context); _showSnackbar('Hotel berhasil dihapus'); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Hapus')),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message, style: GoogleFonts.poppins()), behavior: SnackBarBehavior.floating));
  }
}
